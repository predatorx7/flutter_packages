import 'package:when_async/src/future.dart';

import 'data/data.dart';
import 'typedefs.dart';

abstract class When<ASYNC_RETURN_TYPE, RETURN_TYPE> {
  const When(this.asyncValue);

  final ASYNC_RETURN_TYPE asyncValue;

  Future<void> execute({
    final VoidCallback onLoading,
    final VoidDataCallback onComplete,
    final VoidErrorCallback onError,
    final VoidCallback onFinally,
  });

  Future<void> snapshots(
    AsyncSnapshotListenerCallback<RETURN_TYPE, AsyncSnapshot<RETURN_TYPE>>
        listener, [
    VoidCallback onFinally,
  ]);

  static WhenFuture<RETURN_TYPE> future<RETURN_TYPE>(
    Future<RETURN_TYPE> asyncValue,
  ) {
    return WhenFuture<RETURN_TYPE>(asyncValue);
  }
}
