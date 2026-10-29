import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/widgets/app_toast.dart';
import 'package:car_register/core/widgets/custom_confirmation_dialog.dart';
import 'package:car_register/features/home/domain/entities/brochure_entity.dart';
import 'package:car_register/features/home/presentation/providers/brochure_list_provider.dart';

mixin BrochureActions<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  void dismissKeyboard();

  // Confirms and deletes one entry.
  Future<void> confirmDelete(BrochureEntity entry) async {
    dismissKeyboard();
    final confirmed = await CustomConfirmationDialog.show(
      context: context,
      title: AppStrings.deleteBrochureTitle,
      message: AppStrings.deleteBrochureMessage(entry.number),
      confirmText: AppStrings.delete,
      cancelText: AppStrings.cancel,
    );
    if (!mounted || confirmed != true) return;

    final deleted = ref.read(brochureListProvider.notifier).delete(entry.id);
    if (deleted == null) return;

    _showUndoToast(AppStrings.deletedMessage(deleted.number));
  }

  // Confirms and deletes all entries.
  Future<void> confirmDeleteAll() async {
    dismissKeyboard();
    final entries = ref.read(brochureListProvider).value;
    if (entries == null || entries.isEmpty) return;

    final confirmed = await CustomConfirmationDialog.show(
      context: context,
      title: AppStrings.deleteAllTitle,
      message: AppStrings.deleteAllMessage,
      confirmText: AppStrings.delete,
      cancelText: AppStrings.cancel,
    );
    if (!mounted || confirmed != true) return;

    final deleted = ref.read(brochureListProvider.notifier).deleteAll();
    if (deleted.isEmpty) return;

    _showUndoToast(AppStrings.allDeletedMessage);
  }

  // Shows undo toast.
  void _showUndoToast(String message) {
    AppToast.show(
      context,
      message,
      type: AppToastType.success,
      actionLabel: AppStrings.undo,
      onAction: () => ref.read(brochureListProvider.notifier).undoDelete(),
    );
  }
}
