import 'dart:async';

import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' show mustCallSuper;
import 'package:logging/logging.dart';

/// Log Line Information.
/// Used when extracting tag and attaching log line number value.
class LogLineInfo {
  static const _defaultTag = 'Dart';

  /// Tag extracted from stacktrace (usually class)
  String tag;

  /// Log file path.
  String? logFilePath;

  /// Line number of the log line.
  int lineNumber;

  /// Character at the log line.
  int characterIndex;

  static StackTrace getAssociatedStackTrace(LogRecord? record) {
    return record?.stackTrace ?? StackTrace.current;
  }

  /// Creates LogLineInfo instance.
  LogLineInfo({
    required this.tag,
    this.logFilePath,
    this.lineNumber = 0,
    this.characterIndex = 0,
  });

  static final _logMatcher = RegExp(
    r"([a-zA-Z\<\>\s\.]*)\s\(file:\/(.*\.dart):(\d*):(\d*)",
  );

  /// Gets [LogLineInfo] with [stackIndex]
  /// which provides data for tag and line of code
  factory LogLineInfo.get({
    int stackIndex = 4,
    LogRecord? record,
  }) {
    ///([a-zA-Z\<\>\s\.]*)\s\(file:\/(.*\.dart):(\d*):(\d*)
    /// group 1 = tag
    /// group 2 = filepath
    /// group 3 = line number
    /// group 4 = column
    /// "#4      main.<anonymous closure>.<anonymous closure> (file:///Users/magillus/Projects/opensource/flutter-fimber/fimber/test/fimber_test.dart:19:14)"
    var stackTraceList = getAssociatedStackTrace(record).toString().split('\n');
    if (stackTraceList.length > stackIndex) {
      var logline = stackTraceList[stackIndex];
      final matches = _logMatcher.allMatches(logline);

      if (matches.isNotEmpty) {
        final match = matches.first;
        return LogLineInfo(
          tag: match
                  .group(1)
                  ?.trim()
                  .replaceAll("<anonymous closure>", "<ac>") ??
              _defaultTag,
          logFilePath: match.group(2),
          lineNumber: int.tryParse(match.group(3) ?? '-1') ?? -1,
          characterIndex: int.tryParse(match.group(4) ?? '-1') ?? -1,
        );
      } else {
        return LogLineInfo(tag: _defaultTag);
      }
    } else {
      return LogLineInfo(tag: _defaultTag);
    }
  }

  /// Gets tag with [stackIndex],
  /// how many steps in stacktrace should be taken to grab log call.
  static String getTag({
    int stackIndex = 4,
    LogRecord? record,
  }) {
    var stackTraceList = getAssociatedStackTrace(record).toString().split('\n');
    if (stackTraceList.length > stackIndex) {
      var lineChunks =
          stackTraceList[stackIndex].replaceAll("<anonymous closure>", "<ac>");
      if (lineChunks.length > 6) {
        var lineParts = lineChunks.split(' ');
        if (lineParts.length > 8 && lineParts[6] == 'new') {
          // constructor logging
          return "${lineParts[6]} ${lineParts[7]}";
        } else if (lineParts.length > 6) {
          return lineParts[6];
        } else {
          return _defaultTag;
        }
      } else {
        return _defaultTag;
      }
    } else {
      return _defaultTag; //default
    }
  }

  /// Gets tag with [stackIndex]
  /// how many steps in stacktrace should be taken to grab log call.
  static List<String> getStacktrace({
    int stackIndex = 6,
    LogRecord? record,
  }) {
    var stackTraceList = getAssociatedStackTrace(record).toString().split('\n');
    return stackTraceList.sublist(stackIndex);
  }
}

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
  void onPlant() {
    _isPlanted = true;
  }

  void onFlutterError(FlutterErrorDetails details) {
    if (!isPlanted) return;
    final message = details.exceptionAsString();
    onRecord(LogRecord(
      Level.WARNING,
      message,
      'FlutterErrorDetails',
      details.exception,
      details.stack,
      Zone.current,
      details,
    ));
  }

  void onRecord(LogRecord record) {
    if (!isPlanted) return;
    final info = LogLineInfo.get(
      stackIndex: stackIndex,
      record: record,
    );
    log(record, info);
  }

  void log(
    LogRecord record,
    LogLineInfo info,
  );

  @mustCallSuper
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
    final _level = record.level.toString();
    final _tag = info.tag;
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

  PrintingLogsTree({
    this.maxLineSize = 800,
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

      final _wholeMessage =
          '$messageText$objectText$_errorText\n${stacktrace.toText()}';

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
    final _stacktrace = stackTrace.toText();
    final _message = '$messageText$objectText$_error\n$_stacktrace';
    printSingleLog(_message, level);
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
