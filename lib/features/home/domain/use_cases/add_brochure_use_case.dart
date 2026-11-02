import 'package:car_register/core/error/result.dart';
import 'package:car_register/features/home/domain/entities/brochure_entity.dart';
import 'package:car_register/features/home/domain/repositories/brochure_repository.dart';

class AddBrochureUseCase {
  const AddBrochureUseCase({
    required this.repository,
  });

  final BrochureRepository repository;

  // Adds a brochure number under the given access code.
  Future<Result<BrochureEntity>> call({
    required String accessCode,
    required String number,
  }) => repository.addBrochure(accessCode: accessCode, number: number);
}
