import 'package:meta/meta.dart';

import '../enums/future_snapshot_state.dart';
import 'async_snapshot.dart';

@immutable
class FutureSnapshot<T> extends AsyncSnapshot<T> {
  /// Creates an [FutureSnapshot] with a data. Constructed upon asynchronous task completion.
  ///
  /// The data can be `null`.
  const FutureSnapshot.success(this.data)
      : error = null,
        stackTrace = null,
        state =
            data != null ? FutureSnapshotState.data : FutureSnapshotState.none;

  /// Creates an [FutureSnapshot] in loading state.
  const FutureSnapshot.loading()
      : data = null,
        error = null,
        stackTrace = null,
        state = FutureSnapshotState.waiting;

  /// Creates an [FutureSnapshot] in error state.
  ///
  /// The parameter [error] cannot be `null`.
  const FutureSnapshot.error(
    Object error, [
    this.stackTrace,
    // ignore: prefer_initializing_formals
  ])  : error = error,
        data = null,
        state = FutureSnapshotState.error;

  @override
  final T? data;

  @override
  final Object? error;

  @override
  final StackTrace? stackTrace;

  /// Current state of connection to the asynchronous future computation.
  final FutureSnapshotState state;

  @override
  bool get isLoading => state == FutureSnapshotState.waiting;
}
