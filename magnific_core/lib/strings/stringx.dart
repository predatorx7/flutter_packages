/// Valuable string utility class.
/// This can help with various simple string based computations like checking a string is blank, etc.
class StringX {
  StringX._();

  /// Extract numbers from a string. One usecase where this might be useful is for extracting phone numbers from a string.
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

  /// Returns [defaultValue] if [value] is blank.
  static String value(String? value, [String defaultValue = '']) {
    return isNotBlank(value) ? value! : defaultValue;
  }

  /// Returns [defaultValue] if [object?.toString()] is blank.
  static String objectValue(Object? object, [String defaultValue = '']) {
    return value(object?.toString(), defaultValue);
  }

  /// Compares two strings in case insensitive manner without leading or trailing spaces.
  static bool areLooslyEquals(String? value, String? other) {
    if (isBlank(value) && isBlank(other)) {
      return true;
    }
    if (isBlank(value) || isBlank(other)) {
      return false;
    }
    return clean(value!) == clean(other!);
  }

  /// Returns a value that can be loosely compared with another value.
  /// Trims whitespaces at start and end of [value] and convert to lowercase. Useful when comparing with other text.
  static String looselyComparable(String value) => value.trim().toLowerCase();

  /// Returns a value that can be loosely compared with another value.
  /// Trims whitespaces at start and end of [value] and convert to lowercase. Useful when comparing with other text.
  static String clean(String value) => looselyComparable(value);

  /// Capitalize first letter for each word in a string
  static String titleCase(String value) => value
      .split(' ')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');

  /// Returns true if this [value] is close to being a 'yes'.
  static bool isYes(String? value) {
    return value?.toLowerCase().trim().startsWith('y') ?? false;
  }

  /// Returns true if this [value] is close to being a 'no'.
  static bool isNo(String? value) {
    return value?.toLowerCase().trim().startsWith('n') ?? false;
  }
}
