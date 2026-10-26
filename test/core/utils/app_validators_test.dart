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
}
