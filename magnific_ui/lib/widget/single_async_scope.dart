import 'package:flutter/material.dart';

/// Builder that doesn't provide a action callback if there's already one being used.
typedef SingleActionProcessWidgetBuilder = Widget Function(
  AsyncScopeReference reference,
  Widget? child,
);

/// A widget builder that provides a [AsyncScopeReference] to its child.
/// [AsyncScopeReference] only allows call when no other asynchronous operation from a previously invoked [AsyncScopeReference.call] is running.
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

mixin AsyncScopeReference {
  bool get isProcessing;
  bool get isNotProcessing;

  Future<void> call(Future<void> Function() onPressed);
}

class _SingleAsyncScopeState extends State<SingleAsyncScope>
    with AsyncScopeReference {
  bool _isProcessing = false;

  @override
  bool get isNotProcessing => !_isProcessing;

  @override
  bool get isProcessing => _isProcessing;

  @override
  Future<void> call(
    Future<void> Function() onPressed,
  ) async {
    if (_isProcessing) {
      return;
    }
    _isProcessing = true;
    if (mounted) {
      setState(() {
        /** update state */
      });
    }
    try {
      await onPressed();
    } catch (e, s) {
      widget.onError?.call(e, s);
    }
    _isProcessing = false;
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
