import 'package:meta/meta.dart';

import '../enums/future_snapshot_state.dart';
import 'async_snapshot.dart';

@immutable
class FutureSnapshot<T> extends AsyncSnapshot<T> {
  const FutureSnapshot.success(this.value)
      : error = null,
        stackTrace = null,
        state =
            value != null ? FutureSnapshotState.data : FutureSnapshotState.none;

  const FutureSnapshot.loading()
      : value = null,
        error = null,
        stackTrace = null,
        state = FutureSnapshotState.waiting;

  const FutureSnapshot.failure(
    this.error, [
    this.stackTrace,
  ])  : value = null,
        state = FutureSnapshotState.error;

  @override
  final T? value;

  @override
  final Object? error;

  @override
  final StackTrace? stackTrace;

  final FutureSnapshotState state;

  @override
  bool get isLoading => state == FutureSnapshotState.waiting;

  @override
  bool get hasData => value != null;

  @override
  bool get hasError => error != null;
}
