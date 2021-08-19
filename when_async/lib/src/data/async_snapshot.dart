import 'package:meta/meta.dart';

/// An immutable representation of the most recent interaction with an asynchronous computation.
@immutable
abstract class AsyncSnapshot<T> {
  const AsyncSnapshot();

  T? get data;

  /// The latest error object received by the asynchronous computation.
  Object? get error;

  /// The latest stack trace object received by the asynchronous computation.
  StackTrace? get stackTrace;

  bool get isLoading;

  /// Returns whether this snapshot contains a non-null [data] value.
  bool get hasData => data != null;

  /// Returns whether this snapshot contains a non-null [error] value.
  bool get hasError => error != null;
}
