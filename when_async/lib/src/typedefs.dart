import 'data/data.dart';

typedef FutureSnapshotListenerCallback<T> = void Function(
  FutureSnapshot<T> snapshot,
);

typedef AsyncSnapshotListenerCallback<R, SNAPSHOT_TYPE extends AsyncSnapshot<R>>
    = void Function(
  SNAPSHOT_TYPE snapshot,
);

typedef VoidDataCallback<T> = void Function(T);

typedef VoidCallback = void Function();

typedef VoidErrorCallback = void Function(Object, StackTrace);
