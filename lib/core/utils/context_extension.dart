import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/theme/app_colors.dart';

enum AppSizeClass { compact, medium, expanded, large }

extension ContextExtension on BuildContext {
  // System UI
  Widget systemUiOverlay(Widget child) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: const SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.transparent,
      systemNavigationBarContrastEnforced: false,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
    child: child,
  );

  // Focus
  void unfocus() => FocusScope.of(this).unfocus();

  // Motion
  bool get reduceMotion => MediaQuery.maybeDisableAnimationsOf(this) ?? false;

  // Text scaling
  Widget preventTextScaling(Widget child) => MediaQuery(
    data: MediaQuery.of(this).copyWith(textScaler: const TextScaler.linear(1)),
    child: child,
  );

  // Breakpoints
  AppSizeClass get sizeClass {
    final width = MediaQuery.sizeOf(this).width;
    if (width < AppSize.bpMobile) return AppSizeClass.compact;
    if (width < AppSize.bpTablet) return AppSizeClass.medium;
    if (width < AppSize.bpDesktop) return AppSizeClass.expanded;
    return AppSizeClass.large;
  }

  bool get isLandscape =>
      MediaQuery.orientationOf(this) == Orientation.landscape;

  bool get isRtl => Directionality.of(this) == TextDirection.rtl;

  Locale get locale => Localizations.localeOf(this);

  bool get isArabic => locale.languageCode == 'ar';
}
