import 'package:flutter/material.dart';

import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/theme/app_colors.dart';
import 'package:car_register/core/theme/app_text_styles.dart';
import 'package:car_register/core/widgets/app_gap.dart';
import 'package:car_register/core/widgets/app_primary_button.dart';
import 'package:car_register/core/widgets/app_secondary_button.dart';

class CustomConfirmationDialog {
  const CustomConfirmationDialog._();

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmText,
    required String cancelText,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.secondaryScaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.r16),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: AppSize.p24),
        child: Padding(
          padding: EdgeInsets.all(AppSize.p16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font20W700Primary,
                ),
                AppGap.h(AppSize.p16),

                // Message
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font16W500Primary,
                ),
                AppGap.h(AppSize.p24),

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: AppSecondaryButton(
                        label: cancelText,
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                    ),
                    AppGap.w(AppSize.p12),
                    Expanded(
                      child: AppPrimaryButton(
                        label: confirmText,
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
