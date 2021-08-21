import 'package:flutter/widgets.dart';
import 'package:when_async/when_async.dart';

typedef WhenSnapshotWidgetBuilderCallback<RESULT_TYPE> = Widget Function(
  BuildContext context,
  FutureSnapshot<RESULT_TYPE> snapshot,
);

class FutureSensitiveWidget<RESULT_TYPE> extends StatefulWidget {
  final AsyncResultBuilderCallback<Future<RESULT_TYPE>> create;
  final WhenSnapshotWidgetBuilderCallback<RESULT_TYPE> builder;

  const FutureSensitiveWidget({
    Key? key,
    required this.create,
    required this.builder,
  })  : assert(create != null && builder != null),
        super(key: key);

  @override
  FutureSensitiveWidgetState<RESULT_TYPE> createState() =>
      FutureSensitiveWidgetState<RESULT_TYPE>();
}

class FutureSensitiveWidgetState<RESULT_TYPE>
    extends State<FutureSensitiveWidget<RESULT_TYPE>> {
  /// An object that identifies the currently active callbacks. Used to avoid
  /// calling setState from stale callbacks, e.g. after disposal of this state,
  /// or after widget reconfiguration to a new Future.
  Object? _activeCallbackIdentity;

  late FutureSnapshot<RESULT_TYPE> _lastSnapshot;

  @override
  void initState() {
    super.initState();
    _lastSnapshot =
        FutureSnapshot<RESULT_TYPE>.state(AsyncSnapshotState.uninitialized);
    _subscribe();
  }

  @override
  void didUpdateWidget(FutureSensitiveWidget<RESULT_TYPE> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.create != widget.create) {
      if (_activeCallbackIdentity != null) {
        _unsubscribe();
        _lastSnapshot =
            FutureSnapshot<RESULT_TYPE>.state(AsyncSnapshotState.uninitialized);
      }
      _subscribe();
    }
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    if (!mounted) return;

    final Object callbackIdentity = Object();
    _activeCallbackIdentity = callbackIdentity;

    When.future<RESULT_TYPE>(widget.create).snapshots(
      (snapshot) {
        if (!mounted) return;

        if (_activeCallbackIdentity != callbackIdentity) return;

        setState(() {
          _lastSnapshot = snapshot;
        });
      },
      () {
        if (!mounted) return;

        if (_activeCallbackIdentity != callbackIdentity) return;

        setState(() {
          _lastSnapshot =
              FutureSnapshot<RESULT_TYPE>.state(AsyncSnapshotState.finalized);
        });
      },
    );
  }

  void _unsubscribe() {
    _activeCallbackIdentity = null;
  }

  void restart() {
    if (!mounted) return;

    if (_activeCallbackIdentity != null) {
      _unsubscribe();
    }

    setState(() {
      _lastSnapshot =
          FutureSnapshot<RESULT_TYPE>.state(AsyncSnapshotState.uninitialized);
    });

    _subscribe();
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder.call(context, _lastSnapshot);
}
