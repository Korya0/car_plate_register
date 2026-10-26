import 'package:flutter/material.dart';

import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/theme/app_colors.dart';

abstract final class AppTextStyles {
  AppTextStyles._();

  static TextStyle get font12W500Secondary => TextStyle(
    fontSize: AppSize.f12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static TextStyle get font12W500Error => TextStyle(
    fontSize: AppSize.f12,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );

  static TextStyle get font12W700Brand => TextStyle(
    fontSize: AppSize.f12,
    fontWeight: FontWeight.w700,
    color: AppColors.textBrand,
  );

  static TextStyle get font14W500Primary => TextStyle(
    fontSize: AppSize.f14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle get font14W500Secondary => TextStyle(
    fontSize: AppSize.f14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static TextStyle get font14W500Error => TextStyle(
    fontSize: AppSize.f14,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );

  static TextStyle get font14W700Primary => TextStyle(
    fontSize: AppSize.f14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle get font14W700Brand => TextStyle(
    fontSize: AppSize.f14,
    fontWeight: FontWeight.w700,
    color: AppColors.textBrand,
  );

  static TextStyle get font14W700OnPrimary => TextStyle(
    fontSize: AppSize.f14,
    fontWeight: FontWeight.w700,
    color: AppColors.textOnPrimary,
  );

  static TextStyle get font16W500Primary => TextStyle(
    fontSize: AppSize.f16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: AppConstants.lineHeightBody,
  );

  static TextStyle get font16W500Secondary => TextStyle(
    fontSize: AppSize.f16,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: AppConstants.lineHeightBody,
  );

  static TextStyle get font16W700Primary => TextStyle(
    fontSize: AppSize.f16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: AppConstants.lineHeightTitle,
  );

  static TextStyle get font20W700Primary => TextStyle(
    fontSize: AppSize.f20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: AppConstants.lineHeightTitle,
  );

  static TextStyle get font32W800Brand => TextStyle(
    fontSize: AppSize.f32,
    fontWeight: FontWeight.w800,
    color: AppColors.textBrand,
    height: AppConstants.lineHeightTitle,
  );
}
