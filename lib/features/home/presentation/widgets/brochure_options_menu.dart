import 'package:flutter/material.dart';

import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/theme/app_colors.dart';
import 'package:car_register/core/theme/app_text_styles.dart';

class BrochureOptionsMenu extends StatelessWidget {
  const BrochureOptionsMenu({required this.onDeleteAll, super.key});

  final VoidCallback onDeleteAll;

  @override
  Widget build(BuildContext context) => PopupMenuButton<String>(
    tooltip: AppStrings.moreOptions,
    position: PopupMenuPosition.under,
    onSelected: (value) {
      if (value == AppStrings.deleteAll) onDeleteAll();
    },
    itemBuilder: (context) => [
      PopupMenuItem(
        value: AppStrings.deleteAll,
        child: Text(
          AppStrings.deleteAll,
          style: AppTextStyles.font14W700Brand,
        ),
      ),
    ],
    child: SizedBox(
      width: AppSize.w48 < AppConstants.minTapTarget
          ? AppConstants.minTapTarget
          : AppSize.w48,
      height: AppSize.h48 < AppConstants.minTapTarget
          ? AppConstants.minTapTarget
          : AppSize.h48,
      child: Icon(
        Icons.more_vert,
        color: AppColors.textOnSecondary,
        size: AppSize.icon24,
      ),
    ),
  );
}
