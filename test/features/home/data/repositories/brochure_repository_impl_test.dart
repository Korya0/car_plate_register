import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/utils/app_logger.dart';
import 'package:car_register/features/home/data/data_sources/brochure_remote_data_source.dart';
import 'package:car_register/features/home/data/models/brochure_model.dart';
import 'package:car_register/features/home/data/repositories/brochure_repository_impl.dart';
import 'package:car_register/features/home/domain/use_cases/add_brochure_use_case.dart';
import 'package:car_register/features/home/domain/use_cases/delete_brochure_use_case.dart';
import 'package:car_register/features/home/domain/use_cases/get_brochures_use_case.dart';
import 'package:car_register/features/home/domain/use_cases/search_brochures_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBrochureRemoteDataSource extends Mock
    implements BrochureRemoteDataSource {}

void main() {
  late MockBrochureRemoteDataSource mockRemoteDataSource;
  late BrochureRepositoryImpl repository;
  late GetBrochuresUseCase getBrochuresUseCase;
  late AddBrochureUseCase addBrochureUseCase;
  late DeleteBrochureUseCase deleteBrochureUseCase;
  late SearchBrochuresUseCase searchBrochuresUseCase;

  const accessCode = 'test_access_code';

  setUp(() {
    mockRemoteDataSource = MockBrochureRemoteDataSource();
    repository = BrochureRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      logger: const AppLogger(),
    );
    getBrochuresUseCase = GetBrochuresUseCase(repository: repository);
    addBrochureUseCase = AddBrochureUseCase(repository: repository);
    deleteBrochureUseCase = DeleteBrochureUseCase(repository: repository);
    searchBrochuresUseCase = SearchBrochuresUseCase(repository: repository);
  });

  group('BrochureRepositoryImpl & UseCases', () {
    test('auto-pads number to 4 digits and stores in Map in O(1)', () async {
      when(
        () => mockRemoteDataSource.addBrochure(
          accessCode: accessCode,
          number: '0005',
        ),
      ).thenAnswer(
        (_) async => BrochureModel(
          id: '0005',
          number: '0005',
          createdAt: DateTime.now(),
        ),
      );

      final result = await addBrochureUseCase(
        accessCode: accessCode,
        number: '5',
      );

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull?.number, '0005');
      expect(repository.containsNumber('5'), isTrue);
      expect(repository.containsNumber('0005'), isTrue);
    });

    test('rejects duplicate number via O(1) in-memory check without hitting backend', () async {
      when(
        () => mockRemoteDataSource.addBrochure(
          accessCode: accessCode,
          number: '0042',
        ),
      ).thenAnswer(
        (_) async => BrochureModel(
          id: '0042',
          number: '0042',
          createdAt: DateTime.now(),
        ),
      );

      await addBrochureUseCase(accessCode: accessCode, number: '42');

      // Attempt adding duplicate
      final dupResult = await addBrochureUseCase(
        accessCode: accessCode,
        number: '0042',
      );

      expect(dupResult.isFailure, isTrue);
      expect(
        dupResult.failureOrNull?.message,
        AppStrings.brochureDuplicateMessage,
      );
      verify(
        () => mockRemoteDataSource.addBrochure(
          accessCode: accessCode,
          number: '0042',
        ),
      ).called(1);
    });

    test('rejects 0000 input', () async {
      final result = await addBrochureUseCase(
        accessCode: accessCode,
        number: '0',
      );

      expect(result.isFailure, isTrue);
      expect(
        result.failureOrNull?.message,
        AppStrings.numberCannotBeAllZeros,
      );
      verifyZeroInteractions(mockRemoteDataSource);
    });

    test('deletes brochure and removes from Map in O(1)', () async {
      when(
        () => mockRemoteDataSource.addBrochure(
          accessCode: accessCode,
          number: '1284',
        ),
      ).thenAnswer(
        (_) async => BrochureModel(
          id: '1284',
          number: '1284',
          createdAt: DateTime.now(),
        ),
      );
      when(
        () => mockRemoteDataSource.deleteBrochure(
          accessCode: accessCode,
          id: '1284',
        ),
      ).thenAnswer((_) async {});

      await addBrochureUseCase(accessCode: accessCode, number: '1284');
      expect(repository.containsNumber('1284'), isTrue);

      final deleteResult = await deleteBrochureUseCase(
        accessCode: accessCode,
        id: '1284',
      );

      expect(deleteResult.isSuccess, isTrue);
      expect(repository.containsNumber('1284'), isFalse);
    });

    test('searches cached Map quickly by partial query', () async {
      when(
        () => mockRemoteDataSource.getBrochures(accessCode: accessCode),
      ).thenAnswer(
        (_) async => [
          BrochureModel(
            id: '0005',
            number: '0005',
            createdAt: DateTime.now(),
          ),
          BrochureModel(
            id: '0055',
            number: '0055',
            createdAt: DateTime.now(),
          ),
          BrochureModel(
            id: '1284',
            number: '1284',
            createdAt: DateTime.now(),
          ),
        ],
      );

      await getBrochuresUseCase(accessCode: accessCode);

      final searchResult = searchBrochuresUseCase('55');
      expect(searchResult.isSuccess, isTrue);
      expect(searchResult.dataOrNull?.length, 1);
      expect(searchResult.dataOrNull?.first.number, '0055');
    });
  });
}
