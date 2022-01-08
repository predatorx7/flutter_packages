/// Returns value as [T] typecasted if it is of type [T]; otherwise this returns `null`.
T? getValueIfTypeMatched<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}
