import 'package:flutter/material.dart';

import 'build_context_extension.dart';

extension ValidatorsExtension on String? {
  String? validateRequired(BuildContext context, [String? alertText]) {
    if (this == null || this!.trim().isEmpty) {
      return alertText ?? context.words.requiredField;
    }
    return null;
  }

  String? validateEmail(BuildContext context, {String? alertText}) {
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );

    if (!emailRegex.hasMatch(this!)) {
      return alertText ?? context.words.invalidEmail;
    }
    return null;
  }

  String? validateMinLength(
    BuildContext context,
    int min, [
    String? alertText,
  ]) {
    if (this!.length < min) {
      return alertText ?? context.words.minLength(min);
    }
    return null;
  }

  String? validateMatch(
    BuildContext context,
    String matchValue, [
    String? alertText,
  ]) {
    if (this != matchValue) {
      return alertText ?? context.words.passwordsDontMatch;
    }
    return null;
  }
}
