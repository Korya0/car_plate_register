import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/features/home/domain/validators/brochure_number_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BrochureNumberValidator', () {
    test('format pads numbers up to 4 digits with leading zeros', () {
      expect(BrochureNumberValidator.format('5'), '0005');
      expect(BrochureNumberValidator.format('42'), '0042');
      expect(BrochureNumberValidator.format('007'), '0007');
      expect(BrochureNumberValidator.format('1284'), '1284');
    });

    test('rejects empty and whitespace-only input', () {
      expect(
        BrochureNumberValidator.validate(''),
        AppStrings.numberRequired,
      );
      expect(
        BrochureNumberValidator.validate('   '),
        AppStrings.numberRequired,
      );
      expect(
        BrochureNumberValidator.validate(null),
        AppStrings.numberRequired,
      );
    });

    test('rejects non-digit input', () {
      expect(
        BrochureNumberValidator.validate('12a4'),
        AppStrings.numberDigitsOnly,
      );
      expect(
        BrochureNumberValidator.validate('abc'),
        AppStrings.numberDigitsOnly,
      );
    });

    test('rejects input with length exceeding 4 digits', () {
      expect(
        BrochureNumberValidator.validate('12345'),
        AppStrings.numberLength,
      );
    });

    test('rejects 0000 and any input resulting in 0000', () {
      expect(
        BrochureNumberValidator.validate('0'),
        AppStrings.numberCannotBeAllZeros,
      );
      expect(
        BrochureNumberValidator.validate('00'),
        AppStrings.numberCannotBeAllZeros,
      );
      expect(
        BrochureNumberValidator.validate('000'),
        AppStrings.numberCannotBeAllZeros,
      );
      expect(
        BrochureNumberValidator.validate('0000'),
        AppStrings.numberCannotBeAllZeros,
      );
    });

    test('accepts valid 1 to 4 digit numbers that are not 0000', () {
      expect(BrochureNumberValidator.validate('5'), isNull);
      expect(BrochureNumberValidator.validate('42'), isNull);
      expect(BrochureNumberValidator.validate('007'), isNull);
      expect(BrochureNumberValidator.validate('9999'), isNull);
      expect(BrochureNumberValidator.isValid('5'), isTrue);
    });
  });
}
