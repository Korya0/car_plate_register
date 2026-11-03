import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/router/app_routes.dart';
import 'package:car_register/core/utils/app_logger.dart';
import 'package:car_register/core/widgets/custom_confirmation_dialog.dart';
import 'package:car_register/features/home/data/data_sources/brochure_remote_data_source.dart';
import 'package:car_register/features/home/data/repositories/brochure_repository_impl.dart';
import 'package:car_register/features/home/domain/entities/brochure_entity.dart';
import 'package:car_register/features/home/domain/use_cases/delete_brochure_use_case.dart';
import 'package:car_register/features/home/domain/use_cases/get_brochures_use_case.dart';
import 'package:car_register/features/home/domain/use_cases/search_brochures_use_case.dart';
import 'package:car_register/features/home/presentation/scopes/search_scope.dart';
import 'package:car_register/features/home/presentation/view_models/search_view_model.dart';
import 'package:car_register/features/home/presentation/widgets/brochure_list_body.dart';
import 'package:car_register/features/home/presentation/widgets/home_brochure_empty_state.dart';
import 'package:car_register/features/home/presentation/widgets/home_page_header.dart';
import 'package:car_register/features/home/presentation/widgets/search/search_header_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late final SearchViewModel _viewModel;

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

    final searchUseCase = SearchBrochuresUseCase(repository: repository);
    final deleteUseCase = DeleteBrochureUseCase(repository: repository);
    final getUseCase = GetBrochuresUseCase(repository: repository);

    _viewModel = SearchViewModel(
      searchBrochuresUseCase: searchUseCase,
      deleteBrochureUseCase: deleteUseCase,
      getBrochuresUseCase: getUseCase,
    );

    _viewModel.loadBrochures();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    _searchFocusNode.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _viewModel.search(_searchController.text);
  }

  void _dismissKeyboard() => _searchFocusNode.unfocus();

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

  void _goBack() {
    _dismissKeyboard();
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim();

    return SearchScope(
      notifier: _viewModel,
      child: AnimatedBuilder(
        animation: Listenable.merge([_viewModel, _searchController]),
        builder: (context, child) {
          final viewModel = SearchScope.of(context);

          return Scaffold(
            key: const Key('search-view'),
            body: Column(
              children: [
                HomePageHeader(
                  watermarkText: AppStrings.brochuresHeaderWatermark,
                  child: SearchHeaderContent(
                    searchController: _searchController,
                    searchFocusNode: _searchFocusNode,
                    onSearchChanged: (_) {},
                    onSubmit: _dismissKeyboard,
                    onBack: _goBack,
                  ),
                ),
                Expanded(
                  child: BrochureListBody(
                    entries: viewModel.results,
                    query: query,
                    emptyState: HomeBrochureEmptyState(onAdd: _goBack),
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
      ),
    );
  }
}
