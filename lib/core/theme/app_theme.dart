import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/theme/app_colors.dart';

abstract final class AppTheme {
  AppTheme._();

  static ThemeData get theme {
    const ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.light,
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
      errorContainer: AppColors.surfaceSelected,
      onErrorContainer: AppColors.textBrand,
      surface: AppColors.scaffoldBackgroundColor,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      surfaceContainerHighest: AppColors.secondaryScaffoldBackgroundColor,
      outline: AppColors.dividerColor,
      outlineVariant: AppColors.dividerColor,
      inverseSurface: AppColors.secondary,
      onInverseSurface: AppColors.textOnSecondary,
      inversePrimary: AppColors.textBrand,
      surfaceTint: AppColors.transparent,
      shadow: AppColors.black,
      scrim: AppColors.black,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
      dividerColor: AppColors.dividerColor,
      splashFactory: NoSplash.splashFactory,
      splashColor: AppColors.transparent,
      highlightColor: AppColors.transparent,
      hoverColor: AppColors.transparent,
      cardTheme: const CardThemeData(
        color: AppColors.secondaryScaffoldBackgroundColor,
        surfaceTintColor: AppColors.transparent,
        elevation: AppConstants.elevationNone,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: AppColors.transparent,
        elevation: AppConstants.elevationNone,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        surfaceTintColor: AppColors.transparent,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        surfaceTintColor: AppColors.transparent,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.secondary,
        contentTextStyle: TextStyle(color: AppColors.textOnSecondary),
        behavior: SnackBarBehavior.floating,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
      ),
    );
  }
}