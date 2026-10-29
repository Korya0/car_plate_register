import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/router/app_routes.dart';
import 'package:car_register/features/home/presentation/views/brochure_actions.dart';
import 'package:car_register/features/home/presentation/widgets/brochure_list_body.dart';
import 'package:car_register/features/home/presentation/widgets/home_brochure_empty_state.dart';
import 'package:car_register/features/home/presentation/widgets/home_page_header.dart';
import 'package:car_register/features/home/presentation/widgets/search/search_header_content.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView>
    with BrochureActions<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void dismissKeyboard() => _searchFocusNode.unfocus();

  // Returns to home.
  void _goBack() {
    dismissKeyboard();
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
              onBack: _goBack,
              onDeleteAll: () => confirmDeleteAll(),
            ),
          ),

          // Body
          Expanded(
            child: BrochureListBody(
              query: query,
              emptyState: HomeBrochureEmptyState(onAdd: _goBack),
              noMatchesState: const HomeBrochureEmptyState(subtitle: null),
              onDelete: (entry) => confirmDelete(entry),
            ),
          ),
        ],
      ),
    );
  }
}
