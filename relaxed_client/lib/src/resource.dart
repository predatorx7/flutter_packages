import 'package:relaxed_client/src/status.dart';

///
/// A generic class that holds a value of type [T] with its loading status [Status].
///
class Resource<T> {
  final Status status;
  final T? data;
  final String? message;

  Resource({
    required this.status,
    this.data,
    this.message,
  });

  Resource.success(this.data)
      : status = Status.SUCCESS,
        message = null;

  Resource.loading(this.data)
      : status = Status.LOADING,
        message = null;

  Resource.error(this.message, this.data) : status = Status.ERROR;
}
