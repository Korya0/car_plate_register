import 'package:car_register/core/error/result.dart';
import 'package:car_register/features/access_control/domain/entities/access_code_entity.dart';
import 'package:car_register/features/access_control/domain/repositories/access_control_repository.dart';

class ValidateAccessCodeUseCase {
  const ValidateAccessCodeUseCase({
    required this.repository,
  });

  final AccessControlRepository repository;

  // Validates an entered access code against the repository.
  Future<Result<AccessCodeEntity>> call(String code) =>
      repository.validateAccessCode(code);
}
