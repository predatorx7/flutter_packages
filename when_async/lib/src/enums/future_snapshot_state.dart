/// The state of connection to an asynchronous computation.
///
/// The usual flow of state is as follows:
///
/// 1. [uninitialized], indicating that the asynchronous operation has not yet started for the first time.
/// 1. [waiting], indicating that the asynchronous operation has begun.
/// 1. [data], with data being non-null, and that computation completed.
/// 1. [none], with data being null, and computation completed.
/// 1. [error], with computation error.
/// 1. [finalized], indicating that the asynchronous operation has completed and will not restart automatically.
///
/// See also:
///
///  * [FutureSnapshot], which augments a future state with information
///    received from the asynchronous computation.
enum AsyncSnapshotState {
  /// Connected to a uninitialized state  has not yet started for the first time with initial or no data.
  uninitialized,

  /// Connected to an asynchronous future computation and awaiting result.
  waiting,

  /// Connected to a asynchronous computation with data.
  data,

  /// Connected to an asynchronous computation with no data.
  none,

  /// Connected to an asynchronous computation with an error.
  error,

  /// Connected to a terminated asynchronous computation. Asynchronous operations's computations will not happen after this state unless restarted.
  finalized,
}
