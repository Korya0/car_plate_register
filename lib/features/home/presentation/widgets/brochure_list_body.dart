import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/widgets/app_error_view.dart';
import 'package:car_register/core/widgets/app_gap.dart';
import 'package:car_register/core/widgets/app_sliver_list.dart';
import 'package:car_register/features/home/domain/entities/brochure_entity.dart';
import 'package:car_register/features/home/presentation/providers/brochure_list_provider.dart';
import 'package:car_register/features/home/presentation/widgets/home_brochure_entry_row.dart';

class BrochureListBody extends ConsumerWidget {
  const BrochureListBody({
    required this.query,
    required this.emptyState,
    required this.noMatchesState,
    required this.onDelete,
    super.key,
  });

  final String query;
  final Widget emptyState;
  final Widget noMatchesState;
  final ValueChanged<BrochureEntity> onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brochureState = ref.watch(brochureListProvider);
    final entries = brochureState.value;
    final visibleEntries =
        entries?.where((entry) => entry.number.contains(query)).toList() ?? [];

    return CustomScrollView(
      slivers: [
        // Loading
        if (brochureState.isLoading)
          AppSliverList(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: AppSize.p20,
            ),
            itemCount: AppConstants.brochureListSkeletonCount,
            itemBuilder: (context, index) =>
                const HomeBrochureEntryRow.loading(),
          )
        // Error
        else if (brochureState.hasError)
          SliverFillRemaining(
            hasScrollBody: false,
            child: AppErrorView(
              message: AppStrings.errorWidgetTitle,
              onRetry: () => ref.invalidate(brochureListProvider),
            ),
          )
        // Empty
        else if (entries == null || entries.isEmpty)
          SliverFillRemaining(hasScrollBody: false, child: emptyState)
        // No matches
        else if (visibleEntries.isEmpty)
          SliverFillRemaining(hasScrollBody: false, child: noMatchesState)
        else ...[
          // List
          AppSliverList(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: AppSize.p20,
            ),
            itemCount: visibleEntries.length,
            itemBuilder: (context, index) {
              final entry = visibleEntries[index];
              return HomeBrochureEntryRow(
                brochure: entry,
                query: query,
                onDelete: () => onDelete(entry),
              );
            },
          ),
          SliverToBoxAdapter(child: AppGap.h(AppSize.sbp)),
        ],
      ],
    );
  }
}
