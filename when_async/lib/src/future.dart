import 'typedefs.dart';
import 'when_async_base.dart';

class MutableArgument<T> {
  T value;

  MutableArgument(this.value);
}

/// A utitlity that asynchronously creates a single value from a [Future].
///
/// By using [WhenFuture], the code dependent on the result will be able to read the state of the asynchronous computation synchronously, handle the loading/error/finalize states, and complete when the computation completes.
///
/// A common use-case for [When] is to easily consume states of an asynchronous operation such as reading a file or making an HTTP request.
class WhenFuture<T> extends When<Future<T>, T> {
  WhenFuture(Future<T> Function() createFuture) : super(createFuture);

  WhenFuture.value(Future<T> future) : super.value(future);

  @override
  Future<void> execute({
    final VoidCallback? onLoading,
    final VoidValueCallback<T>? onComplete,
    final VoidErrorCallback? onError,
    final VoidCallback? onFinally,
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
    VoidCallback? onFinally,
  ]) {
    return execute(
      onLoading: () => listener(FutureSnapshot<T>.loading()),
      onComplete: (it) => listener(FutureSnapshot<T>.complete(it)),
      onError: (e, s) => listener(FutureSnapshot<T>.error(e, s)),
      onFinally: onFinally,
    );
  }

  @override
  When<Future<T>, T> recreate() {
    return WhenFuture(super.valueBuilder);
  }
}
