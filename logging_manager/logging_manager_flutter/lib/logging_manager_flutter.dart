import 'dart:async' show Zone, runZonedGuarded;
import 'dart:isolate';

import 'package:flutter/widgets.dart'
    show FlutterError, FlutterErrorDetails, WidgetsFlutterBinding;
import 'package:logging_manager/logging_manager.dart';

export 'package:logging_manager/logging_manager.dart';

typedef FutureCallback = Future<void> Function();

extension FlutterLoggingManager on LoggingManager {
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

  /// Sends a log to the current logger managed by this manager.
  Future<void> onRecordError(
    Object? error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) {
    if (fatal) {
      logger.severe(reason, error, stackTrace);
    } else {
      logger.warning(reason);
    }

    /// To support being await-ed when overriding classes does something asynchronously.
    return Future.value(null);
  }

  void listenErrorsInCurrentIsolate() {
    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      await onRecordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
        fatal: true,
      );
    }).sendPort);
  }

  Future<void>? runZoneGuardedWithLogging(
    FutureCallback? beforeRun,
    FutureCallback onRun,
  ) {
    return runZonedGuarded<Future<void>>(
      () async {
        /// We must call WidgetsFlutterBinding.ensureInitialized() inside
        /// runZonedGuarded. Error handling wouldn’t work if
        /// WidgetsFlutterBinding.ensureInitialized() was called from the outside.
        WidgetsFlutterBinding.ensureInitialized();

        if (beforeRun != null) await beforeRun();

        FlutterError.onError = onFlutterError;

        return onRun();
      },
      (error, stack) => onRecordError(
        error,
        stack,
        fatal: true,
      ),
    );
  }
}
