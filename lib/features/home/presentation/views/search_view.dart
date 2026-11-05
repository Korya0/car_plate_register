import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/di/app_providers.dart';
import 'package:car_register/core/router/app_routes.dart';
import 'package:car_register/core/widgets/custom_confirmation_dialog.dart';
import 'package:car_register/features/home/domain/entities/brochure_entity.dart';
import 'package:car_register/features/home/presentation/providers/home_view_model.dart';
import 'package:car_register/features/home/presentation/widgets/brochure_list_body.dart';
import 'package:car_register/features/home/presentation/widgets/home_brochure_empty_state.dart';
import 'package:car_register/features/home/presentation/widgets/home_page_header.dart';
import 'package:car_register/features/home/presentation/widgets/search/search_header_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(homeViewModelProvider, (previous, next) async {
      if (next.error == null || next.error == previous?.error) return;
      await _showErrorDialog(next.error!);
      ref.read(homeViewModelProvider.notifier).clearError();
    });

    final state = ref.watch(homeViewModelProvider);
    final query = _searchController.text.trim();

    return Scaffold(
      key: const Key('search-view'),
      body: Column(
        children: [
          HomePageHeader(
            watermarkText: AppStrings.brochuresHeaderWatermark,
            child: SearchHeaderContent(
              searchController: _searchController,
              searchFocusNode: _searchFocusNode,
              onSearchChanged: (value) {
                ref.read(homeViewModelProvider.notifier).setQuery(value);
              },
              onSubmit: _dismissKeyboard,
              onBack: _goBack,
            ),
          ),

          Expanded(
            child: BrochureListBody(
              entries: state.brochures,
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

  void _dismissKeyboard() => _searchFocusNode.unfocus();

  Future<void> _showErrorDialog(String message) async {
    await CustomConfirmationDialog.show(
      context: context,
      title: AppStrings.errorWidgetTitle,
      message: message,
      confirmText: AppStrings.okay,
      cancelText: AppStrings.cancel,
    );
  }

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
    final accessCode = ref.read(accessCodeProvider).value;
    if (accessCode.isEmpty) return;
    ref.read(homeViewModelProvider.notifier).deleteBrochure(
      accessCode: accessCode,
      id: entry.id,
    );
  }

  void _goBack() {
    _dismissKeyboard();
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }
}
