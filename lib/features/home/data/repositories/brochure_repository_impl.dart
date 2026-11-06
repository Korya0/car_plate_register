import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/constants/firebase_constants.dart';
import 'package:car_register/core/error/failure.dart';
import 'package:car_register/core/error/result.dart';
import 'package:car_register/core/utils/app_logger.dart';
import 'package:car_register/features/home/data/data_sources/brochure_remote_data_source.dart';
import 'package:car_register/features/home/domain/entities/brochure_entity.dart';
import 'package:car_register/features/home/domain/repositories/brochure_repository.dart';
import 'package:car_register/features/home/domain/validators/brochure_number_validator.dart';

class BrochureRepositoryImpl implements BrochureRepository {
  BrochureRepositoryImpl({
    required this.remoteDataSource,
    required this.logger,
  });

  final BrochureRemoteDataSource remoteDataSource;
  final AppLogger logger;

  // In-memory Map keyed by 4-digit brochure number for O(1) operations.
  final LinkedHashMap<String, BrochureEntity> _platesByNumber =
      LinkedHashMap<String, BrochureEntity>();

  // Maps Firestore errors to domain failures. Permission-denied / not-found
  // on the access code path means the shared access code changed or was
  // revoked; everything else is treated as a generic network error.
  Failure _mapFirebaseError(FirebaseException e) {
    if (e.code == FirebaseErrorCodes.permissionDenied ||
        e.code == FirebaseErrorCodes.notFound) {
      return const AccessCodeFailure(
        message: AppStrings.accessCodeChangedMessage,
      );
    }
    return const NetworkFailure(message: AppStrings.errorWidgetTitle);
  }

  @override
  // Checks in O(1) if a brochure number already exists.
  bool containsNumber(String number) {
    final formatted = BrochureNumberValidator.format(number);
    return _platesByNumber.containsKey(formatted);
  }

  @override
  // Retrieves brochures and seeds the in-memory map.
  Future<Result<List<BrochureEntity>>> getBrochures({
    required String accessCode,
  }) async {
    try {
      final models = await remoteDataSource.getBrochures(
        accessCode: accessCode,
      );
      _platesByNumber.clear();

      for (final model in models) {
        final entity = model.toEntity();
        _platesByNumber[entity.number] = entity;
      }

      logger.info(
        'Loaded ${_platesByNumber.length} brochures for access code session',
      );
      return Result.success(_platesByNumber.values.toList());
    } on FirebaseException catch (e, st) {
      logger.error(
        'Firebase error fetching brochures',
        error: e,
        stackTrace: st,
      );
      return const Result.failure(
        NetworkFailure(message: AppStrings.errorWidgetTitle),
      );
    } on SocketException catch (e, st) {
      logger.error(
        'Network error fetching brochures',
        error: e,
        stackTrace: st,
      );
      return const Result.failure(
        NetworkFailure(message: AppStrings.errorWidgetTitle),
      );
    } catch (e, st) {
      logger.error(
        'Unexpected error fetching brochures',
        error: e,
        stackTrace: st,
      );
      return const Result.failure(
        UnknownFailure(message: AppStrings.errorWidgetTitle),
      );
    }
  }

  @override
  // Adds a brochure with 4-digit padding, uniqueness check, and O(1) caching.
  Future<Result<BrochureEntity>> addBrochure({
    required String accessCode,
    required String number,
  }) async {
    final validationError = BrochureNumberValidator.validate(number);
    if (validationError != null) {
      return Result.failure(ValidationFailure(message: validationError));
    }

    final formattedNumber = BrochureNumberValidator.format(number);

    if (_platesByNumber.containsKey(formattedNumber)) {
      return const Result.failure(
        ValidationFailure(message: AppStrings.brochureDuplicateMessage),
      );
    }

    try {
      final model = await remoteDataSource.addBrochure(
        accessCode: accessCode,
        number: formattedNumber,
      );
      final entity = model.toEntity();

      // Put newest at the front of the linked map.
      final updated = <String, BrochureEntity>{
        entity.number: entity,
        ..._platesByNumber,
      };
      _platesByNumber
        ..clear()
        ..addAll(updated);

      logger.success('Added brochure: $formattedNumber');
      return Result.success(entity);
    } on FirebaseException catch (e, st) {
      logger.error('Firebase error adding brochure', error: e, stackTrace: st);
      return Result.failure(_mapFirebaseError(e));
    } on SocketException catch (e, st) {
      logger.error(
        'Network error adding brochure',
        error: e,
        stackTrace: st,
      );
      return const Result.failure(
        NetworkFailure(message: AppStrings.networkUnavailableMessage),
      );
    } on TimeoutException catch (e, st) {
      logger.error(
        'Timeout error adding brochure',
        error: e,
        stackTrace: st,
      );
      return const Result.failure(
        NetworkFailure(message: AppStrings.networkTimeoutMessage),
      );
    } catch (e, st) {
      logger.error(
        'Unexpected error adding brochure',
        error: e,
        stackTrace: st,
      );
      return const Result.failure(
        UnknownFailure(message: AppStrings.errorWidgetTitle),
      );
    }
  }

  @override
  // Deletes a single brochure by ID and updates the map in O(1).
  Future<Result<void>> deleteBrochure({
    required String accessCode,
    required String id,
  }) async {
    try {
      await remoteDataSource.deleteBrochure(
        accessCode: accessCode,
        id: id,
      );

      _platesByNumber.remove(id);

      logger.info('Deleted brochure with id: $id');
      return const Result.success(null);
    } on FirebaseException catch (e, st) {
      logger.error(
        'Firebase error fetching brochures',
        error: e,
        stackTrace: st,
      );
      return Result.failure(_mapFirebaseError(e));
    } on SocketException catch (e, st) {
      logger.error(
        'Network error fetching brochures',
        error: e,
        stackTrace: st,
      );
      return const Result.failure(
        NetworkFailure(message: AppStrings.networkUnavailableMessage),
      );
    } on TimeoutException catch (e, st) {
      logger.error(
        'Timeout error fetching brochures',
        error: e,
        stackTrace: st,
      );
      return const Result.failure(
        NetworkFailure(message: AppStrings.networkTimeoutMessage),
      );
    } catch (e, st) {
      logger.error(
        'Unexpected error fetching brochures',
        error: e,
        stackTrace: st,
      );
      return const Result.failure(
        UnknownFailure(message: AppStrings.errorWidgetTitle),
      );
    }
  }

  @override
  // Deletes multiple brochures in batch and purges them from the map.
  Future<Result<void>> deleteManyBrochures({
    required String accessCode,
    required List<String> ids,
  }) async {
    try {
      await remoteDataSource.deleteManyBrochures(
        accessCode: accessCode,
        ids: ids,
      );

      final idSet = ids.toSet();
      _platesByNumber.removeWhere(
        (key, entity) => idSet.contains(key) || idSet.contains(entity.id),
      );

      logger.info('Deleted ${ids.length} brochures');
      return const Result.success(null);
    } on FirebaseException catch (e, st) {
      logger.error(
        'Firebase error deleting multiple brochures',
        error: e,
        stackTrace: st,
      );
      return Result.failure(_mapFirebaseError(e));
    } on SocketException catch (e, st) {
      logger.error(
        'Network error deleting multiple brochures',
        error: e,
        stackTrace: st,
      );
      return const Result.failure(
        NetworkFailure(message: AppStrings.networkUnavailableMessage),
      );
    } on TimeoutException catch (e, st) {
      logger.error(
        'Timeout error deleting multiple brochures',
        error: e,
        stackTrace: st,
      );
      return const Result.failure(
        NetworkFailure(message: AppStrings.networkTimeoutMessage),
      );
    } catch (e, st) {
      logger.error(
        'Unexpected error deleting multiple brochures',
        error: e,
        stackTrace: st,
      );
      return const Result.failure(
        UnknownFailure(message: AppStrings.errorWidgetTitle),
      );
    }
  }

  @override
  // Fast in-memory search over the cached map.
  Result<List<BrochureEntity>> searchBrochures(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return Result.success(_platesByNumber.values.toList());
    }

    final matches = _platesByNumber.values
        .where((entry) => entry.number.contains(trimmed))
        .toList();

    return Result.success(matches);
  }
}
