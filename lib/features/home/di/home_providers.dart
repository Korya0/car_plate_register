import 'package:car_register/core/utils/app_logger.dart';
import 'package:car_register/features/home/data/data_sources/brochure_remote_data_source.dart';
import 'package:car_register/features/home/data/repositories/brochure_repository_impl.dart';
import 'package:car_register/features/home/domain/repositories/brochure_repository.dart';
import 'package:car_register/features/home/domain/use_cases/add_brochure_use_case.dart';
import 'package:car_register/features/home/domain/use_cases/delete_brochure_use_case.dart';
import 'package:car_register/features/home/domain/use_cases/get_brochures_use_case.dart';
import 'package:car_register/features/home/domain/use_cases/search_brochures_use_case.dart';
import 'package:car_register/features/home/presentation/view_models/home_view_model.dart';
import 'package:car_register/features/home/presentation/view_models/search_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeProviders extends StatelessWidget {
  const HomeProviders({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<BrochureRemoteDataSource>(
          create: (_) => BrochureRemoteDataSourceImpl(
            firestore: FirebaseFirestore.instance,
          ),
        ),
        ProxyProvider<BrochureRemoteDataSource, BrochureRepository>(
          update: (_, remoteDataSource, _) => BrochureRepositoryImpl(
            remoteDataSource: remoteDataSource,
            logger: const AppLogger(),
          ),
        ),
        ProxyProvider<BrochureRepository, GetBrochuresUseCase>(
          update: (_, repository, _) => GetBrochuresUseCase(
            repository: repository,
          ),
        ),
        ProxyProvider<BrochureRepository, AddBrochureUseCase>(
          update: (_, repository, _) => AddBrochureUseCase(
            repository: repository,
          ),
        ),
        ProxyProvider<BrochureRepository, DeleteBrochureUseCase>(
          update: (_, repository, _) => DeleteBrochureUseCase(
            repository: repository,
          ),
        ),
        ProxyProvider<BrochureRepository, SearchBrochuresUseCase>(
          update: (_, repository, _) => SearchBrochuresUseCase(
            repository: repository,
          ),
        ),
        ChangeNotifierProxyProvider4<
          GetBrochuresUseCase,
          AddBrochureUseCase,
          DeleteBrochureUseCase,
          SearchBrochuresUseCase,
          HomeViewModel
        >(
          create: (context) => HomeViewModel(
            getBrochuresUseCase: context.read<GetBrochuresUseCase>(),
            addBrochureUseCase: context.read<AddBrochureUseCase>(),
            deleteBrochureUseCase: context.read<DeleteBrochureUseCase>(),
          ),
          update:
              (
                _,
                getUseCase,
                addUseCase,
                deleteUseCase,
                searchUseCase,
                previous,
              ) =>
                  previous ??
                  HomeViewModel(
                    getBrochuresUseCase: getUseCase,
                    addBrochureUseCase: addUseCase,
                    deleteBrochureUseCase: deleteUseCase,
                  ),
        ),
        ChangeNotifierProxyProvider3<
          GetBrochuresUseCase,
          DeleteBrochureUseCase,
          SearchBrochuresUseCase,
          SearchViewModel
        >(
          create: (context) => SearchViewModel(
            searchBrochuresUseCase: context.read<SearchBrochuresUseCase>(),
            deleteBrochureUseCase: context.read<DeleteBrochureUseCase>(),
            getBrochuresUseCase: context.read<GetBrochuresUseCase>(),
          ),
          update: (_, getUseCase, deleteUseCase, searchUseCase, previous) =>
              previous ??
              SearchViewModel(
                searchBrochuresUseCase: searchUseCase,
                deleteBrochureUseCase: deleteUseCase,
                getBrochuresUseCase: getUseCase,
              ),
        ),
      ],
      child: child,
    );
  }
}
