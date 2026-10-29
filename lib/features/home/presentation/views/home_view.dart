import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/router/app_routes.dart';
import 'package:car_register/core/utils/app_validators.dart';
import 'package:car_register/core/widgets/custom_confirmation_dialog.dart';
import 'package:car_register/features/home/domain/entities/brochure_entity.dart';
import 'package:car_register/features/home/presentation/mock/brochure_mock_store.dart';
import 'package:car_register/features/home/presentation/widgets/brochure_list_body.dart';
import 'package:car_register/features/home/presentation/widgets/home/home_header_content.dart';
import 'package:car_register/features/home/presentation/widgets/home_brochure_empty_state.dart';
import 'package:car_register/features/home/presentation/widgets/home_page_header.dart';
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
  bool _isSaving = false;

  @override
  void dispose() {
    _numberController.dispose();
    _numberFocusNode.dispose();
    super.dispose();
  }

  void _dismissKeyboard() => _numberFocusNode.unfocus();

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

  // Validates and adds a number.
  Future<void> _saveNumber() async {
    if (_isSaving) return;

    final number = _numberController.text.trim();
    final validationMessage = AppValidators.brochureNumber(number);
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

    final exists = BrochureMockStore.entries.any(
      (entry) => entry.number == number,
    );
    if (exists) {
      await _showDuplicateDialog();
      return;
    }

    setState(() => _isSaving = true);
    await Future<void>.delayed(AppConstants.animationFast200ms);
    if (!mounted) return;

    final added = BrochureMockStore.add(number);
    if (added == null) {
      setState(() => _isSaving = false);
      await _showDuplicateDialog();
      return;
    }

    _numberController.clear();
    setState(() => _isSaving = false);
  }

  // Shows duplicate warning.
  Future<void> _showDuplicateDialog() async {
    _dismissKeyboard();
    await CustomConfirmationDialog.show(
      context: context,
      title: AppStrings.brochureDuplicateTitle,
      message: AppStrings.brochureDuplicateMessage,
      confirmText: AppStrings.okay,
      cancelText: AppStrings.cancel,
    );
  }

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
              onSearch: () async {
                _dismissKeyboard();
                await context.push(AppRoutes.search);
                if (mounted) setState(() {});
              },
            ),
          ),

          // Body
          Expanded(
            child: BrochureListBody(
              entries: BrochureMockStore.entries,
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
  }
}
