/// Valuable string utility class
class StringX {
  StringX._();

  static String getNumbersOnly(String? value) {
    return value?.replaceAll(RegExp(r'[^0-9]'), '') ?? '';
  }

  static bool isEmpty(String? value) {
    return value == null || value.isEmpty;
  }

  static bool isNotEmpty(String? value) {
    return !isEmpty(value);
  }

  static bool isBlank(String? value) {
    return isEmpty(value) || value!.trim().isEmpty;
  }

  static bool isNotBlank(String? value) {
    return !isBlank(value);
  }

  static String value(String? value, [String defaultValue = '']) {
    return isNotBlank(value) ? value! : defaultValue;
  }

  static String objectValue(Object? object, [String defaultValue = '']) {
    return value(object?.toString(), defaultValue);
  }

  static bool areLooslyEquals(String? value, String? other) {
    if (isBlank(value) && isBlank(other)) {
      return true;
    }
    if (isBlank(value) || isBlank(other)) {
      return false;
    }
    return value!.trim().toLowerCase() == other!.trim().toLowerCase();
  }

  /// Returns a value that can be loosely compared with another value.
  /// Trim whitespaces at start and end of this and convert to lowercase. Useful when comparing text.
  String looselyComparable(String value) => value.trim().toLowerCase();

  String clean(String value) => looselyComparable(value);

  /// Capitalize first letter for each word in a string
  String titleCase(String value) => value
      .split(' ')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');

  bool isYes(String? value) {
    return value?.toLowerCase().trim().startsWith('y') ?? false;
  }

  bool isNo(String? value) {
    return value?.toLowerCase().trim().startsWith('n') ?? false;
  }
}
