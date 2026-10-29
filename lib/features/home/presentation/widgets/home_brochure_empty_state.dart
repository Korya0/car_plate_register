import 'package:flutter/material.dart';

import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/theme/app_text_styles.dart';
import 'package:car_register/core/widgets/app_gap.dart';
import 'package:car_register/core/widgets/app_primary_button.dart';

class HomeBrochureEmptyState extends StatelessWidget {
  const HomeBrochureEmptyState({
    super.key,
    this.onAdd,
    this.title = AppStrings.noBrochuresYet,
    this.subtitle = AppStrings.firstBrochurePrompt,
  });

  final VoidCallback? onAdd;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.all(AppSize.p24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Count
          Text(AppStrings.emptyCount, style: AppTextStyles.font150W800Disabled),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.font24W800Primary,
          ),

          // Subtitle
          if (subtitle case final subtitle?) ...[
            AppGap.h(AppSize.p8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.font16W500Secondary,
            ),
          ],

          // Action
          if (onAdd case final onAdd?) ...[
            AppGap.h(AppSize.p24),
            AppPrimaryButton(
              label: AppStrings.addFirstBrochure,
              onPressed: onAdd,
              expand: true,
            ),
          ],
        ],
      ),
    ),
  );
}
