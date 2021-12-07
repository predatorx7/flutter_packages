/// Represents any issues within repository layer
class RepositoryError {
  /// A message about error that can be shown to the user in UI
  final String message;

  /// The actual error which may have caused this error
  final Object? error;

  /// Stack trace from the source of error
  final StackTrace? stackTrace;

  /// An error message that is useful for debugging for developers
  final String? errorMessage;

  /// Creates a new instance of [RepositoryError] to represent any issues within repository layer.
  const RepositoryError(
    this.message, {
    this.error,
    this.stackTrace,
    this.errorMessage,
  });

  @override
  String toString() {
    return 'RepositoryError($errorMessage)';
  }
}
