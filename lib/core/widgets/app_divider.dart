import 'package:flutter/material.dart';

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
       _isVertical = false;

  const AppDivider.vertical({
    super.key,
    this.color,
    this.thickness,
    this.width,
    this.indent,
    this.endIndent,
  }) : height = null,
       _isVertical = true;

  final Color? color;
  final double? thickness;
  final double? width;
  final double? height;
  final double? indent;
  final double? endIndent;

  final bool _isVertical;

  @override
  Widget build(BuildContext context) {
    final dividerColor = color ?? AppColors.dividerColor;
    final dividerThickness = thickness ?? AppSize.dividerThickness;

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
