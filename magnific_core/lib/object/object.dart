T? getValueIfTypeMatched<T>(Object? value) {
  if (value is T) {
    return value;
  }
  return null;
}
