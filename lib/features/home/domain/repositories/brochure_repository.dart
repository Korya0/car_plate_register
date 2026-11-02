import 'package:car_register/core/error/result.dart';
import 'package:car_register/features/home/domain/entities/brochure_entity.dart';

abstract interface class BrochureRepository {
  // Retrieves brochures, populating the in-memory map index.
  Future<Result<List<BrochureEntity>>> getBrochures({
    required String accessCode,
  });

  // Adds a brochure number, ensuring 4-digit uniqueness in the map and remote.
  Future<Result<BrochureEntity>> addBrochure({
    required String accessCode,
    required String number,
  });

  // Deletes a single brochure by ID.
  Future<Result<void>> deleteBrochure({
    required String accessCode,
    required String id,
  });

  // Deletes multiple brochures by their IDs.
  Future<Result<void>> deleteManyBrochures({
    required String accessCode,
    required List<String> ids,
  });

  // Searches cached brochures in-memory with high performance.
  Result<List<BrochureEntity>> searchBrochures(String query);

  // Checks in O(1) if a brochure number already exists in the local map.
  bool containsNumber(String number);
}
