import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:car_register/core/di/app_providers.dart';
import 'package:car_register/features/home/data/data_sources/brochure_remote_data_source.dart';
import 'package:car_register/features/home/data/repositories/brochure_repository_impl.dart';
import 'package:car_register/features/home/domain/repositories/brochure_repository.dart';
import 'package:car_register/features/home/domain/use_cases/add_brochure_use_case.dart';
import 'package:car_register/features/home/domain/use_cases/delete_brochure_use_case.dart';
import 'package:car_register/features/home/domain/use_cases/get_brochures_use_case.dart';
import 'package:car_register/features/home/domain/use_cases/search_brochures_use_case.dart';

final brochureRemoteDataSourceProvider = Provider<BrochureRemoteDataSource>(
  (ref) => BrochureRemoteDataSourceImpl(
    firestore: ref.watch(firebaseFirestoreProvider),
  ),
);

final brochureRepositoryProvider = Provider<BrochureRepository>(
  (ref) => BrochureRepositoryImpl(
    remoteDataSource: ref.watch(brochureRemoteDataSourceProvider),
    logger: ref.watch(appLoggerProvider),
  ),
);

final getBrochuresUseCaseProvider = Provider<GetBrochuresUseCase>(
  (ref) => GetBrochuresUseCase(
    repository: ref.watch(brochureRepositoryProvider),
  ),
);

final addBrochureUseCaseProvider = Provider<AddBrochureUseCase>(
  (ref) => AddBrochureUseCase(
    repository: ref.watch(brochureRepositoryProvider),
  ),
);

final deleteBrochureUseCaseProvider = Provider<DeleteBrochureUseCase>(
  (ref) => DeleteBrochureUseCase(
    repository: ref.watch(brochureRepositoryProvider),
  ),
);

final searchBrochuresUseCaseProvider = Provider<SearchBrochuresUseCase>(
  (ref) => SearchBrochuresUseCase(
    repository: ref.watch(brochureRepositoryProvider),
  ),
);
