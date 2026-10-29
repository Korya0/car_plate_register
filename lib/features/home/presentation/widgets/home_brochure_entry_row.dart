import 'package:flutter/material.dart';

import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/theme/app_colors.dart';
import 'package:car_register/core/theme/app_text_styles.dart';
import 'package:car_register/core/widgets/app_divider.dart';
import 'package:car_register/core/widgets/app_gap.dart';
import 'package:car_register/core/widgets/app_icon_button.dart';
import 'package:car_register/features/home/domain/entities/brochure_entity.dart';

class HomeBrochureEntryRow extends StatelessWidget {
  const HomeBrochureEntryRow({
    required BrochureEntity brochure,
    required String query,
    required VoidCallback onDelete,
    Key? key,
  }) : this._(
         brochure: brochure,
         query: query,
         onDelete: onDelete,
         isLoading: false,
         key: key,
       );

  const HomeBrochureEntryRow.loading({Key? key})
    : this._(
        brochure: null,
        query: '',
        onDelete: null,
        isLoading: true,
        key: key,
      );

  const HomeBrochureEntryRow._({
    required this.brochure,
    required this.query,
    required this.onDelete,
    required this.isLoading,
    super.key,
  });

  final BrochureEntity? brochure;
  final String query;
  final VoidCallback? onDelete;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final entry = brochure;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.p12),
      child: Column(
        children: [
          Row(
            children: [
              // Info (number + time)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Number
                    if (isLoading)
                      _HomeBrochureRowPlaceholder(
                        text: List<String>.filled(
                          AppConstants.brochureNumberMaxLength,
                          '0',
                        ).join(),
                        style: AppTextStyles.font34W800Primary,
                      )
                    else
                      Text.rich(
                        _highlightedNumber(entry!),
                        maxLines: AppConstants.maxOneLine,
                        overflow: TextOverflow.ellipsis,
                      ),
                    AppGap.h(AppSize.p4),

                    // Added time
                    if (isLoading)
                      _HomeBrochureRowPlaceholder(
                        text: AppStrings.addedAt(AppStrings.placeholderTime),
                        style: AppTextStyles.font12W500Secondary,
                      )
                    else
                      Text(
                        AppStrings.addedAt(_formatTime(entry!.createdAt)),
                        style: AppTextStyles.font12W500Secondary,
                      ),
                  ],
                ),
              ),

              // Delete
              if (isLoading)
                SizedBox(
                  width: AppSize.w48 < AppConstants.minTapTarget
                      ? AppConstants.minTapTarget
                      : AppSize.w48,
                  height: AppSize.w48 < AppConstants.minTapTarget
                      ? AppConstants.minTapTarget
                      : AppSize.w48,
                  child: Center(
                    child: Container(
                      width: AppSize.icon24,
                      height: AppSize.icon24,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDisabled,
                        borderRadius: BorderRadius.circular(AppSize.r8),
                      ),
                    ),
                  ),
                )
              else
                AppIconButton(
                  icon: Icons.delete_outline_rounded,
                  tooltip: AppStrings.deleteBrochure,
                  color: AppColors.iconSecondary,
                  onPressed: onDelete,
                ),
            ],
          ),
          AppGap.h(AppSize.p8),

          // Divider
          const Align(
            alignment: AlignmentDirectional.centerStart,
            child: AppDivider.horizontal(),
          ),
        ],
      ),
    );
  }

  // Highlights matching digits.
  TextSpan _highlightedNumber(BrochureEntity brochure) {
    final baseStyle = AppTextStyles.font34W800Primary;
    if (query.isEmpty) return TextSpan(text: brochure.number, style: baseStyle);

    final matchIndex = brochure.number.indexOf(query);
    if (matchIndex < 0) {
      return TextSpan(text: brochure.number, style: baseStyle);
    }

    final matchEnd = matchIndex + query.length;
    return TextSpan(
      children: [
        if (matchIndex > 0)
          TextSpan(
            text: brochure.number.substring(0, matchIndex),
            style: baseStyle,
          ),
        TextSpan(
          text: brochure.number.substring(matchIndex, matchEnd),
          style: AppTextStyles.font34W800Brand,
        ),
        if (matchEnd < brochure.number.length)
          TextSpan(
            text: brochure.number.substring(matchEnd),
            style: baseStyle,
          ),
      ],
    );
  }

  // Formats added time.
  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return AppStrings.time(hour, minute);
  }
}

class _HomeBrochureRowPlaceholder extends StatelessWidget {
  const _HomeBrochureRowPlaceholder({
    required this.text,
    required this.style,
  });

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: Directionality.of(context),
      maxLines: AppConstants.maxOneLine,
    )..layout();

    return Container(
      width: textPainter.width,
      height: textPainter.height,
      decoration: BoxDecoration(
        color: AppColors.surfaceDisabled,
        borderRadius: BorderRadius.circular(AppSize.r8),
      ),
    );
  }
}
