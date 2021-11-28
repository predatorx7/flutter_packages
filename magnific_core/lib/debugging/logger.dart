import 'package:flutter/foundation.dart'
    show FlutterErrorDetails, FlutterExceptionHandler;
import 'package:logging/logging.dart';

import 'logger_base.dart';

class LoggingManager {
  LoggingManager({
    this.loggerName = 'LoggingManager',
    Level? level = Level.ALL,
    LoggingTree? tree,
    this.onFlutterErrorHandler,
  }) : root = Logger(loggerName) {
    root.level = level ?? Level.INFO;
    if (tree != null) {
      plantTree(tree);
    }
    root.onRecord.listen(_logRecordListener);
  }

  final String loggerName;
  final Logger root;
  final FlutterExceptionHandler? onFlutterErrorHandler;

  LoggingTree? _loggingTree;

  bool get hasTree => _loggingTree != null;

  void plantTree(LoggingTree tree) {
    if (_disposed) {
      throw StateError('LoggingManager(name: $loggerName) is disposed');
    }
    removeTree();
    _loggingTree = tree;
    _loggingTree!.onPlant();
  }

  void removeTree() {
    if (_loggingTree != null) {
      _loggingTree!.onRemove();
    }
  }

  void _logRecordListener(LogRecord record) {
    _loggingTree?.onRecord(record);
  }

  void onFlutterError(FlutterErrorDetails details) {
    if (onFlutterErrorHandler != null) {
      return onFlutterErrorHandler!(details);
    }
    _loggingTree?.onFlutterError(details);
  }

  Stream<LogRecord> get logs {
    if (_disposed) {
      throw StateError('LoggingManager(name: $loggerName) is disposed');
    }
    return root.onRecord;
  }

  bool _disposed = false;

  void dispose() {
    _disposed = true;
    removeTree();
    root.clearListeners();
  }
}
