import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/router/app_routes.dart';
import 'package:car_register/core/widgets/custom_confirmation_dialog.dart';
import 'package:car_register/features/home/di/home_providers.dart';
import 'package:car_register/features/home/domain/entities/brochure_entity.dart';
import 'package:car_register/features/home/presentation/view_models/search_view_model.dart';
import 'package:car_register/features/home/presentation/widgets/brochure_list_body.dart';
import 'package:car_register/features/home/presentation/widgets/home_brochure_empty_state.dart';
import 'package:car_register/features/home/presentation/widgets/home_page_header.dart';
import 'package:car_register/features/home/presentation/widgets/search/search_header_content.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // Handled inside Consumer builder below
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

    return HomeProviders(
      child: Consumer<SearchViewModel>(
        builder: (context, viewModel, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            if (viewModel.results.isEmpty && !viewModel.isSearching) {
              viewModel.loadBrochures();
            }
          });

          return Scaffold(
            key: const Key('search-view'),
            body: Column(
              children: [
                HomePageHeader(
                  watermarkText: AppStrings.brochuresHeaderWatermark,
                  child: SearchHeaderContent(
                    searchController: _searchController,
                    searchFocusNode: _searchFocusNode,
                    onSearchChanged: (_) {
                      viewModel.search(_searchController.text);
                    },
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
                    onDelete: viewModel.deleteBrochure,
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
