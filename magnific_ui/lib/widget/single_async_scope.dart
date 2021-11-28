import 'package:flutter/material.dart';

typedef SingleAsyncScopeCallback = Future<void> Function(
  Future<void> Function() onPressed,
);

/// Builder that doesn't provide a action callback if there's already one being used.
typedef SingleActionProcessWidgetBuilder = Widget Function(
  SingleAsyncScopeCallback? singleAsyncScopeCaller,
  Widget? child,
);

/// A widget builder that provides a [SingleAsyncScopeCallback] to its child
/// when no other asynchronous operation from a previously invoked [SingleAsyncScopeCallback] is running.
///
/// Useful for ignoring tap gestures and show loading indicator
/// when a button is pressed while processing a future.
class SingleAsyncScope extends StatefulWidget {
  const SingleAsyncScope({
    Key? key,
    required this.builder,
    this.child,
    this.onError,
  }) : super(key: key);

  final SingleActionProcessWidgetBuilder builder;
  final Widget? child;
  final void Function(
    Object error,
    StackTrace stackTrace,
  )? onError;

  @override
  _SingleAsyncScopeState createState() => _SingleAsyncScopeState();
}

class _SingleAsyncScopeState extends State<SingleAsyncScope> {
  bool _isProcessing = false;

  Future<void> _onPressed(
    Future<void> Function() onPressed,
  ) async {
    if (_isProcessing) {
      return;
    }
    setState(() {
      _isProcessing = true;
    });
    try {
      await onPressed();
    } catch (e, s) {
      widget.onError?.call(e, s);
    }
    setState(() {
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      _isProcessing ? null : _onPressed,
      widget.child,
    );
  }
}
