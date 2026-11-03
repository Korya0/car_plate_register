import 'package:car_register/core/utils/app_logger.dart';
import 'package:car_register/features/access_control/data/data_sources/access_control_remote_data_source.dart';
import 'package:car_register/features/access_control/data/repositories/access_control_repository_impl.dart';
import 'package:car_register/features/access_control/domain/repositories/access_control_repository.dart';
import 'package:car_register/features/access_control/domain/use_cases/validate_access_code_use_case.dart';
import 'package:car_register/features/access_control/presentation/view_models/access_code_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccessCodeProviders extends StatelessWidget {
  const AccessCodeProviders({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AccessControlRemoteDataSource>(
          create: (_) => AccessControlRemoteDataSourceImpl(
            firestore: FirebaseFirestore.instance,
          ),
        ),
        ProxyProvider<AccessControlRemoteDataSource, AccessControlRepository>(
          update: (_, remoteDataSource, _) => AccessControlRepositoryImpl(
            remoteDataSource: remoteDataSource,
            logger: const AppLogger(),
          ),
        ),
        ProxyProvider<AccessControlRepository, ValidateAccessCodeUseCase>(
          update: (_, repository, _) => ValidateAccessCodeUseCase(
            repository: repository,
          ),
        ),
        ChangeNotifierProxyProvider<
          ValidateAccessCodeUseCase,
          AccessCodeViewModel
        >(
          create: (context) => AccessCodeViewModel(
            verifyAccessCode: context.read<ValidateAccessCodeUseCase>(),
          ),
          update: (_, useCase, previous) =>
              previous ??
              AccessCodeViewModel(
                verifyAccessCode: useCase,
              ),
        ),
      ],
      child: child,
    );
  }
}
