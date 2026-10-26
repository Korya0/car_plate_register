import 'package:flutter/material.dart';

import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/theme/app_colors.dart';
import 'package:car_register/core/theme/app_text_styles.dart';
import 'package:car_register/core/widgets/app_gap.dart';

class AppEmptyView extends StatelessWidget {
  const AppEmptyView({
    super.key,
    this.title = AppStrings.emptyTitle,
    this.message,
  });

  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.all(AppSize.p24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Icon(
            Icons.inbox_outlined,
            size: AppSize.icon48,
            color: AppColors.iconSecondary,
          ),
          AppGap.h(AppSize.p16),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.font16W700Primary,
          ),
          if (message != null) ...[
            AppGap.h(AppSize.p8),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: AppTextStyles.font14W500Secondary,
            ),
          ],
        ],
      ),
    ),
  );
}
