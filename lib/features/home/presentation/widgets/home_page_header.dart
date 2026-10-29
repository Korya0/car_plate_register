import 'package:flutter/material.dart';

import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/theme/app_colors.dart';
import 'package:car_register/core/theme/app_text_styles.dart';
import 'package:car_register/features/home/presentation/widgets/home_page_header_curve.dart';

class HomePageHeader extends StatelessWidget {
  const HomePageHeader({
    required this.watermarkText,
    super.key,
    this.child,
    this.fillWatermarkHeight = false,
  });

  final String watermarkText;
  final Widget? child;
  final bool fillWatermarkHeight;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadiusDirectional.only(
      bottomStart: Radius.circular(AppSize.r20),
      bottomEnd: Radius.circular(AppSize.r20),
    );
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: AppColors.secondary),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            // Watermark
            Positioned.fill(
              child: FittedBox(
                fit: fillWatermarkHeight ? BoxFit.fitHeight : BoxFit.scaleDown,
                child: Text(
                  watermarkText,
                  maxLines: AppConstants.maxOneLine,
                  style: AppTextStyles.font150W800Watermark,
                ),
              ),
            ),

            // Curve
            const Positioned.fill(child: HomePageHeaderCurve()),

            // Content
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                AppSize.p24,
                AppSize.p24,
                AppSize.p24,
                AppSize.p32,
              ),
              child: child ?? SizedBox(height: AppSize.h150),
            ),
          ],
        ),
      ),
    );
  }
}
