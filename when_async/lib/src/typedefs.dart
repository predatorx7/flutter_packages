import 'data/data.dart';

/// Signature of callbacks that have [snapshot]s in argument which describes state of an asynchronous [Future] computation.
typedef FutureSnapshotListenerCallback<T> = void Function(
  FutureSnapshot<T> snapshot,
);

/// Signature of callbacks that have [snapshot]s in argument which describes state of an asynchronous computation.
typedef AsyncSnapshotListenerCallback<R, SNAPSHOT_TYPE extends AsyncSnapshot<R>>
    = void Function(SNAPSHOT_TYPE snapshot);

/// Signature of callbacks that have a value in argument and return no data.
typedef VoidValueCallback<T> = void Function(T value);

/// Signature of callbacks that have no arguments and return no data.
typedef VoidCallback = void Function();

typedef VoidErrorCallback = void Function(Object error, StackTrace stackTrace);
