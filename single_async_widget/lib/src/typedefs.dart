import 'package:flutter/material.dart';

import 'ref/base.dart';

/// Builder that doesn't provide a action callback if there's already one being used.
typedef SingleActionProcessWidgetBuilder<T> = Widget Function(
  AsyncScopeReference<T> reference,
  Widget? child,
);

/// Signature of callbacks that have no arguments but returns a future.
typedef FutureCallback<T> = Future<T> Function();

typedef OnErrorCallback = void Function(
  Object error,
  StackTrace stackTrace,
);
