import 'data/future_snapshot.dart';
import 'typedefs.dart';
import 'when_async_base.dart';

class WhenFuture<T> extends When<Future<T>, T> {
  const WhenFuture(Future<T> future) : super(future);

  @override
  Future<void> execute({
    final VoidCallback onLoading,
    final VoidDataCallback<T> onComplete,
    final VoidErrorCallback onError,
    final VoidCallback onFinally,
  }) async {
    onLoading?.call();
    try {
      final _response = await asyncValue;
      onComplete?.call(_response);
    } catch (e, s) {
      onError?.call(e, s);
    } finally {
      onFinally?.call();
    }
  }

  @override
  Future<void> snapshots(
    FutureSnapshotListenerCallback<T> listener, [
    VoidCallback onFinally,
  ]) {
    return execute(
      onComplete: (it) => listener(FutureSnapshot<T>.success(it)),
      onError: (e, s) => listener(FutureSnapshot<T>.failure(e, s)),
      onLoading: () => listener(FutureSnapshot<T>.loading()),
      onFinally: onFinally,
    );
  }
}
