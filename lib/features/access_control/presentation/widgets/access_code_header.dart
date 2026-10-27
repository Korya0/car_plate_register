import 'package:car_register/core/constants/app_assets.dart';
import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/theme/app_text_styles.dart';
import 'package:car_register/core/widgets/app_divider.dart';
import 'package:car_register/core/widgets/app_gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AccessCodeHeader extends StatelessWidget {
  const AccessCodeHeader({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Logo
      LayoutBuilder(
        builder: (context, constraints) {
          final logoWidth = AppSize.w100;
          final travel = constraints.maxWidth - logoWidth;
          final begin =
              (Directionality.of(context) == TextDirection.rtl
                  ? -travel
                  : travel) /
              logoWidth;

          return SizedBox(
            width: double.infinity,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Image.asset(AppAssets.logo, width: logoWidth)
                  .animate()
                  .slideX(
                    begin: begin,
                    end: 0,
                    delay: AppConstants.accessCodeLogoDelay500ms,
                    duration: AppConstants.accessCodeLogoSlide700ms,
                    curve: Curves.easeOutCubic,
                  ),
            ),
          );
        },
      ),

      AppGap.h(AppSize.p16),

      // Divider
      AppDivider.brand(
        width: AppSize.w48,
        animateFill: true,
        fillDelay: AppConstants.accessCodeDividerFillDelay500ms,
        fillDuration: AppConstants.accessCodeDividerFill700ms,
      ).animate().slideX(
        begin: 0.15,
        end: 0,
        duration: AppConstants.animationFast200ms,
        delay: AppConstants.accessCodeStagger60ms,
        curve: Curves.easeOut,
      ),

      AppGap.h(AppSize.p24),

      // Title
      Text(
        AppStrings.accessCodeTitle,
        style: AppTextStyles.font30W800Primary,
      ).animate().slideX(
        begin: 0.15,
        end: 0,
        duration: AppConstants.animationFast200ms,
        delay: AppConstants.accessCodeStagger60ms * 2,
        curve: Curves.easeOut,
      ),

      AppGap.h(AppSize.p8),

      // Subtitle
      Text(
        AppStrings.accessCodeSubtitle,
        style: AppTextStyles.font15W400Secondary,
      ).animate().slideX(
        begin: 0.15,
        end: 0,
        duration: AppConstants.animationFast200ms,
        delay: AppConstants.accessCodeStagger60ms * 3,
        curve: Curves.easeOut,
      ),
    ],
  );
}
