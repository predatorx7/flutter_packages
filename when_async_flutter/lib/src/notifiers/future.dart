import 'package:flutter/foundation.dart';
// ignore: implementation_imports
import 'package:when_async/src/future.dart' show WhenFuture;
import 'package:when_async/when_async.dart';

/// A [ChangeNotifier] that provides snapshot of a future.
/// The future can be recreated/refreshed by calling [update]. that uses [futureBuilder] to execute a future asynchronous computation.
class WhenFutureNotifier<T> with ChangeNotifier, WhenFutureNotifierMixin<T> {
  final WhenFuture<T> _whenFuture;

  /// Creates a [WhenFutureNotifier] that provides snapshot of a future as a [ChangeNotifer].
  /// The [futureBuilder] is used to build a future value.
  WhenFutureNotifier(
    AsyncResultBuilderCallback<Future<T>> futureBuilder,
  ) : _whenFuture = WhenFuture<T>(futureBuilder);

  /// Refreshes/Redoes a future asynchronous computation.
  void update({
    FutureSnapshotListenerCallback<T>? listener,
    VoidCallback? onFinally,
  }) {
    setFutureValue(
      _whenFuture,
      listener,
      onFinally,
    );
  }
}

/// A mixin that provides listenable snapshots of a future asynchronous computation.
///
/// Use [WhenFutureNotifier] instead of this mixin if updating or refreshing a future is required.
mixin WhenFutureNotifierMixin<T> on ChangeNotifier {
  FutureSnapshot<T> get snapshot => _snapshot;

  FutureSnapshot<T> _snapshot =
      FutureSnapshot<T>.state(AsyncSnapshotState.uninitialized);

  void _updateSnapshot(FutureSnapshot<T> newValue) {
    if (_snapshot == newValue) return;
    _snapshot = newValue;
    notifyListeners();
  }

  T? get data => snapshot.data;

  AsyncSnapshotState get state => snapshot.state;

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
    WhenFuture<T> whenFuture,
    FutureSnapshotListenerCallback<T>? listener,
    VoidCallback? onFinally,
  ) {
    final Object callbackIdentity = Object();
    _activeCallbackIdentity = callbackIdentity;

    return whenFuture.refreshSnapshots(
      (snapshot) {
        if (_activeCallbackIdentity != callbackIdentity) return;

        listener?.call(snapshot as FutureSnapshot<T>);
        _updateSnapshot(snapshot as FutureSnapshot<T>);
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
