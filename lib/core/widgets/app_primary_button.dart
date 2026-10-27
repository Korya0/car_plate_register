import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/theme/app_colors.dart';
import 'package:car_register/core/theme/app_text_styles.dart';
import 'package:car_register/core/widgets/app_pressable.dart';
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.expand = false,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool expand;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final height = AppSize.h48 < AppConstants.minTapTarget
        ? AppConstants.minTapTarget
        : AppSize.h48;
    final canPress = onPressed != null && !isLoading;

    return Opacity(
      opacity: onPressed == null
          ? AppConstants.opacityDisabled
          : AppConstants.opacityFull,
      // Buttons fade as one control: fill and label dim together.
      child: AppPressable(
        onPressed: canPress ? onPressed : null,
        child: Container(
          width: expand ? double.infinity : null,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.actionPrimary,
            borderRadius: BorderRadius.circular(AppSize.r16),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.p16),
            child: Center(
              child: isLoading
                  ? CupertinoActivityIndicator(
                      radius: AppSize.icon24 / 2,
                      color: AppColors.textOnPrimary,
                    )
                  : Text(
                      label,
                      maxLines: AppConstants.maxOneLine,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.font14W700OnPrimary,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
