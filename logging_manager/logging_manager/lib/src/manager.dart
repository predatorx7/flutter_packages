import 'package:logging/logging.dart';

import 'tree.dart';

/// A manager that manages the [Logger] instances (provided as [root]).
///
/// Note: 
/// - By default, the [loggingManager] does not have a logging mechanism. For that, you have to provde a [LoggingTree] to it.
/// - A LoggingTree is responsible for doing something with logs. If none provided, nothing will happen.
class LoggingManager {
  /// Creates a new [LoggingManager] with the given [LoggingTree] as [root].
  LoggingManager({
    this.loggerName = 'LoggingManager',
    Level? level = Level.ALL,
    LoggingTree? tree,
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
