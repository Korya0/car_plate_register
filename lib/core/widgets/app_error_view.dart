import 'package:flutter/material.dart';

import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/theme/app_colors.dart';
import 'package:car_register/core/theme/app_text_styles.dart';
import 'package:car_register/core/widgets/app_gap.dart';
import 'package:car_register/core/widgets/app_primary_button.dart';

class AppErrorView extends StatelessWidget {
  const AppErrorView({
    required this.message,
    super.key,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.all(AppSize.p24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Icon(
            Icons.error_outline,
            size: AppSize.icon48,
            color: AppColors.primary,
          ),
          AppGap.h(AppSize.p16),

          // Title
          Text(
            AppStrings.errorWidgetTitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.font16W700Primary,
          ),
          AppGap.h(AppSize.p8),

          // Message
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.font14W500Secondary,
          ),
          if (onRetry != null) ...[
            AppGap.h(AppSize.p24),
            AppPrimaryButton(label: AppStrings.tryAgain, onPressed: onRetry),
          ],
        ],
      ),
    ),
  );
}
