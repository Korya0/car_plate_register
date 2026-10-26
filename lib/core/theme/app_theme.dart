import 'package:flutter/material.dart';

import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/theme/app_colors.dart';

abstract final class AppTheme {
  AppTheme._();

  static ThemeData get theme {
    const ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      primaryContainer: AppColors.surfaceBrand,
      onPrimaryContainer: AppColors.textOnPrimary,
      secondary: AppColors.secondary,
      onSecondary: AppColors.textOnSecondary,
      secondaryContainer: AppColors.surfaceBrandSecondary,
      onSecondaryContainer: AppColors.textOnSecondary,
      error: AppColors.primary,
      onError: AppColors.textOnPrimary,
      errorContainer: AppColors.surfaceBrand,
      onErrorContainer: AppColors.textOnPrimary,
      surface: AppColors.secondaryScaffoldBackgroundColor,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.dividerColor,
      outlineVariant: AppColors.dividerColor,
      inverseSurface: AppColors.textPrimary,
      onInverseSurface: AppColors.scaffoldBackgroundColor,
      inversePrimary: AppColors.textBrand,
      surfaceTint: AppColors.primary,
      shadow: AppColors.black,
      scrim: AppColors.black,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
      dividerColor: AppColors.dividerColor,
      splashFactory: NoSplash.splashFactory,
      splashColor: AppColors.transparent,
      highlightColor: AppColors.transparent,
      hoverColor: AppColors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        foregroundColor: AppColors.textPrimary,
        elevation: AppConstants.elevationNone,
        centerTitle: true,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.secondaryScaffoldBackgroundColor,
        surfaceTintColor: AppColors.transparent,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.secondaryScaffoldBackgroundColor,
        surfaceTintColor: AppColors.transparent,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.secondaryScaffoldBackgroundColor,
        contentTextStyle: TextStyle(color: AppColors.textPrimary),
        behavior: SnackBarBehavior.floating,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
      ),
    );
  }
}
