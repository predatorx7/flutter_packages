import 'dart:async' show Zone;

import 'package:flutter/widgets.dart' show FlutterErrorDetails;
import 'package:logging_manager/logging_manager.dart';

export 'package:logging_manager/logging_manager.dart';

class FlutterLoggingManager extends LoggingManager {
  FlutterLoggingManager({
    String loggerName = 'LoggingManager',
    Level? level = Level.ALL,
    LoggingTree? tree,
  }) : super(
          loggerName: loggerName,
          level: level,
          tree: tree,
        );

  Logger get logger => root;

  /// Creates a log from [FlutterErrorDetails].
  void onFlutterError(FlutterErrorDetails details) {
    final message = details.exceptionAsString();
    addLogRecord(LogRecord(
      Level.WARNING,
      message,
      'FlutterErrorDetails',
      details.exception,
      details.stack,
      Zone.current,
      details,
    ));
  }
}
