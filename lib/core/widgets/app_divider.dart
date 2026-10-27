import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/theme/app_colors.dart';
import 'package:car_register/core/theme/app_text_styles.dart';
import 'package:car_register/core/widgets/app_gap.dart';

class AppDivider extends StatelessWidget {
  const AppDivider.horizontal({
    super.key,
    this.color,
    this.thickness,
    this.height,
    this.indent,
    this.endIndent,
  }) : width = null,
       baseColor = null,
       animateFill = false,
       fillDelay = Duration.zero,
       fillDuration = const Duration(milliseconds: 700),
       _isVertical = false,
       _isBrand = false;

  const AppDivider.vertical({
    super.key,
    this.color,
    this.thickness,
    this.width,
    this.indent,
    this.endIndent,
  }) : height = null,
       baseColor = null,
       animateFill = false,
       fillDelay = Duration.zero,
       fillDuration = const Duration(milliseconds: 700),
       _isVertical = true,
       _isBrand = false;

  const AppDivider.brand({
    super.key,
    this.width,
    this.thickness,
    this.color,
    this.baseColor,
    this.animateFill = false,
    this.fillDelay = Duration.zero,
    this.fillDuration = const Duration(milliseconds: 700),
  }) : height = null,
       indent = null,
       endIndent = null,
       _isVertical = false,
       _isBrand = true;

  final Color? color;
  final Color? baseColor;
  final double? thickness;
  final double? width;
  final double? height;
  final double? indent;
  final double? endIndent;
  final bool animateFill;
  final Duration fillDelay;
  final Duration fillDuration;

  final bool _isVertical;
  final bool _isBrand;

  @override
  Widget build(BuildContext context) {
    final dividerColor = color ?? AppColors.dividerColor;
    final dividerThickness = thickness ?? AppSize.dividerThickness;

    if (_isBrand) {
      final brandWidth = width ?? AppSize.w48;
      final brandHeight = thickness ?? AppSize.p4;
      final borderRadius = BorderRadius.circular(AppSize.circularRadius);
      final finalColor = color ?? AppColors.borderBrand;
      final startColor = baseColor ?? AppColors.dividerColor;

      if (!animateFill) {
        return Container(
          width: brandWidth,
          height: brandHeight,
          decoration: BoxDecoration(
            color: finalColor,
            borderRadius: borderRadius,
          ),
        );
      }

      return SizedBox(
        width: brandWidth,
        height: brandHeight,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(color: startColor),
              ColoredBox(color: finalColor).animate().custom(
                delay: fillDelay,
                duration: fillDuration,
                curve: Curves.easeOutCubic,
                begin: 0,
                end: 1,
                builder: (context, value, child) => FractionallySizedBox(
                  alignment: AlignmentDirectional.centerStart,
                  widthFactor: value,
                  heightFactor: 1,
                  child: child,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_isVertical) {
      return VerticalDivider(
        color: dividerColor,
        thickness: dividerThickness,
        width: width,
        indent: indent,
        endIndent: endIndent,
      );
    }

    return Divider(
      color: dividerColor,
      thickness: dividerThickness,
      height: height ?? AppSize.dividerHeight,
      indent: indent,
      endIndent: endIndent,
    );
  }
}

class AppTextDivider extends StatelessWidget {
  const AppTextDivider({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Expanded(child: AppDivider.horizontal()),
      AppGap.w(AppSize.p12),

      // Center label
      Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.font14W500Secondary,
      ),

      AppGap.w(AppSize.p12),
      const Expanded(child: AppDivider.horizontal()),
    ],
  );
}
