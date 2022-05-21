// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:ansicolor/ansicolor.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import 'manager.dart';
import 'printers.dart';
import 'stack_filter.dart';

const bool _kIsWeb = identical(0, 0.0);

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
abstract class LoggingTree {
  factory LoggingTree.printing({
    int maxLineSize = 800,
    int stacktraceLoggingThreshold = 900,
  }) {
    return PrintingLogsTree(
      maxLineSize: maxLineSize,
      stacktraceLoggingThreshold: stacktraceLoggingThreshold,
    );
  }

  factory LoggingTree.coloredPrinting({
    int maxLineSize = 800,
    int stacktraceLoggingThreshold = 900,
  }) {
    return PrintingColoredLogsTree(
      maxLineSize: maxLineSize,
      stacktraceLoggingThreshold: stacktraceLoggingThreshold,
    );
  }

  factory LoggingTree.noop() {
    return NoopLoggingTree();
  }

  final int stackIndex = 4;

  bool get isPlanted => _logsStreamSubscription != null;

  StreamSubscription<LogRecord>? _logsStreamSubscription;

  @mustCallSuper

  /// Attach this logging mechanism to a Manager.
  void onPlant(StreamSubscription<LogRecord>? subscription) {
    _logsStreamSubscription = subscription;
  }

  /// Listener to records of log streams.
  void onRecord(LogRecord record) {
    if (!isPlanted) return;
    log(record);
  }

  /// Act on the log [record] with [info].
  @protected
  void log(
    LogRecord record,
  );

  @mustCallSuper

  /// De-attach this logging mechanism from a Manager.
  void onRemove() {
    _logsStreamSubscription?.cancel();
    _logsStreamSubscription = null;
  }
}

class FormattedStacktrace {
  final StackTrace stackTrace;
  final String? formattedStackTrace;

  const FormattedStacktrace(this.stackTrace, this.formattedStackTrace);
}

class NoopLoggingTree with LoggingTree {
  @override
  void log(LogRecord record) {
    // Do nothing
  }
}

/// An abstract class that provides a formatted output for logs.
abstract class FormattedOutputLogsTree with LoggingTree {
  /// Value of [Level.value] >= this will allow print of stacktrace
  int get stacktraceLoggingThreshold => 900;

  bool willLogStackTrace(Level level) {
    return level.value >= stacktraceLoggingThreshold;
  }

  @override
  void log(LogRecord record) {
    final message = record.message;
    final object = _formatObject(record.object);
    final errorLabel = record.error?.toString();
    final stacktrace = _formatStackTrace(record.stackTrace, record.level);

    logger(message, object, errorLabel, stacktrace, record);
  }

  static String _formatObject(Object? object) {
    if (object == null) return '';
    return object.toString();
  }

  FormattedStacktrace _formatStackTrace(
    StackTrace? stacktrace,
    Level level,
  ) {
    final formatStacktrace = willLogStackTrace(level);
    final resolvedStacktrace = formatStacktrace
        ? (stacktrace ?? StackTrace.current)
        : (stacktrace ?? StackTrace.empty);
    return FormattedStacktrace(
      resolvedStacktrace,
      formatStacktrace
          ? _filterStacktrace(
              stackTrace: resolvedStacktrace,
              maxFrames: 100,
            )
          : null,
    );
  }

  static String _filterStacktrace({
    required StackTrace stackTrace,
    int? maxFrames,
  }) {
    Iterable<String> lines = stackTrace.toString().trimRight().split('\n');

    if (_kIsWeb && lines.isNotEmpty) {
      lines = lines.skipWhile((String line) {
        return line.contains('StackTrace.current') ||
            line.contains('dart-sdk/lib/_internal') ||
            line.contains('dart:sdk_internal');
      });
    }

    if (maxFrames != null) lines = lines.take(maxFrames);

    return StackFilterContainer.defaultStackFilter(lines).join('\n');
  }

  @protected
  void logger(
    String messageText,
    String objectText,
    String? errorLabel,
    FormattedStacktrace stacktrace,
    LogRecord record,
  );
}

class PrintingLogsTree extends FormattedOutputLogsTree {
  /// Max limit that a log can reach to start dividing it into multiple chunks
  /// avoiding them to be cut by android log
  /// - when -1 will disable chunking of the logs
  final int maxLineSize;

  /// Value of [level.value] >= this will allow print of stacktrace
  @override
  final int stacktraceLoggingThreshold;

  PrintingLogsTree({
    this.maxLineSize = 800,
    this.stacktraceLoggingThreshold = 900,
  });

  String _getLoggerLocalName(String name) {
    // Split hierarchical names (separated with '.').
    final dot = name.lastIndexOf('.');

    String thisName;
    if (dot == -1) {
      thisName = name;
    } else {
      thisName = name.substring(dot + 1);
    }
    return thisName;
  }

  void writeInBuffer(
    StringBuffer buffer,
    String leading,
    String? text,
  ) {
    final trimmedText = text?.trim();
    if (trimmedText == null || trimmedText.isEmpty) return;
    for (final line in LineSplitter.split(trimmedText)) {
      buffer.writeln('$leading $line');
    }
  }

  @override
  void logger(
    String messageText,
    String objectText,
    String? errorLabel,
    FormattedStacktrace stacktrace,
    LogRecord record,
  ) {
    final messageBuffer = StringBuffer();
    final firstLine = '${record.level.name}/${record.loggerName}';
    messageBuffer.writeln(firstLine);
    final localLoggerName = _getLoggerLocalName(record.loggerName);
    final leadingLine = '${record.sequenceNumber}/$localLoggerName';
    writeInBuffer(messageBuffer, leadingLine, messageText);
    writeInBuffer(messageBuffer, leadingLine, objectText);
    writeInBuffer(messageBuffer, leadingLine, errorLabel);
    final stacktracePrint = stacktrace.formattedStackTrace;
    writeInBuffer(messageBuffer, leadingLine, stacktracePrint);

    final wholeMessage = messageBuffer.toString();

    if (maxLineSize == -1) {
      printSingleLog(
        wholeMessage,
        record,
      );
    } else {
      final pattern = RegExp('.{1,$maxLineSize}');

      final matches = pattern.allMatches(wholeMessage);

      for (final match in matches) {
        final group = match.group(0);
        if (group == null) continue;
        printSingleLog(group, record);
      }
    }
  }

  @protected
  void printSingleLog(
    String messageText,
    LogRecord record,
  ) {
    defaultPrinter(messageText, record);
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
    int stacktraceLoggingThreshold = 900,
  }) : super(
          maxLineSize: maxLineSize,
          stacktraceLoggingThreshold: stacktraceLoggingThreshold,
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
    LogRecord record,
  ) {
    final pen = levelColors[record.level]!;
    defaultPrinter(pen(messageText), record);
  }
}

typedef PrinterCallback = void Function(String message, LogRecord record);

PrinterCallback defaultPrinter = printers.standard;
