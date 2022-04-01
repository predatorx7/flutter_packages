// import 'package:meta/meta.dart';
// import 'package:when_async/src/future.dart';

// import 'typedefs.dart';

// /// A utitlity that asynchronously creates a single value.
// ///
// /// By using [When], the code dependent on the result will be able to read the state of the asynchronous computation synchronously, handle the loading/error/finalize states, and complete when the computation completes.
// ///
// /// A common use-case for [When] is to easily consume states of an asynchronous operation such as reading a file or making an HTTP request.
// abstract class When<ASYNC_RESULT_TYPE, RESULT_TYPE> {
//   When(AsyncResultBuilderCallback<ASYNC_RESULT_TYPE> builder)
//       : _valueBuilder = builder,
//         _asyncValue = null;

//   When.value(ASYNC_RESULT_TYPE value)
//       : _asyncValue = value,
//         _valueBuilder = _valueBuilderFromValue(value);

//   static AsyncResultBuilderCallback<T> _valueBuilderFromValue<T>(T value) {
//     return () => value;
//   }

//   ASYNC_RESULT_TYPE? _asyncValue;

//   ASYNC_RESULT_TYPE get asyncValue {
//     if (_asyncValue == null) {
//       buildAsyncValue();
//     }
//     return _asyncValue!;
//   }

//   final AsyncResultBuilderCallback<ASYNC_RESULT_TYPE> _valueBuilder;

//   @protected
//   AsyncResultBuilderCallback<ASYNC_RESULT_TYPE> get valueBuilder =>
//       _valueBuilder;

//   @protected
//   void buildAsyncValue() {
//     _asyncValue = valueBuilder();
//   }

//   /// Asynchronously executes a computation once with listener callbacks in parameters for the asynchronous computation that may fail into something that is safe to read.
//   ///
//   /// This is useful to avoid having to do a tedious `try/catch/then`.
//   ///
//   /// This only does the asynchronous future computation once and returns the same future's result in subsequent calls. To refresh/redo an asynchronous computation which has already been computed, use [refresh].
//   Future<void> execute({
//     final VoidCallback? onLoading,
//     final VoidValueCallback? onComplete,
//     final VoidErrorCallback? onError,
//     final VoidCallback? onFinally,
//   });

//   /// Asynchronously executes a computation with listener callbacks in parameters for the asynchronous computation that may fail into something that is safe to read.
//   ///
//   /// This is useful to avoid having to do a tedious `try/catch/then`.
//   ///
//   /// This does the asynchronous future computation once but on subsequent calls, it reruns the asynchronous computation. To get the completed result from last execution, use [execute].
//   Future<void> refresh({
//     final VoidCallback? onLoading,
//     final VoidValueCallback? onComplete,
//     final VoidErrorCallback? onError,
//     final VoidCallback? onFinally,
//   }) {
//     buildAsyncValue();
//     return execute(
//       onLoading: onLoading,
//       onComplete: onComplete,
//       onError: onError,
//       onFinally: onFinally,
//     );
//   }

//   /// Recreates a when instance from the given async builder.
//   When<ASYNC_RESULT_TYPE, RESULT_TYPE> recreate();

//   /// Asynchronously executes a computation once with snapshots callbacks in parameters for the asynchronous computation that may fail into something that is safe to read.
//   ///
//   /// This is useful to avoid having to do a tedious `try/catch/then`.
//   ///
//   /// This is same as [execute] except that it will return a snapshot of the asynchronous computation's state.
//   Future<void> snapshots(
//     AsyncSnapshotListenerCallback<RESULT_TYPE, AsyncSnapshot<RESULT_TYPE>>
//         listener, [
//     VoidCallback? onFinally,
//   ]);

//   /// Asynchronously executes a computation with listener callbacks in parameters for the asynchronous computation that may fail into something that is safe to read.
//   ///
//   /// This is useful to avoid having to do a tedious `try/catch/then`.
//   ///
//   /// This is same as [snapshots] except that on subsequent calls, it reruns the asynchronous computation. To get the completed result from last execution, use [snapshots].
//   Future<void> refreshSnapshots(
//     AsyncSnapshotListenerCallback<RESULT_TYPE, AsyncSnapshot<RESULT_TYPE>>
//         listener, [
//     VoidCallback? onFinally,
//   ]) {
//     buildAsyncValue();
//     return snapshots(listener, onFinally);
//   }

//   /// A utility that uses [WhenFuture] for executing Futures with snapshots.
//   static WhenFuture<RESULT_TYPE> future<RESULT_TYPE>(
//     AsyncResultBuilderCallback<Future<RESULT_TYPE>> asyncValueBuilder,
//   ) {
//     return WhenFuture<RESULT_TYPE>(asyncValueBuilder);
//   }
// }
