import 'package:flutter_test/flutter_test.dart';

import 'package:car_register/core/error/failure.dart';
import 'package:car_register/core/error/result.dart';

void main() {
  group('Result', () {
    test('success exposes data and reports success', () {
      const Result<int> result = Result.success(42);

      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.dataOrNull, 42);
      expect(result.failureOrNull, isNull);
      expect(result, isA<Success<int>>());
    });

    test('failure exposes the failure and reports failure', () {
      const Failure failure = NetworkFailure(message: 'offline');
      const Result<int> result = Result.failure(failure);

      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(result.dataOrNull, isNull);
      expect(result.failureOrNull, same(failure));
      expect(result, isA<FailureResult<int>>());
    });
  });
}
