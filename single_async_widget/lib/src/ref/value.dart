import 'package:flutter/foundation.dart';
import 'package:single_async_widget/src/ref/base.dart';
import 'package:single_async_widget/src/typedefs.dart';

abstract class AsyncScopeListenable<T> extends Listenable
    with AsyncScopeReference<T> {
  const AsyncScopeListenable();
}

abstract class AsyncScopeValueListenable<T> extends AsyncScopeListenable<T>
    implements ValueListenable<Future<T>?> {
  const AsyncScopeValueListenable();
}

class AsyncScopeValueNotifier<T> extends AsyncScopeValueListenable<T>
    with ChangeNotifier {
  @override
  Future<void> call(
    FutureCallback<T>? onPressed,
  ) async {
    if (isProcessing || onPressed == null) {
      return;
    }
    _error = null;
    _stacktrace = null;

    _currentlyRunningFuture = onPressed();

    try {
      await value!;
    } catch (e, s) {
      _error = e;
      _stacktrace = s;
    }

    _currentlyRunningFuture = null;
  }

  @override
  Future<T>? get currentlyRunningFuture => _value;

  @override
  Future<T>? get value => _value;

  // For storing future
  Future<T>? _value;

  // For setting future
  set _currentlyRunningFuture(Future<T>? newValue) {
    if (_value == newValue) {
      return;
    }
    _value = newValue;
    notifyListeners();
  }

  Object? _error;

  @override
  Object? get error => _error;

  StackTrace? _stacktrace;

  @override
  StackTrace? get stacktrace => _stacktrace;
}
