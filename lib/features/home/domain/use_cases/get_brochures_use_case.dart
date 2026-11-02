import 'package:car_register/core/error/result.dart';
import 'package:car_register/features/home/domain/entities/brochure_entity.dart';
import 'package:car_register/features/home/domain/repositories/brochure_repository.dart';

class GetBrochuresUseCase {
  const GetBrochuresUseCase({
    required this.repository,
  });

  final BrochureRepository repository;

  // Loads all brochures for the given access code.
  Future<Result<List<BrochureEntity>>> call({required String accessCode}) =>
      repository.getBrochures(accessCode: accessCode);
}
