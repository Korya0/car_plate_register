import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/error/failure.dart';
import 'package:car_register/core/error/result.dart';
import 'package:car_register/core/utils/app_logger.dart';
import 'package:car_register/features/access_control/data/data_sources/access_control_remote_data_source.dart';
import 'package:car_register/features/access_control/domain/entities/access_code_entity.dart';
import 'package:car_register/features/access_control/domain/repositories/access_control_repository.dart';

class AccessControlRepositoryImpl implements AccessControlRepository {
  const AccessControlRepositoryImpl({
    required this.remoteDataSource,
    required this.logger,
  });

  final AccessControlRemoteDataSource remoteDataSource;
  final AppLogger logger;

  @override
  // Validates an access code and returns its entity if valid and active.
  Future<Result<AccessCodeEntity>> validateAccessCode(String code) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty) {
      return const Result.failure(
        ValidationFailure(message: AppStrings.accessCodeRequired),
      );
    }

    try {
      final model = await remoteDataSource.getAccessCode(trimmed);
      if (model == null) {
        return const Result.failure(
          ValidationFailure(message: AppStrings.accessCodeInvalid),
        );
      }

      if (!model.isActive) {
        return const Result.failure(
          ValidationFailure(message: AppStrings.accessCodeDisabled),
        );
      }

      logger.info('Access code validated successfully: $trimmed');
      return Result.success(model.toEntity());
    } on FirebaseException catch (e, st) {
      if (e.code == 'permission-denied' || e.code == 'not-found') {
        logger.error(
          'Access code invalid or revoked',
          error: e,
          stackTrace: st,
        );
        return const Result.failure(
          AccessCodeFailure(message: AppStrings.accessCodeChangedMessage),
        );
      }
      logger.error(
        'Firebase error while validating access code',
        error: e,
        stackTrace: st,
      );
      return const Result.failure(
        NetworkFailure(message: AppStrings.errorWidgetTitle),
      );
    } on SocketException catch (e, st) {
      logger.error(
        'Network error while validating access code',
        error: e,
        stackTrace: st,
      );
      return const Result.failure(
        NetworkFailure(message: AppStrings.networkUnavailableMessage),
      );
    } on TimeoutException catch (e, st) {
      logger.error(
        'Timeout error while validating access code',
        error: e,
        stackTrace: st,
      );
      return const Result.failure(
        NetworkFailure(message: AppStrings.networkTimeoutMessage),
      );
    } catch (e, st) {
      logger.error(
        'Unexpected error while validating access code',
        error: e,
        stackTrace: st,
      );
      return const Result.failure(
        UnknownFailure(message: AppStrings.errorWidgetTitle),
      );
    }
  }
}
