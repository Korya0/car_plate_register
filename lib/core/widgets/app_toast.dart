import 'package:flutter/material.dart';

import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/theme/app_colors.dart';
import 'package:car_register/core/theme/app_text_styles.dart';

enum AppToastType { info, success, error }

abstract final class AppToast {
  AppToast._();

  static void show(
    BuildContext context,
    String message, {
    AppToastType type = AppToastType.info,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyles.font14W700Primary,
        ),
        backgroundColor: AppColors.secondaryScaffoldBackgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: AppConstants.toastDuration2s,
        margin: EdgeInsets.all(AppSize.p16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.r16),
          side: BorderSide(
            color: _colorFor(type),
            width: AppSize.borderWidth,
          ),
        ),
      ),
    );
  }

  static Color _colorFor(AppToastType type) => switch (type) {
    AppToastType.info => AppColors.secondary,
    AppToastType.success => AppColors.secondary,
    AppToastType.error => AppColors.primary,
  };
}
