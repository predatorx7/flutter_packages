import 'dart:async';

import 'package:logging/logging.dart';

import 'tree.dart';

/// A manager that manages the [Logger] instances (provided as [logger]).
///
/// By default, the [loggingManager] does not have a log printing or further processing mechanism. For that, you have to listen to logs from a logger.
/// This manager provides a [LoggingTree] which can do further processing by listening to logs from a logger.
/// A LoggingTree is responsible for doing something with logs. If none provided, nothing will happen.
///
/// The [logger] that is used from this manager is attached to a logging tree.
/// You don't have to get the logger from this instance, you can just use the logger's name as
/// every logger created with a name will return the same
/// actual instance whenever it is called with the same string name.
///
/// Records recieved from this logger and its childrens are sent to the
/// logging tree for further processing (or just printing, attached logging tree
/// is responsible for processing).
class LoggingManager {
  /// Creates a new [LoggingManager] with the given [LoggingTree] listening, & then
  /// processing logs from the [logger].
  ///
  /// The [logger] that is used from this manager is attached to a logging tree.
  /// You don't have to get the logger from this instance, you can just use the logger's name as
  /// every logger created with a name will return the same
  /// actual instance whenever it is called with the same string name.
  /// Also check [Logger.detached].
  ///
  /// Records recieved from this logger and its childrens are sent to the
  /// logging tree for further processing (or just printing, attached logging tree
  /// is responsible for processing).
  LoggingManager({
    Logger? logger,
    LoggingTree? tree,
  }) : logger = logger ?? Logger.root {
    hierarchicalLoggingEnabled = true;
    if (tree != null) {
      plantTree(tree);
    }
  }

  /// A logger that is used with the logging tree attached in this manager.
  /// Records recieved from this logger and its childrens are sent to the
  /// logging tree for further processing (or just printing, attached logging tree
  /// is responsible for processing).
  final Logger logger;

  LoggingTree? _loggingTree;

  bool get hasTree => _loggingTree != null;

  /// Attach a logging mechanism.
  void plantTree(LoggingTree tree) {
    if (_disposed) {
      throw StateError(
        'LoggingManager(name: ${logger.fullName}) is disposed',
      );
    }

    // Remove previous tree.
    removeTree();
    _loggingTree = tree;

    final logStream = logger.onRecord;

    final StreamSubscription<LogRecord> logsSubscription;
    if (logStream.isBroadcast) {
      logsSubscription = logStream.listen(addLogRecord);
    } else {
      logsSubscription = logStream.asBroadcastStream().listen(addLogRecord);
    }

    _loggingTree!.onPlant(logsSubscription);
  }

  Logger getLogger(String name) {
    final isRoot = logger.fullName.isEmpty;
    if (isRoot) {
      print('IS ROOT LOGGER');
      return Logger(name);
    }
    return Logger('${logger.fullName}.$name');
  }

  /// De-attach a logging mechanism.
  void removeTree() {
    _loggingTree?.onRemove();
  }

  void addLogRecord(LogRecord record) {
    _loggingTree?.onRecord(record);
  }

  bool _disposed = false;

  void dispose() {
    _disposed = true;
    removeTree();
    logger.clearListeners();
  }
}
