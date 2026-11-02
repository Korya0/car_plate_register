import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:car_register/core/di/app_providers.dart';
import 'package:car_register/features/access_control/data/data_sources/access_control_remote_data_source.dart';
import 'package:car_register/features/access_control/data/repositories/access_control_repository_impl.dart';
import 'package:car_register/features/access_control/domain/repositories/access_control_repository.dart';
import 'package:car_register/features/access_control/domain/use_cases/validate_access_code_use_case.dart';

final accessControlRemoteDataSourceProvider =
    Provider<AccessControlRemoteDataSource>(
      (ref) => AccessControlRemoteDataSourceImpl(
        firestore: ref.watch(firebaseFirestoreProvider),
      ),
    );

final accessControlRepositoryProvider = Provider<AccessControlRepository>(
  (ref) => AccessControlRepositoryImpl(
    remoteDataSource: ref.watch(accessControlRemoteDataSourceProvider),
    logger: ref.watch(appLoggerProvider),
  ),
);

final validateAccessCodeUseCaseProvider = Provider<ValidateAccessCodeUseCase>(
  (ref) => ValidateAccessCodeUseCase(
    repository: ref.watch(accessControlRepositoryProvider),
  ),
);
