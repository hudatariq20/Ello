import 'package:flutter/material.dart';

abstract class Validation<T> {
  const Validation();
  String? validate(BuildContext buildContext, T? value);
}

class RequiredValidation<T> extends Validation<T> {
  RequiredValidation({this.isExist});
  final bool Function(T value)? isExist;

  @override
  String? validate(BuildContext buildContext, T? value) {
    if (value == null) return 'The field is required';

    if (isExist != null && !isExist!(value)) {
      return 'The field is required';
    }

    if (value is String && (value as String).isEmpty) {
      return 'The field is required';
    }
    return null;
  }
}

class EmailValidation extends Validation<String> {
  const EmailValidation();
  @override
  String? validate(BuildContext buildContext, String? value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (value == null) return 'The field is required';
    if (!emailRegex.hasMatch(value)) return 'Please enter valid email';
    return null;
  }
}

class PasswordValidation extends Validation<String> {
  const PasswordValidation({
    this.minLength = 8,
    this.number = false,
    this.upperCase = false,
    this.specialChar = false,
  });
  final int minLength;
  final bool number;
  final bool upperCase;
  final bool specialChar;

  static final _numberRegex = RegExp(r'[0-9]');
  static final _upperCaseRegex = RegExp(r'[A-Z]');
  static final _specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  @override
  String? validate(BuildContext buildContext, String? value) {
    if (value?.isEmpty == true) return null;

    if (value!.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    if (number && !_numberRegex.hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    if (upperCase && !_upperCaseRegex.hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    if (specialChar && !_specialCharRegex.hasMatch(value)) {
      return 'Password must contain at least one special character';
    }

    return null;
  }
}

class ConfirmPasswordValidation extends Validation<String> {
  final String originalPassword;

  const ConfirmPasswordValidation(this.originalPassword);

  @override
  String? validate(BuildContext buildContext, String? value) {
    if (value == null || value.isEmpty) {
      return 'The field is required';
    }
    if (value != originalPassword) {
      return 'Passwords do not match';
    }
    return null;
  }
}
