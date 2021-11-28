import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:magnific_core/debugging/logger.dart';
import 'package:magnific_core/debugging/logger_base.dart';

/// The main logger for the app.
Logger get logger => _loggingManager.root;

LoggingManager get loggingManager => _loggingManager;

LoggingManager _loggingManager = LoggingManager();

/// Use to apply/initialize configurations like debugging, analytics, etc to the Flutter app.
class BootstrapApp {
  BootstrapApp({
    required this.loggingManager,
    this.futures = const <Future>[],
  });

  final LoggingManager loggingManager;
  final Iterable<Future> futures;

  Future<void> start(
    void Function() app, {
    bool? enableConsoleLogging,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();
    _loggingManager = loggingManager;
    if (!_loggingManager.hasTree) {
      _loggingManager.plantTree(PrintingColoredLogsTree());
    }

    await Future.wait(futures);

    FlutterError.onError = loggingManager.onFlutterError;

    runZonedGuarded<void>(
      app,
      (error, stackTrace) => logger.severe(
        error.toString(),
        error,
        stackTrace,
      ),
    );
  }
}
