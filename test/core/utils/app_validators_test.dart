import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/utils/app_validators.dart';

void main() {
  group('AppValidators.brochureNumber', () {
    test('rejects null and empty values', () {
      expect(AppValidators.brochureNumber(null), AppStrings.numberRequired);
      expect(AppValidators.brochureNumber(''), AppStrings.numberRequired);
      expect(AppValidators.brochureNumber('   '), AppStrings.numberRequired);
    });

    test('accepts 1 to 4 Western digits', () {
      expect(AppValidators.brochureNumber('7'), isNull);
      expect(AppValidators.brochureNumber('42'), isNull);
      expect(AppValidators.brochureNumber('1234'), isNull);
    });

    test('keeps leading zeros valid', () {
      expect(AppValidators.brochureNumber('007'), isNull);
      expect(AppValidators.brochureNumber('0000'), isNull);
    });

    test('trims surrounding whitespace', () {
      expect(AppValidators.brochureNumber(' 12 '), isNull);
    });

    test('rejects more than 4 digits', () {
      expect(AppValidators.brochureNumber('12345'), AppStrings.numberLength);
    });

    test('rejects non-digit characters', () {
      expect(AppValidators.brochureNumber('12a'), AppStrings.numberDigitsOnly);
      expect(AppValidators.brochureNumber('-12'), AppStrings.numberDigitsOnly);
      expect(AppValidators.brochureNumber('١٢'), AppStrings.numberDigitsOnly);
      expect(AppValidators.brochureNumber('1 2'), AppStrings.numberDigitsOnly);
    });
  });

  group('AppValidators.accessCode', () {
    test('rejects null, empty, and whitespace-only values', () {
      expect(AppValidators.accessCode(null), AppStrings.accessCodeRequired);
      expect(AppValidators.accessCode(''), AppStrings.accessCodeRequired);
      expect(AppValidators.accessCode('   '), AppStrings.accessCodeRequired);
    });

    test('accepts any non-empty access code', () {
      expect(AppValidators.accessCode('KORYA'), isNull);
      expect(AppValidators.accessCode('  KORYA  '), isNull);
    });
  });

  group('AppValidators.accessCodeFormatters', () {
    test('keeps Latin letters and Western digits only', () {
      expect(
        _applyFormatters(AppValidators.accessCodeFormatters, 'KORYA١٢3!'),
        'KORYA3',
      );
    });

    test('caps the code at the configured maximum length', () {
      expect(
        _applyFormatters(AppValidators.accessCodeFormatters, 'ABCDEFGHIJKLM'),
        'ABCDEFGHIJ',
      );
    });
  });
}

String _applyFormatters(List<TextInputFormatter> formatters, String text) {
  var value = TextEditingValue(
    text: text,
    selection: TextSelection.collapsed(offset: text.length),
  );

  for (final formatter in formatters) {
    value = formatter.formatEditUpdate(const TextEditingValue(), value);
  }

  return value.text;
}
