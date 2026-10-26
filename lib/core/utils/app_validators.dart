import 'package:flutter/services.dart';

import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_strings.dart';

class AppValidators {
  AppValidators._();

  // Digits only — Western digits, no Arabic-Indic digits.
  static final RegExp _digitsOnlyRegex = RegExp(r'^[0-9]+$');

  // Brochure number: 1–4 digits, leading zeros allowed.
  static String? brochureNumber(String? value) {
    final number = value?.trim() ?? '';

    if (number.isEmpty) return AppStrings.numberRequired;
    if (!_digitsOnlyRegex.hasMatch(number)) return AppStrings.numberDigitsOnly;
    if (number.length < AppConstants.brochureNumberMinLength ||
        number.length > AppConstants.brochureNumberMaxLength) {
      return AppStrings.numberLength;
    }

    return null;
  }

  // Western digits only, capped to the brochure number length.
  static List<TextInputFormatter> get brochureNumberFormatters => [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(AppConstants.brochureNumberMaxLength),
  ];
}
