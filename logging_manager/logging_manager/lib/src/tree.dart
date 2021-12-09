import 'package:ansicolor/ansicolor.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import 'manager.dart';
import 'line_info.dart';

/// An object that recieves logs from [Logger] and performs an action 
/// using them, example: Printing, Printing colored logs, Sending logs to analytics, etc.
/// 
/// This is attached as a listener to logs sent from logger by the [LoggingManager].
/// 
/// Some available trees:
///
/// - [PrintingColoredLogsTree]
/// - [PrintingLogsTree]
/// - [FormattedOutputLogsTree] (abstract class)
mixin LoggingTree {
  final int stackIndex = 4;

  bool _isPlanted = false;

  bool get isPlanted => _isPlanted;

  @mustCallSuper

  /// Attach this logging mechanism to a Manager.
  void onPlant() {
    _isPlanted = true;
  }

  /// Listener to records of log streams.
  void onRecord(LogRecord record) {
    if (!isPlanted) return;
    final info = LogLineInfo.get(
      stackIndex: stackIndex,
      record: record,
    );
    log(record, info);
  }

  /// Act on the log [record] with [info].
  void log(
    LogRecord record,
    LogLineInfo info,
  );

  @mustCallSuper

  /// De-attach this logging mechanism from a Manager.
  void onRemove() {
    _isPlanted = false;
  }
}

class FormattedStackTrace {
  final StackTrace stackTrace;

  FormattedStackTrace(this.stackTrace);

  String toText() {
    final tmpStacktrace = stackTrace.toString().split('\n');
    final stackTraceMessage = tmpStacktrace.map(
      (stackLine) {
        return "\t$stackLine";
      },
    ).join("\n");
    return stackTraceMessage;
  }

  @override
  String toString() => toText();
}

/// An abstract class that provides a formatted output for logs.
abstract class FormattedOutputLogsTree with LoggingTree {
  @override
  void log(
    LogRecord record,
    LogLineInfo info,
  ) {
    final _message = formatLog(record, info);
    final _object = formatObject(record.object);
    final _stacktrace = FormattedStackTrace(
      LogLineInfo.getAssociatedStackTrace(record),
    );
    logger(_message, _object, _stacktrace, record, info);
  }

  String formatLog(
    LogRecord record,
    LogLineInfo info,
  ) {
    final _timestamp = record.time.toIso8601String();
    final _level = record.level.name;
    final _tag = LogLineInfo.getTag(record: record);
    final _message = record.message;
    return '$_timestamp\t$_level $_tag: $_message';
  }

  String formatObject(Object? object) {
    if (object == null) return '';
    return '\n${object.toString()}';
  }

  void logger(
    String messageText,
    String objectText,
    FormattedStackTrace stacktrace,
    LogRecord record,
    LogLineInfo info,
  );
}

class PrintingLogsTree extends FormattedOutputLogsTree {
  /// Max limit that a log can reach to start dividing it into multiple chunks
  /// avoiding them to be cut by android log
  /// - when -1 will disable chunking of the logs
  final int maxLineSize;

  /// Value of [level.value] >= this will allow print of stacktrace
  final int stacktracePrintingThreshold;

  PrintingLogsTree({
    this.maxLineSize = 800,
    this.stacktracePrintingThreshold = 900,
  });

  @override
  void logger(
    String messageText,
    String objectText,
    FormattedStackTrace stacktrace,
    LogRecord record,
    LogLineInfo info,
  ) {
    if (maxLineSize == -1) {
      printWholeLog(
        messageText,
        objectText,
        record.level,
        record.error,
        stacktrace,
      );
    } else {
      final pattern = RegExp('.{1,$maxLineSize}');
      final _error = record.error;
      final _errorText = _error == null ? '' : '\n${_error.toString()}';
      final _stacktrace = getStacktraceAsTextForPrinting(
        stacktrace,
        record.level,
      );

      final _wholeMessage = '$messageText$objectText$_errorText$_stacktrace';

      final matches = pattern.allMatches(_wholeMessage);

      for (final match in matches) {
        final _group = match.group(0);
        if (_group == null) continue;
        printSingleLog(_group, record.level);
      }
    }
  }

  void printWholeLog(
    String messageText,
    String objectText,
    Level level,
    dynamic errors,
    FormattedStackTrace stackTrace,
  ) {
    final _error = errors == null ? '' : '\n${errors.toString()}';
    final _stacktrace = getStacktraceAsTextForPrinting(
      stackTrace,
      level,
    );
    final _message = '$messageText$objectText$_error$_stacktrace';
    printSingleLog(_message, level);
  }

  String getStacktraceAsTextForPrinting(
    FormattedStackTrace stacktrace,
    Level level,
  ) {
    if (level.value <= stacktracePrintingThreshold) {
      return '';
    }
    final _stacktrace = stacktrace.toText();
    return '\n$_stacktrace';
  }

  void printSingleLog(
    String messageText,
    Level level,
  ) {
    // ignore: avoid_print
    print(messageText);
  }
}

class AnsiColor {
  /// ANSI Control Sequence Introducer, signals the terminal for new settings.
  static const ansiEsc = '\x1B[';

  /// Reset all colors and options for current SGRs to terminal defaults.
  static const ansiDefault = '${ansiEsc}0m';

  static AnsiPen fg(int id) {
    final pen = AnsiPen();
    pen.xterm(id);
    return pen;
  }

  static AnsiPen grey() {
    final pen = AnsiPen();
    pen.gray(level: 2.5);
    return pen;
  }

  static AnsiPen none() {
    final pen = AnsiPen();
    pen.reset();
    return pen;
  }
}

class PrintingColoredLogsTree extends PrintingLogsTree {
  PrintingColoredLogsTree({
    int maxLineSize = 800,
    int stacktracePrintingThreshold = 900,
  }) : super(
          maxLineSize: maxLineSize,
          stacktracePrintingThreshold: stacktracePrintingThreshold,
        );

  static final levelColors = {
    Level.ALL: AnsiColor.grey(),
    Level.FINEST: AnsiColor.grey(),
    Level.FINER: AnsiColor.grey(),
    Level.FINE: AnsiColor.grey(),
    Level.CONFIG: AnsiColor.grey(),
    Level.INFO: AnsiColor.fg(12),
    Level.WARNING: AnsiColor.fg(208),
    Level.SEVERE: AnsiColor.fg(196),
    Level.SHOUT: AnsiColor.fg(199),
    Level.OFF: AnsiColor.none(),
  };

  @override
  void printSingleLog(
    String messageText,
    Level level,
  ) {
    final _pen = levelColors[level]!;
    // ignore: avoid_print
    print(_pen(messageText));
  }
}
