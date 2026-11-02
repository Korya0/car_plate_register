import 'package:car_register/core/error/result.dart';
import 'package:car_register/features/home/domain/repositories/brochure_repository.dart';

class DeleteBrochureUseCase {
  const DeleteBrochureUseCase({
    required this.repository,
  });

  final BrochureRepository repository;

  // Deletes a single brochure by ID.
  Future<Result<void>> call({
    required String accessCode,
    required String id,
  }) => repository.deleteBrochure(accessCode: accessCode, id: id);

  // Deletes multiple brochures by their IDs.
  Future<Result<void>> many({
    required String accessCode,
    required List<String> ids,
  }) => repository.deleteManyBrochures(accessCode: accessCode, ids: ids);
}
