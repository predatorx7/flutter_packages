import 'package:flutter/widgets.dart';
import 'package:when_async/when_async.dart';

class FutureSensitiveWidget<RESULT_TYPE> extends StatefulWidget {
  final Future<RESULT_TYPE> future;
  final Widget Function(BuildContext context, FutureSnapshot snapshot) builder;

  const FutureSensitiveWidget({
    Key? key,
    required this.future,
    required this.builder,
  })  : assert(future != null && builder != null),
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
    _lastSnapshot = FutureSnapshot<RESULT_TYPE>.loading();
    _subscribe();
  }

  @override
  void didUpdateWidget(FutureSensitiveWidget<RESULT_TYPE> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.future != widget.future) {
      if (_activeCallbackIdentity != null) {
        _unsubscribe();
        _lastSnapshot = FutureSnapshot<RESULT_TYPE>.loading();
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

    When.future<RESULT_TYPE>(widget.future).execute(
      onComplete: (it) {
        if (!mounted) return;

        if (_activeCallbackIdentity != callbackIdentity) return;

        setState(() {
          _lastSnapshot = FutureSnapshot<RESULT_TYPE>.success(it);
        });
      },
      onError: (e, s) {
        if (!mounted) return;

        if (_activeCallbackIdentity != callbackIdentity) return;

        setState(() {
          _lastSnapshot = FutureSnapshot<RESULT_TYPE>.error(e, s);
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
      _lastSnapshot = FutureSnapshot<RESULT_TYPE>.loading();
    });

    _subscribe();
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder.call(context, _lastSnapshot);
}
