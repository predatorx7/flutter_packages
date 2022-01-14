import 'package:flutter/widgets.dart';
import 'package:single_async_widget/src/ref/value.dart';

import '../ref/base.dart';
import '../typedefs.dart';

/// A widget builder that provides a [AsyncScopeReference] to its child.
/// [AsyncScopeReference] only allows call when no other asynchronous operation from a previously invoked [AsyncScopeReference.call] is running.
///
/// Useful for ignoring tap gestures and show loading indicator
/// when a button is pressed while processing a future.
class SingleAsyncScope<T> extends StatefulWidget {
  const SingleAsyncScope({
    Key? key,
    required this.builder,
    this.child,
    this.onError,
    this.reference,
  }) : super(key: key);

  final SingleActionProcessWidgetBuilder<T> builder;
  final AsyncScopeListenable<T>? reference;
  final Widget? child;
  final OnErrorCallback? onError;

  @override
  _SingleAsyncScopeState<T> createState() => _SingleAsyncScopeState<T>();
}

class _SingleAsyncScopeState<T> extends State<SingleAsyncScope<T>> {
  late AsyncScopeListenable<T> _effectiveScopeReference;

  @override
  void initState() {
    super.initState();
    _bindListener();
  }

  void _bindListener() {
    _effectiveScopeReference = widget.reference ?? AsyncScopeValueNotifier<T>();
    _effectiveScopeReference.addListener(_onChange);
  }

  void _removeListener() {
    _effectiveScopeReference.removeListener(_onChange);
  }

  void _onChange() {
    final error = _effectiveScopeReference.error;
    if (error != null) {
      widget.onError?.call(
        error,
        _effectiveScopeReference.stacktrace ?? StackTrace.current,
      );
    }
    if (mounted) {
      setState(() {
        /** update state */
      });
    }
  }

  @override
  void didUpdateWidget(covariant SingleAsyncScope<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reference != oldWidget.reference) {
      _removeListener();
      _bindListener();
    }
  }

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      _effectiveScopeReference,
      widget.child,
    );
  }
}
