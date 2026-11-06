import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/di/app_providers.dart';
import 'package:car_register/core/router/app_routes.dart';
import 'package:car_register/core/widgets/custom_confirmation_dialog.dart';
import 'package:car_register/features/home/domain/entities/brochure_entity.dart';
import 'package:car_register/features/home/presentation/providers/home_notifier.dart';
import 'package:car_register/features/home/presentation/widgets/brochure_list_body.dart';
import 'package:car_register/features/home/presentation/widgets/home/home_header_content.dart';
import 'package:car_register/features/home/presentation/widgets/home_brochure_empty_state.dart';
import 'package:car_register/features/home/presentation/widgets/home_page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final TextEditingController _numberController = TextEditingController();
  final FocusNode _numberFocusNode = FocusNode();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _numberController.addListener(_handleChanged);
  }

  @override
  void dispose() {
    _numberController
      ..removeListener(_handleChanged)
      ..dispose();
    _numberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(homeNotifierProvider, (previous, next) async {
      if (next.error == null || next.error == previous?.error) return;
      await _showErrorDialog(next.error!);
      ref.read(homeNotifierProvider.notifier).clearError();
    });

    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _loadBrochures();
      });
    }

    final state = ref.watch(homeNotifierProvider);

    if (state.accessCodeInvalid && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(accessCodeProvider.notifier).clear();
        context.go(AppRoutes.accessCode);
      });
    }

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
              onSearch: () {
                _dismissKeyboard();
                context.push(AppRoutes.search);
              },
            ),
          ),

          Expanded(
            child: BrochureListBody(
              entries: state.brochures,
              query: '',
              loadingIds: state.loadingIds,
              isLoading: state.isLoading,
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

  void _handleChanged() {
    ref.read(homeNotifierProvider.notifier).clearError();
  }

  Future<void> _loadBrochures() async {
    final accessCode = ref.read(accessCodeProvider);
    if (accessCode.isEmpty) return;
    await ref
        .read(homeNotifierProvider.notifier)
        .loadBrochures(
          accessCode: accessCode,
        );
  }

  void _dismissKeyboard() => _numberFocusNode.unfocus();

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

  void _saveNumber() {
    final number = _numberController.text.trim();
    if (number.isEmpty) return;
    if (ref.read(accessCodeProvider).isEmpty) return;
    ref
        .read(homeNotifierProvider.notifier)
        .addBrochure(
          accessCode: ref.read(accessCodeProvider),
          number: number,
        );
    _numberController.clear();
  }

  void _deleteEntry(BrochureEntity entry) {
    final accessCode = ref.read(accessCodeProvider);
    if (accessCode.isEmpty) return;
    ref
        .read(homeNotifierProvider.notifier)
        .deleteBrochure(
          accessCode: accessCode,
          id: entry.id,
        );
  }
}
