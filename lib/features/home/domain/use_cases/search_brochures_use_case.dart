import 'package:car_register/core/error/result.dart';
import 'package:car_register/features/home/domain/entities/brochure_entity.dart';
import 'package:car_register/features/home/domain/repositories/brochure_repository.dart';

class SearchBrochuresUseCase {
  const SearchBrochuresUseCase({
    required this.repository,
  });

  final BrochureRepository repository;

  // Performs fast in-memory search over cached brochures.
  Result<List<BrochureEntity>> call(String query) =>
      repository.searchBrochures(query);
}
