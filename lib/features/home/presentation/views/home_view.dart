import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/router/app_routes.dart';
import 'package:car_register/core/utils/app_logger.dart';
import 'package:car_register/core/utils/app_validators.dart';
import 'package:car_register/core/widgets/custom_confirmation_dialog.dart';
import 'package:car_register/features/home/data/data_sources/brochure_remote_data_source.dart';
import 'package:car_register/features/home/data/repositories/brochure_repository_impl.dart';
import 'package:car_register/features/home/domain/entities/brochure_entity.dart';
import 'package:car_register/features/home/domain/use_cases/add_brochure_use_case.dart';
import 'package:car_register/features/home/domain/use_cases/delete_brochure_use_case.dart';
import 'package:car_register/features/home/domain/use_cases/get_brochures_use_case.dart';
import 'package:car_register/features/home/presentation/view_models/home_view_model.dart';
import 'package:car_register/features/home/presentation/widgets/brochure_list_body.dart';
import 'package:car_register/features/home/presentation/widgets/home/home_header_content.dart';
import 'package:car_register/features/home/presentation/widgets/home_brochure_empty_state.dart';
import 'package:car_register/features/home/presentation/widgets/home_page_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _numberController = TextEditingController();
  final FocusNode _numberFocusNode = FocusNode();
  late final HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    final remoteDataSource = BrochureRemoteDataSourceImpl(
      firestore: FirebaseFirestore.instance,
    );

    final repository = BrochureRepositoryImpl(
      remoteDataSource: remoteDataSource,
      logger: const AppLogger(),
    );

    final getUseCase = GetBrochuresUseCase(repository: repository);
    final addUseCase = AddBrochureUseCase(repository: repository);
    final deleteUseCase = DeleteBrochureUseCase(repository: repository);

    _viewModel = HomeViewModel(
      getBrochuresUseCase: getUseCase,
      addBrochureUseCase: addUseCase,
      deleteBrochureUseCase: deleteUseCase,
    );

    _viewModel.loadBrochures();
  }

  @override
  void dispose() {
    _numberController.dispose();
    _numberFocusNode.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _dismissKeyboard() => _numberFocusNode.unfocus();

  Future<bool> _confirmDelete(BrochureEntity entry) async {
    _dismissKeyboard();
    final confirmed = await CustomConfirmationDialog.show(
      context: context,
      title: AppStrings.deleteBrochureTitle,
      message: AppStrings.deleteBrochureMessage(entry.number),
      confirmText: AppStrings.delete,
      cancelText: AppStrings.cancel,
    );
    return mounted && confirmed == true;
  }

  Future<bool> _confirmDeleteMany(int count) async {
    _dismissKeyboard();
    final confirmed = await CustomConfirmationDialog.show(
      context: context,
      title: AppStrings.deleteBrochureTitle,
      message: AppStrings.deleteSelectedMessage(count),
      confirmText: AppStrings.delete,
      cancelText: AppStrings.cancel,
    );
    return mounted && confirmed == true;
  }

  void _deleteEntry(BrochureEntity entry) {
    _viewModel.deleteBrochure(entry);
  }

  Future<void> _saveNumber() async {
    final number = _numberController.text;

    final validationMessage = AppValidators.brochureNumber(number.trim());
    if (validationMessage != null) {
      _dismissKeyboard();
      await CustomConfirmationDialog.show(
        context: context,
        title: AppStrings.brochureInputErrorTitle,
        message: validationMessage,
        confirmText: AppStrings.okay,
        cancelText: AppStrings.cancel,
      );
      return;
    }

    final success = await _viewModel.addBrochure(number);

    if (!mounted) return;

    if (success) {
      _numberController.clear();
      return;
    }

    final error = _viewModel.errorText;
    if (error != null && error.isNotEmpty) {
      _dismissKeyboard();
      await CustomConfirmationDialog.show(
        context: context,
        title: AppStrings.brochureDuplicateTitle,
        message: error,
        confirmText: AppStrings.okay,
        cancelText: AppStrings.cancel,
      );
      _viewModel.clearError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_viewModel, _numberController]),
      builder: (context, child) {
        return Scaffold(
          key: const Key('home-view'),
          body: Column(
            children: [
              HomePageHeader(
                watermarkText: AppStrings.homeHeaderWatermark,
                fillWatermarkHeight: true,
                child: HomeHeaderContent(
                  numberController: _numberController,
                  numberFocusNode: _numberFocusNode,
                  onSave: _saveNumber,
                  onSearch: () async {
                    _dismissKeyboard();
                    await context.push(AppRoutes.search);
                    if (mounted) {
                      _viewModel.loadBrochures();
                    }
                  },
                ),
              ),
              Expanded(
                child: BrochureListBody(
                  entries: _viewModel.entries,
                  query: '',
                  emptyState: const HomeBrochureEmptyState(),
                  noMatchesState: const HomeBrochureEmptyState(subtitle: null),
                  onConfirmDelete: _confirmDelete,
                  onConfirmDeleteMany: _confirmDeleteMany,
                  onDelete: _deleteEntry,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
