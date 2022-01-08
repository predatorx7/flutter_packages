import 'dart:developer' as devel;

class NavigatorLogger {
  NavigatorLogger();

  static const String _tag = '[navigator]';

  bool enableLogging = false;

  void log(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!enableLogging) return;
    devel.log(
      '$_tag $message',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
