import 'package:flutter/widgets.dart';

import '../ref/base.dart';
import '../typedefs.dart';

typedef SimpleSingleAsyncScope = SingleAsyncWidget;

class SingleAsyncWidget<T> extends StatefulWidget {
  const SingleAsyncWidget({
    Key? key,
    required this.builder,
    this.child,
    this.onError,
  }) : super(key: key);

  final SingleActionProcessWidgetBuilder<T> builder;
  final Widget? child;
  final void Function(
    Object error,
    StackTrace stackTrace,
  )? onError;

  @override
  _SingleAsyncWidgetState<T> createState() => _SingleAsyncWidgetState<T>();
}

class _SingleAsyncWidgetState<T> extends State<SingleAsyncWidget<T>>
    with AsyncScopeReference<T> {
  Future<T>? _currentlyRunningFuture;
  @override
  Future<T>? get currentlyRunningFuture => _currentlyRunningFuture;

  Object? _error;

  @override
  Object? get error => _error;

  StackTrace? _stacktrace;

  @override
  StackTrace? get stacktrace => _stacktrace;

  @override
  Future<void> call(
    FutureCallback<T>? onPressed,
  ) async {
    if (isProcessing || onPressed == null) {
      return;
    }
    _error = null;
    _stacktrace = null;

    _currentlyRunningFuture = onPressed();

    if (mounted) {
      setState(() {
        /** update state */
      });
    }

    try {
      await _currentlyRunningFuture!;
    } catch (e, s) {
      _error = e;
      _stacktrace = s;
      widget.onError?.call(e, s);
    }

    _currentlyRunningFuture = null;

    if (mounted) {
      setState(() {
        /** update state */
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      this,
      widget.child,
    );
  }
}
