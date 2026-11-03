import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/utils/app_logger.dart';
import 'package:car_register/core/widgets/app_gap.dart';
import 'package:car_register/features/access_control/data/data_sources/access_control_remote_data_source.dart';
import 'package:car_register/features/access_control/data/repositories/access_control_repository_impl.dart';
import 'package:car_register/features/access_control/domain/use_cases/validate_access_code_use_case.dart';
import 'package:car_register/features/access_control/presentation/scopes/access_code_scope.dart';
import 'package:car_register/features/access_control/presentation/view_models/access_code_view_model.dart';
import 'package:car_register/features/access_control/presentation/widgets/access_code_form.dart';
import 'package:car_register/features/access_control/presentation/widgets/access_code_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AccessCodeView extends StatefulWidget {
  const AccessCodeView({super.key});

  @override
  State<AccessCodeView> createState() => _AccessCodeViewState();
}

class _AccessCodeViewState extends State<AccessCodeView> {
  late final AccessCodeViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    final remoteDataSource = AccessControlRemoteDataSourceImpl(
      firestore: FirebaseFirestore.instance,
    );

    final repository = AccessControlRepositoryImpl(
      remoteDataSource: remoteDataSource,
      logger: const AppLogger(),
    );

    final useCase = ValidateAccessCodeUseCase(repository: repository);

    _viewModel = AccessCodeViewModel(verifyAccessCode: useCase);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AccessCodeScope(
        notifier: _viewModel,
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverSafeArea(
                bottom: false,
                sliver: SliverPadding(
                  padding: EdgeInsets.only(
                    top: AppSize.stp,
                    left: AppSize.p16,
                    right: AppSize.p16,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AppSize.contentMaxWidth,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          const AccessCodeHeader(),

                          AppGap.h(AppSize.p32),

                          // Form
                          const AccessCodeForm(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: AppGap.h(AppSize.sbp)),
            ],
          ),
        ),
      );
}

