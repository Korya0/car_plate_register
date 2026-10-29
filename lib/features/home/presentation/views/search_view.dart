import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/router/app_routes.dart';
import 'package:car_register/core/widgets/custom_confirmation_dialog.dart';
import 'package:car_register/features/home/domain/entities/brochure_entity.dart';
import 'package:car_register/features/home/presentation/mock/brochure_mock_store.dart';
import 'package:car_register/features/home/presentation/widgets/brochure_list_body.dart';
import 'package:car_register/features/home/presentation/widgets/home_brochure_empty_state.dart';
import 'package:car_register/features/home/presentation/widgets/home_page_header.dart';
import 'package:car_register/features/home/presentation/widgets/search/search_header_content.dart';
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

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _dismissKeyboard() => _searchFocusNode.unfocus();

  // Confirms deleting one entry; `false` keeps it.
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

  // Confirms deleting the selected entries; `false` keeps them.
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

  // Deletes one entry.
  void _deleteEntry(BrochureEntity entry) {
    final deleted = BrochureMockStore.delete(entry.id);
    if (deleted == null) return;

    setState(() {});
  }

  // Returns to home.
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

    return Scaffold(
      key: const Key('search-view'),
      body: Column(
        children: [
          // Header
          HomePageHeader(
            watermarkText: AppStrings.brochuresHeaderWatermark,
            child: SearchHeaderContent(
              searchController: _searchController,
              searchFocusNode: _searchFocusNode,
              onSearchChanged: (_) => setState(() {}),
              onSubmit: _dismissKeyboard,
              onBack: _goBack,
            ),
          ),

          // Body
          Expanded(
            child: BrochureListBody(
              entries: BrochureMockStore.entries,
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
  }
}
