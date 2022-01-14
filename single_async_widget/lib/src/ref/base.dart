import 'dart:ui' as ui;

import '../typedefs.dart';

mixin AsyncScopeReference<T> {
  Future<T>? get currentlyRunningFuture;

  /// Returns true if an async callback is running with this reference.
  bool get isProcessing => currentlyRunningFuture != null;

  /// Returns true if an async callback is not running with this reference.
  bool get isNotProcessing => currentlyRunningFuture == null;

  Future<void> call(FutureCallback<T>? onPressed);

  ui.VoidCallback? createCallback(FutureCallback<T>? callback) {
    if (isProcessing || callback == null) {
      return null;
    }
    return () {
      call(callback);
    };
  }

  Object? get error;

  StackTrace? get stacktrace;

  bool get hasError => error != null;
}
