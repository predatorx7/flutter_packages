/// The state of connection to an asynchronous computation.
///
/// The usual flow of state is as follows:
///
/// 1. [waiting], indicating that the asynchronous operation has begun,
///    typically with the data being null.
/// 2. [data], with data being non-null, and that computation completed.
/// 4. [none], with data being null, and computation completed.
/// 4. [error], with computation error.
///
/// See also:
///
///  * [FutureSnapshot], which augments a future state with information
///    received from the asynchronous computation.
enum FutureSnapshotState {
  /// Connected to an asynchronous future computation and awaiting result.
  waiting,

  /// Connected to a terminated asynchronous computation with data.
  data,

  /// Connected to a terminated asynchronous computation with no data.
  none,

  /// Connected to a terminated asynchronous computation with an error.
  error,
}
