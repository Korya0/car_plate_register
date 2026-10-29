import 'package:flutter/material.dart';

import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/theme/app_colors.dart';
import 'package:car_register/core/theme/app_text_styles.dart';
import 'package:car_register/core/widgets/app_gap.dart';
import 'package:car_register/core/widgets/app_icon_button.dart';
import 'package:car_register/core/widgets/app_sliver_grid.dart';
import 'package:car_register/core/widgets/app_text_button.dart';
import 'package:car_register/features/home/domain/entities/brochure_entity.dart';
import 'package:car_register/features/home/presentation/widgets/home_brochure_entry_row.dart';

class BrochureListBody extends StatefulWidget {
  const BrochureListBody({
    required this.entries,
    required this.query,
    required this.emptyState,
    required this.noMatchesState,
    required this.onConfirmDelete,
    required this.onConfirmDeleteMany,
    required this.onDelete,
    super.key,
  });

  final List<BrochureEntity> entries;
  final String query;
  final Widget emptyState;
  final Widget noMatchesState;

  /// Asks the user before deleting one brochure; `false` keeps it.
  final Future<bool> Function(BrochureEntity entry) onConfirmDelete;

  /// Asks the user before deleting the selected brochures; `false` keeps them.
  final Future<bool> Function(int count) onConfirmDeleteMany;

  /// Removes the entry after the delete is confirmed.
  final ValueChanged<BrochureEntity> onDelete;

  @override
  State<BrochureListBody> createState() => _BrochureListBodyState();
}

class _BrochureListBodyState extends State<BrochureListBody> {
  static const int _columns = 4;

  final Set<int> _selectedIds = {};

  bool _isSelecting = false;

  List<BrochureEntity> get _visibleEntries => widget.entries
      .where((entry) => entry.number.contains(widget.query))
      .toList();

  // Starts selecting with the long-pressed card.
  void _startSelecting(BrochureEntity entry) => setState(() {
    _isSelecting = true;
    _selectedIds.add(entry.id);
  });

  // Adds or removes one card from the selection.
  void _toggleSelected(BrochureEntity entry) => setState(() {
    if (!_selectedIds.remove(entry.id)) _selectedIds.add(entry.id);
  });

  // Selects every visible card, or clears them when all are selected.
  void _toggleAll(List<BrochureEntity> visibleEntries) => setState(() {
    if (_selectedIds.length == visibleEntries.length) {
      _selectedIds.clear();
    } else {
      _selectedIds.addAll(visibleEntries.map((entry) => entry.id));
    }
  });

  void _stopSelecting() => setState(() {
    _isSelecting = false;
    _selectedIds.clear();
  });

  // Asks for confirmation, then removes one brochure.
  Future<void> _confirmThenDelete(BrochureEntity entry) async {
    if (await widget.onConfirmDelete(entry)) widget.onDelete(entry);
  }

  // Asks for confirmation, then removes every selected brochure.
  Future<void> _confirmThenDeleteSelected() async {
    final selected = _visibleEntries
        .where((entry) => _selectedIds.contains(entry.id))
        .toList();
    if (selected.isEmpty) return;
    if (!await widget.onConfirmDeleteMany(selected.length)) return;

    for (final entry in selected) {
      widget.onDelete(entry);
    }
    if (mounted) _stopSelecting();
  }

  @override
  Widget build(BuildContext context) {
    final visibleEntries = _visibleEntries;

    return CustomScrollView(
      slivers: [
        // ------------------------------------------------------------------
        // Loading branch — copy back when Riverpod returns (with a loading
        // flag or an AsyncValue). Needs the app_constants.dart import.
        //
        // AppSliverGrid.count(
        //   padding: EdgeInsetsDirectional.only(
        //     start: AppSize.p20,
        //     end: AppSize.p20,
        //     top: AppSize.p12,
        //   ),
        //   crossAxisCount: _columns,
        //   mainAxisSpacing: AppSize.p8,
        //   crossAxisSpacing: AppSize.p8,
        //   itemCount: AppConstants.brochureListSkeletonCount,
        //   itemBuilder: (context, index) =>
        //       const HomeBrochureEntryRow.loading(),
        // )
        //
        // Error branch — copy back when Riverpod returns
        // (ref.invalidate(provider) instead of the empty callback).
        // Needs app_error_view.dart and app_strings.dart imports.
        //
        // SliverFillRemaining(
        //   hasScrollBody: false,
        //   child: AppErrorView(
        //     message: AppStrings.errorWidgetTitle,
        //     onRetry: () {},
        //   ),
        // )
        // ------------------------------------------------------------------

        // Empty
        if (widget.entries.isEmpty)
          SliverFillRemaining(hasScrollBody: false, child: widget.emptyState)
        // No matches
        else if (visibleEntries.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: widget.noMatchesState,
          )
        else ...[
          // Selection bar
          if (_isSelecting)
            SliverToBoxAdapter(
              child: _SelectionBar(
                selectedCount: _selectedIds.length,
                allSelected: _selectedIds.length == visibleEntries.length,
                onToggleAll: () => _toggleAll(visibleEntries),
                onDelete: _confirmThenDeleteSelected,
                onExit: _stopSelecting,
              ),
            ),

          // Cards
          AppSliverGrid.count(
            padding: EdgeInsetsDirectional.only(
              start: AppSize.p20,
              end: AppSize.p20,
              top: AppSize.p12,
            ),
            crossAxisCount: _columns,
            mainAxisSpacing: AppSize.p8,
            crossAxisSpacing: AppSize.p8,
            itemCount: visibleEntries.length,
            itemBuilder: (context, index) {
              final entry = visibleEntries[index];
              return HomeBrochureEntryRow(
                brochure: entry,
                query: widget.query,
                isSelecting: _isSelecting,
                isSelected: _selectedIds.contains(entry.id),
                onPressed: () => _isSelecting
                    ? _toggleSelected(entry)
                    : _confirmThenDelete(entry),
                onLongPress: _isSelecting
                    ? () => _toggleSelected(entry)
                    : () => _startSelecting(entry),
              );
            },
          ),
          SliverToBoxAdapter(child: AppGap.h(AppSize.sbp)),
        ],
      ],
    );
  }
}

class _SelectionBar extends StatelessWidget {
  const _SelectionBar({
    required this.selectedCount,
    required this.allSelected,
    required this.onToggleAll,
    required this.onDelete,
    required this.onExit,
  });

  final int selectedCount;
  final bool allSelected;
  final VoidCallback onToggleAll;
  final VoidCallback onDelete;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsetsDirectional.only(
      start: AppSize.p20,
      end: AppSize.p20,
      top: AppSize.p8,
    ),
    child: Row(
      children: [
        // Exit
        AppIconButton(
          icon: Icons.close,
          tooltip: AppStrings.cancel,
          color: AppColors.iconSecondary,
          onPressed: onExit,
        ),

        // Count
        Expanded(
          child: Text(
            AppStrings.selectedCount(selectedCount),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font14W500Primary,
          ),
        ),

        // Select all / clear all
        Flexible(
          child: AppTextButton(
            label: allSelected
                ? AppStrings.clearAllSelection
                : AppStrings.selectAll,
            onPressed: onToggleAll,
          ),
        ),

        // Delete selected
        AppIconButton(
          icon: Icons.delete_outline_rounded,
          tooltip: AppStrings.deleteSelected,
          onPressed: selectedCount == 0 ? null : onDelete,
        ),
      ],
    ),
  );
}
