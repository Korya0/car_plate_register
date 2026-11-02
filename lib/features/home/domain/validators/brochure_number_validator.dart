import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_strings.dart';

class BrochureNumberValidator {
  BrochureNumberValidator._();

  static final RegExp _digitsOnlyRegex = RegExp(r'^[0-9]+$');

  // Formats input by trimming and padding with zeros up to 4 digits.
  static String format(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '';
    return trimmed.padLeft(AppConstants.brochureNumberMaxLength, '0');
  }

  // Validates a brochure number according to business rules.
  static String? validate(String? value) {
    final trimmed = value?.trim() ?? '';

    if (trimmed.isEmpty) {
      return AppStrings.numberRequired;
    }

    if (!_digitsOnlyRegex.hasMatch(trimmed)) {
      return AppStrings.numberDigitsOnly;
    }

    if (trimmed.length < AppConstants.brochureNumberMinLength ||
        trimmed.length > AppConstants.brochureNumberMaxLength) {
      return AppStrings.numberLength;
    }

    final formatted = format(trimmed);
    if (formatted == '0000') {
      return AppStrings.numberCannotBeAllZeros;
    }

    return null;
  }

  // Returns true when the value is valid.
  static bool isValid(String? value) => validate(value) == null;
}
