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

  String? isEmpty(String? value, String validationMessage) {
    if (value?.isEmpty ?? true) {
      return validationMessage;
    }
  }

  String? isBlank(String? value, String validationMessage) {
    if (StringX.isBlank(value)) {
      return validationMessage;
    }
  }

  String? username(String? value, String validationMessage) {
    const _pattern = '[a-zA-Z0-9\\-_]{2,256}@[a-zA-Z0-9.\\-_]{2,64}';
    final _regExp = RegExp(_pattern);
    if (_regExp.hasMatch(value ?? '')) {
      return null;
    }
    return validationMessage;
  }

  String? mobileNumber(
    String? value, [
    String validationMessage = 'Invalid contact number',
  ]) {
    if (StringX.isBlank(value)) {
      return null;
    }
    if (value?.trim() == '+91') {
      return null;
    }
    final _regExp = RegExp(r'^(\+\d{1,3}[- ]?)?\d{10}$');
    if (_regExp.hasMatch(value ?? '')) {
      return null;
    }
    return validationMessage;
  }
}
