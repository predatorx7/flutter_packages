import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

const String youtubePlayerErrorMessage = 'Could not open youtube player';

void onYoutubePlayerError(
  BuildContext context, [
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
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(errorMessage),
    ),
  );
}
