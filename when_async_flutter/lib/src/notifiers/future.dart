import 'package:flutter/foundation.dart';
import 'package:when_async/when_async.dart';

/// A [ChangeNotifier] that provides provides snapshot of a future.
/// The future can be recreated/refreshed by calling [update] that uses [createFuture] to execute a future asynchronous computation.
class WhenFutureNotifier<T> with ChangeNotifier, WhenFutureNotifierMixin<T> {
  final Future<T> Function() createFuture;

  WhenFutureNotifier(this.createFuture);

  void update() {
    setFutureValue(
      createFuture(),
      (snapshot) {},
      () {},
    );
  }
}

/// A mixin that provides listenable snapshots of a future asynchronous computation.
///
/// Use [WhenFutureNotifier] instead of this mixin if updating or refreshing a future is required.
mixin WhenFutureNotifierMixin<T> on ChangeNotifier {
  FutureSnapshot<T> get snapshot => _snapshot;

  FutureSnapshot<T> _snapshot = FutureSnapshot<T>.loading();

  void _updateSnapshot(FutureSnapshot<T> newValue) {
    if (_snapshot == newValue) return;
    _snapshot = newValue;
    notifyListeners();
  }

  T? get data => snapshot.data;

  FutureSnapshotState get state => snapshot.state;

  /// An object that identifies the currently active callbacks. Used to avoid
  /// calling setState from stale callbacks, e.g. after disposal of this state,
  /// or after widget reconfiguration to a new Future.
  Object? _activeCallbackIdentity;

  @override
  void dispose() {
    _activeCallbackIdentity = null;
    super.dispose();
  }

  /// Sets a value after an asynchronous computation that returned a future
  @protected
  Future<void> setFutureValue(
    Future<T> future,
    FutureSnapshotListenerCallback<T>? listener,
    VoidCallback? onFinally,
  ) {
    final Object callbackIdentity = Object();
    _activeCallbackIdentity = callbackIdentity;

    return When.future<T>(future).snapshots(
      (snapshot) {
        if (_activeCallbackIdentity != callbackIdentity) return;

        listener?.call(snapshot);
        _updateSnapshot(snapshot);
      },
      () {
        if (_activeCallbackIdentity != callbackIdentity) return;

        onFinally?.call();
      },
    );
  }

  @override
  String toString() => '${describeIdentity(this)}($snapshot)';
}
