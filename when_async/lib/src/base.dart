import 'package:meta/meta.dart';
import 'package:state_notifier/state_notifier.dart';

import 'data/async/value.dart';

/// A utitlity that asynchronously creates a single value.
///
/// By using [When], the code dependent on the result will be able to read the state of the asynchronous computation synchronously, handle the loading/error/finalize states, and complete when the computation completes.
///
/// A common use-case for [When] is to easily consume states of an asynchronous operation such as reading a file or making an HTTP request.
class When<ASYNC_RESULT_TYPE, RESULT_TYPE> extends StateNotifier<AsyncValue> {
  When(ASYNC_RESULT_TYPE Function() builder)
      : _valueBuilder = builder,
        super(AsyncValue<RESULT_TYPE>.loading()) {
    execute();
  }

  factory When.value(ASYNC_RESULT_TYPE asyncValue) {
    return When(() => asyncValue);
  }

  ASYNC_RESULT_TYPE Function() _valueBuilder;

  void execute() {}
}

class WhenFuture<RESULT_TYPE> extends When<Future<RESULT_TYPE>, RESULT_TYPE> {
  WhenFuture(Future<RESULT_TYPE> Function() builder) : super(builder);

  static When value<RESULT_TYPE>(Future<RESULT_TYPE> state) =>
      When<Future<RESULT_TYPE>, RESULT_TYPE>.value(state);
}

class WhenStream<RESULT_TYPE> extends When<Stream<RESULT_TYPE>, RESULT_TYPE> {
  WhenStream(Stream<RESULT_TYPE> Function() builder) : super(builder);

  static When value<RESULT_TYPE>(Stream<RESULT_TYPE> state) =>
      When<Stream<RESULT_TYPE>, RESULT_TYPE>.value(state);
}
