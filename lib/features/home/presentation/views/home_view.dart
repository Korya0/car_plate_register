import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/router/app_routes.dart';
import 'package:car_register/core/utils/app_validators.dart';
import 'package:car_register/core/widgets/custom_confirmation_dialog.dart';
import 'package:car_register/features/home/presentation/providers/brochure_list_provider.dart';
import 'package:car_register/features/home/presentation/views/brochure_actions.dart';
import 'package:car_register/features/home/presentation/widgets/brochure_list_body.dart';
import 'package:car_register/features/home/presentation/widgets/home/home_header_content.dart';
import 'package:car_register/features/home/presentation/widgets/home_brochure_empty_state.dart';
import 'package:car_register/features/home/presentation/widgets/home_page_header.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView>
    with BrochureActions<HomeView> {
  final TextEditingController _numberController = TextEditingController();
  final FocusNode _numberFocusNode = FocusNode();
  bool _isSaving = false;

  @override
  void dispose() {
    _numberController.dispose();
    _numberFocusNode.dispose();
    super.dispose();
  }

  @override
  void dismissKeyboard() => _numberFocusNode.unfocus();

  // Opens the search screen.
  void _openSearch() {
    dismissKeyboard();
    context.push(AppRoutes.search);
  }

  // Validates and adds a number.
  Future<void> _saveNumber() async {
    if (_isSaving) return;

    final number = _numberController.text.trim();
    final validationMessage = AppValidators.brochureNumber(number);
    if (validationMessage != null) {
      await CustomConfirmationDialog.show(
        context: context,
        title: AppStrings.brochureInputErrorTitle,
        message: validationMessage,
        confirmText: AppStrings.okay,
        cancelText: AppStrings.cancel,
      );
      return;
    }

    final records = ref.read(brochureListProvider).value;
    if (records?.any((entry) => entry.number == number) ?? false) {
      await _showDuplicateDialog();
      return;
    }

    setState(() => _isSaving = true);
    await Future<void>.delayed(AppConstants.animationFast200ms);
    if (!mounted) return;

    final added = ref.read(brochureListProvider.notifier).add(number);
    if (added == null) {
      setState(() => _isSaving = false);
      await _showDuplicateDialog();
      return;
    }

    _numberController.clear();
    setState(() => _isSaving = false);
  }

  // Shows duplicate warning.
  Future<void> _showDuplicateDialog() => CustomConfirmationDialog.show(
    context: context,
    title: AppStrings.brochureDuplicateTitle,
    message: AppStrings.brochureDuplicateMessage,
    confirmText: AppStrings.okay,
    cancelText: AppStrings.cancel,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('home-view'),
      body: Column(
        children: [
          // Header
          HomePageHeader(
            watermarkText: AppStrings.homeHeaderWatermark,
            fillWatermarkHeight: true,
            child: HomeHeaderContent(
              numberController: _numberController,
              numberFocusNode: _numberFocusNode,
              onSave: _saveNumber,
              onSearch: _openSearch,
              onDeleteAll: () => confirmDeleteAll(),
            ),
          ),

          // Body
          Expanded(
            child: BrochureListBody(
              query: '',
              emptyState: const HomeBrochureEmptyState(),
              noMatchesState: const HomeBrochureEmptyState(subtitle: null),
              onDelete: (entry) => confirmDelete(entry),
            ),
          ),
        ],
      ),
    );
  }
}
