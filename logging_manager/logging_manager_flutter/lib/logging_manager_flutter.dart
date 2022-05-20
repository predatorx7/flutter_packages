import 'dart:async' show Zone;
import 'dart:isolate';

import 'package:flutter/widgets.dart'
    show FlutterErrorDetails, WidgetsFlutterBinding;
import 'package:logging_manager/logging_manager.dart';

export 'package:logging_manager/logging_manager.dart';

class FlutterLoggingManager extends LoggingManager {
  FlutterLoggingManager({
    Logger? logger,
    LoggingTree? tree,
  }) : super(logger: logger, tree: tree);

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

  void listenErrorsWithCurrentIsolate() {
    return listenErrorsInIsolate(Isolate.current);
  }

  Future<void>? runFlutterInZoneGuardedWithLogging(FutureCallback onRun) {
    return runZoneGuardedWithLogging(
      () async {
        /// We must call WidgetsFlutterBinding.ensureInitialized() inside
        /// runZonedGuarded. Error handling wouldn’t work if
        /// WidgetsFlutterBinding.ensureInitialized() was called from the outside.
        WidgetsFlutterBinding.ensureInitialized();

        return onRun();
      },
    );
  }
}
