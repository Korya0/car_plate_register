import 'package:car_register/core/error/result.dart';
import 'package:car_register/features/access_control/domain/entities/access_code_entity.dart';

abstract interface class AccessControlRepository {
  // Validates an access code and returns its entity if valid and active.
  Future<Result<AccessCodeEntity>> validateAccessCode(String code);
}
