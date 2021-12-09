import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:logging_manager/logging_manager.dart';

export 'package:logging_manager/logging_manager.dart';

extension LoggingTreeX on LoggingTree {
  /// Recieve a [FlutterErrorDetails].
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
}

class FlutterLoggingManager extends LoggingManager {
  /// Creates a log from [FlutterErrorDetails].
  void onFlutterError(FlutterErrorDetails details) {
    _loggingTree?.onFlutterError(details);
  }
}

void main() {
  final x = LoggingManager();
}
