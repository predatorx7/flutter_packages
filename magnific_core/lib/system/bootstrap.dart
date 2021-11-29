import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:magnific_core/debugging/logger.dart';
import 'package:magnific_core/debugging/logger_base.dart';

/// The main logger for the app. This is initialized by [loggingManager].
Logger get logger => _loggingManager.root;

/// The logging manager that manages the [logger]. This initializes [logger] in [BootstrapApp.start].
LoggingManager get loggingManager => _loggingManager;

LoggingManager _loggingManager = LoggingManager();

/// Use to apply/initialize configurations like debugging, analytics, etc to the Flutter app.
class BootstrapApp {
  /// Creates an App bootstrapper with [futures] and [loggingManager].
  ///
  /// Note: By default, the [loggingManager] does not have a logging mechanism. For that, you have to provde a [LoggingTree] to it.
  BootstrapApp({
    this.onStart,
    required this.loggingManager,
    required this.onStarted,
  });

  /// Called after `WidgetsFlutterBinding.ensureInitialized` and before initialization of logger.
  final Future<void> Function()? onStart;
  final LoggingManager Function() loggingManager;

  /// Called immediately after initialization of logger.
  final Iterable<Future> Function()? onStarted;

  Future<void> start(void Function() app) async {
    WidgetsFlutterBinding.ensureInitialized();

    if (onStart != null) {
      await onStart!();
    }

    _loggingManager = loggingManager();

    FlutterError.onError = _loggingManager.onFlutterError;

    if (onStarted != null) {
      await Future.wait(onStarted!());
    }

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
