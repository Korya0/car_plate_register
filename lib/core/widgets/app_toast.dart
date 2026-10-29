import 'dart:async';

import 'package:flutter/material.dart';

import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/theme/app_colors.dart';
import 'package:car_register/core/theme/app_text_styles.dart';
import 'package:car_register/core/widgets/app_pressable.dart';

enum AppToastType { info, success, error }

abstract final class AppToast {
  AppToast._();

  static OverlayEntry? _entry;
  static Timer? _timer;

  static void show(
    BuildContext context,
    String message, {
    AppToastType type = AppToastType.info,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _dismiss();

    final overlay = Overlay.of(context, rootOverlay: true);
    final entry = OverlayEntry(
      builder: (context) => PositionedDirectional(
        top: AppSize.p8,
        start: AppSize.p16,
        end: AppSize.p16,
        child: SafeArea(
          child: _AppToastContent(
            message: message,
            actionLabel: actionLabel,
            onAction: onAction,
            borderColor: _colorFor(type),
            onDismiss: _dismiss,
          ),
        ),
      ),
    );
    _entry = entry;
    overlay.insert(entry);
    _timer = Timer(AppConstants.toastDuration2s, _dismiss);
  }

  static void _dismiss() {
    _timer?.cancel();
    _timer = null;
    _entry?.remove();
    _entry?.dispose();
    _entry = null;
  }

  static Color _colorFor(AppToastType type) => switch (type) {
    AppToastType.info => AppColors.borderBrand,
    AppToastType.success => AppColors.borderBrand,
    AppToastType.error => AppColors.primary,
  };
}

class _AppToastContent extends StatelessWidget {
  const _AppToastContent({
    required this.message,
    required this.actionLabel,
    required this.onAction,
    required this.borderColor,
    required this.onDismiss,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color borderColor;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.secondary,
    borderRadius: BorderRadius.circular(AppSize.circularRadius),
    child: Container(
      padding: EdgeInsetsDirectional.fromSTEB(
        AppSize.p20,
        AppSize.p12,
        AppSize.p20,
        AppSize.p12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.circularRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Message
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.font16W500OnSecondary,
            ),
          ),

          // Action
          if (actionLabel != null && onAction != null)
            AppPressable(
              onPressed: () {
                onAction!.call();
                onDismiss();
              },
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: AppConstants.minTapTarget,
                  minHeight: AppConstants.minTapTarget,
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.only(start: AppSize.p16),
                  child: Center(
                    child: Text(
                      actionLabel!,
                      style: AppTextStyles.font16W700OnSecondary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
