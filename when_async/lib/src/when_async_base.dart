import 'package:when_async/src/future.dart';

import 'data/data.dart';
import 'typedefs.dart';

abstract class When<ASYNC_RESULT_TYPE, RESULT_TYPE> {
  const When(this.asyncValue);

  final ASYNC_RESULT_TYPE asyncValue;

  Future<void> execute({
    final VoidCallback? onLoading,
    final VoidDataCallback? onComplete,
    final VoidErrorCallback? onError,
    final VoidCallback? onFinally,
  });

  Future<void> snapshots(
    AsyncSnapshotListenerCallback<RESULT_TYPE, AsyncSnapshot<RESULT_TYPE>>
        listener, [
    VoidCallback? onFinally,
  ]);

  static WhenFuture<RESULT_TYPE> future<RESULT_TYPE>(
    Future<RESULT_TYPE> asyncValue,
  ) {
    return WhenFuture<RESULT_TYPE>(asyncValue);
  }
}
