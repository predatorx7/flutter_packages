import 'package:meta/meta.dart';

import '../enums/future_snapshot_state.dart';
import 'async_snapshot.dart';

@immutable
class FutureSnapshot<T> extends AsyncSnapshot<T> {
  const FutureSnapshot.success(this.value)
      : error = null,
        stackTrace = null,
        _state = null;

  const FutureSnapshot.loading()
      : value = null,
        error = null,
        stackTrace = null,
        _state = FutureSnapshotState.waiting;

  const FutureSnapshot.failure(
    this.error, [
    this.stackTrace,
  ])  : value = null,
        _state = FutureSnapshotState.error;

  @override
  final T value;

  @override
  final Object error;

  @override
  final StackTrace stackTrace;

  final FutureSnapshotState _state;

  FutureSnapshotState get state {
    if (_state != null) return _state;
    if (hasData) return FutureSnapshotState.data;
    return FutureSnapshotState.none;
  }

  @override
  bool get isLoading => _state == FutureSnapshotState.waiting;

  @override
  bool get hasData => value != null;

  @override
  bool get hasError => error != null;
}
