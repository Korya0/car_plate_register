import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/utils/app_logger.dart';
import 'package:car_register/features/access_control/data/data_sources/access_control_remote_data_source.dart';
import 'package:car_register/features/access_control/data/models/access_code_model.dart';
import 'package:car_register/features/access_control/data/repositories/access_control_repository_impl.dart';
import 'package:car_register/features/access_control/domain/use_cases/validate_access_code_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAccessControlRemoteDataSource extends Mock
    implements AccessControlRemoteDataSource {}

void main() {
  late MockAccessControlRemoteDataSource mockRemoteDataSource;
  late AccessControlRepositoryImpl repository;
  late ValidateAccessCodeUseCase useCase;

  setUp(() {
    mockRemoteDataSource = MockAccessControlRemoteDataSource();
    repository = AccessControlRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      logger: const AppLogger(),
    );
    useCase = ValidateAccessCodeUseCase(repository: repository);
  });

  group('ValidateAccessCodeUseCase', () {
    test('returns Success when access code exists and is active', () async {
      when(() => mockRemoteDataSource.getAccessCode('TEST_ACTIVE_CODE'))
          .thenAnswer(
            (_) async => const AccessCodeModel(
              code: 'TEST_ACTIVE_CODE',
              isActive: true,
            ),
          );

      final result = await useCase('TEST_ACTIVE_CODE');

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull?.code, 'TEST_ACTIVE_CODE');
      expect(result.dataOrNull?.isActive, isTrue);
    });

    test('returns Failure when access code does not exist', () async {
      when(() => mockRemoteDataSource.getAccessCode('UNKNOWN')).thenAnswer(
        (_) async => null,
      );

      final result = await useCase('UNKNOWN');

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull?.message, AppStrings.accessCodeInvalid);
    });

    test(
      'returns Failure when access code is deactivated (isActive == false)',
      () async {
        when(() => mockRemoteDataSource.getAccessCode('DEACTIVATED'))
            .thenAnswer(
              (_) async => const AccessCodeModel(
                code: 'DEACTIVATED',
                isActive: false,
              ),
            );

        final result = await useCase('DEACTIVATED');

        expect(result.isFailure, isTrue);
        expect(result.failureOrNull?.message, AppStrings.accessCodeDisabled);
      },
    );

    test('returns Failure when access code is empty', () async {
      final result = await useCase('   ');

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull?.message, AppStrings.accessCodeRequired);
      verifyZeroInteractions(mockRemoteDataSource);
    });
  });
}
