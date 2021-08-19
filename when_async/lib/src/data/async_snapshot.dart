import 'package:meta/meta.dart';

@immutable
abstract class AsyncSnapshot<T> {
  const AsyncSnapshot();

  T? get value;
  Object? get error;
  StackTrace? get stackTrace;

  bool get isLoading;
  bool get hasData;
  bool get hasError;
}
