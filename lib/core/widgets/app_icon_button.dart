import 'package:flutter/material.dart';

import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/theme/app_colors.dart';
import 'package:car_register/core/widgets/app_pressable.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.tooltip,
    this.onLongPress,
    this.color,
    this.size,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final String? tooltip;
  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final target = AppSize.w48 < AppConstants.minTapTarget
        ? AppConstants.minTapTarget
        : AppSize.w48;

    final button = AppPressable(
      onPressed: onPressed,
      onLongPress: onLongPress,
      semanticLabel: tooltip,
      disabledOpacity: AppConstants.opacityDisabled,
      child: SizedBox(
        width: target,
        height: target,
        child: Center(
          child: Icon(
            icon,
            size: size ?? AppSize.icon24,
            color: color ?? AppColors.iconPrimary,
          ),
        ),
      ),
    );

    if (tooltip == null) return button;

    return Tooltip(
      message: tooltip!,
      // AppPressable already carries the label; without this the reader can
      // announce the same string twice (label + tooltip).
      excludeFromSemantics: true,
      child: button,
    );
  }
}
