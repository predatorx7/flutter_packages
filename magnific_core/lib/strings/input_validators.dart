import 'stringx.dart';

/// Can be used as form field input validators.
/// Multiple validator functions can be used together.
class StringValidate {
  StringValidate._();

  static String? password(
    String? value, [
    String validationMessage = 'Password should not be empty',
  ]) {
    if (value?.isNotEmpty != true) {
      return validationMessage;
    }
    // Todo: Please verify if all existing passwords are greater than 6 characters in length
    // else if (value!.length < 6) {
    //
    //   // or invalid password if this message is too long
    //   return "$name's length should not be greater than 6 character";
    // }
  }

  static String? passwordMatch(
    String? value,
    String? otherValue, [
    String validationMessage = 'Password does not match',
  ]) {
    if (value != otherValue) {
      return validationMessage;
    }
  }

  static String? isEmpty(String? value, String validationMessage) {
    if (value?.isEmpty ?? true) {
      return validationMessage;
    }
  }

  static String? isBlank(String? value, String validationMessage) {
    if (StringX.isBlank(value)) {
      return validationMessage;
    }
  }

  static String? username(
    String? value, {
    String validationMessage = 'Invalid username',
  }) {
    final _regExp = RegExp(CommonRegexPatterns.usernamePattern);
    if (_regExp.hasMatch(value ?? '')) {
      return null;
    }
    return validationMessage;
  }

  static String? mobileNumber(
    String? value, [
    String validationMessage = 'Invalid contact number',
  ]) {
    if (StringX.isBlank(value)) {
      return null;
    }
    final _regExp = RegExp(CommonRegexPatterns.mobileNumberPattern);
    if (_regExp.hasMatch(value ?? '')) {
      return null;
    }
    return validationMessage;
  }

  static String? emailAddress(
    String? value, [
    String validationMessage = 'Invalid email address',
  ]) {
    if (StringX.isBlank(value)) {
      return null;
    }
    final _regExp = RegExp(CommonRegexPatterns.emailPattern);
    if (_regExp.hasMatch(value ?? '')) {
      return null;
    }
    return validationMessage;
  }
}

/// Common regex patterns that can be used for string validation.
class CommonRegexPatterns {
  CommonRegexPatterns._();

  /// A weak mobile number regex pattern that allows a single country code of max 3 digits and a 10 digit local number.
  static const mobileNumberPattern = r'^(\+\d{1,3}[- ]?)?\d{10}$';

  /// HTML spec suggested email validation pattern
  /// Reference: https://html.spec.whatwg.org/#e-mail-state-(type=email)
  static const emailPattern =
      r"^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$";

  /// A common username pattern which expects inputs like example, exmaple@someting, example@somthing.com, example.something, etc.
  static const usernamePattern =
      r'[a-zA-Z0-9\-_]{2,256}(@[a-zA-Z0-9.\-_]{2,64})|(.[a-zA-Z0-9.\-_]{2,256})';
  static const passwordPattern =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
}
