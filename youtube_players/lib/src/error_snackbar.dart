import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

const String youtubePlayerErrorMessage = 'Could not open youtube player';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> onYoutubePlayerError(
  ScaffoldMessengerState scaffoldMessengerState, [
  String errorMessage = youtubePlayerErrorMessage,
  String logMessage = youtubePlayerErrorMessage,
  Object? error,
  StackTrace? stackTrace,
]) {
  log(
    logMessage,
    level: Level.WARNING.value,
    error: error,
    stackTrace: stackTrace,
  );
  return scaffoldMessengerState.showSnackBar(
    SnackBar(
      content: Text(errorMessage),
    ),
  );
}
