class NavigationError {
  final String message;
  final Object? error;
  final StackTrace? stackTrace;

  const NavigationError(
    this.message, [
    this.error,
    this.stackTrace,
  ]);
}
