// import 'package:flutter/foundation.dart'
//     show FlutterErrorDetails, FlutterExceptionHandler;
import 'package:logging/logging.dart';

import 'logger_base.dart';

/// A manager that manages the [Logger] instances (provided as [root]).
///
/// Note: By default, the [loggingManager] does not have a logging mechanism. For that, you have to provde a [LoggingTree] to it.
class LoggingManager {
  LoggingManager({
    this.loggerName = 'LoggingManager',
    Level? level = Level.ALL,
    LoggingTree? tree,
    this.onFlutterErrorHandler,
  }) : root = Logger(loggerName) {
    hierarchicalLoggingEnabled = true;
    root.level = level ?? Level.INFO;
    if (tree != null) {
      plantTree(tree);
    }
    root.onRecord.listen(_logRecordListener);
  }

  final String loggerName;

  /// A logger that is used as the root of the logging tree. This logger is managed by this [LoggingManager].
  final Logger root;

  /// A handler that accepts [FlutterError]s. When this is null, these errors will be send to the [tree].
  final FlutterExceptionHandler? onFlutterErrorHandler;

  LoggingTree? _loggingTree;

  bool get hasTree => _loggingTree != null;

  /// Attach a logging mechanism.
  void plantTree(LoggingTree tree) {
    if (_disposed) {
      throw StateError('LoggingManager(name: $loggerName) is disposed');
    }
    removeTree();
    _loggingTree = tree;
    _loggingTree!.onPlant();
  }

  /// De-attach a logging mechanism.
  void removeTree() {
    if (_loggingTree != null) {
      _loggingTree!.onRemove();
    }
  }

  void _logRecordListener(LogRecord record) {
    _loggingTree?.onRecord(record);
  }

  /// Record a flutter error for logging.
  void onFlutterError(FlutterErrorDetails details) {
    if (onFlutterErrorHandler != null) {
      return onFlutterErrorHandler!(details);
    }
    _loggingTree?.onFlutterError(details);
  }

  /// A stream of logs that can be listened to. This closes when the [LoggingManager] is disposed.
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
