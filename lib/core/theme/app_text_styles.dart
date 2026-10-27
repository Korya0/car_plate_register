import 'package:flutter/material.dart';

import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/theme/app_colors.dart';
import 'package:car_register/core/theme/app_font.dart';

abstract final class AppTextStyles {
  AppTextStyles._();

  static TextStyle get font12W500Secondary => TextStyle(
    fontSize: AppSize.f12,
    fontWeight: AppFontWeight.medium.value,
    color: AppColors.textSecondary,
  );

  static TextStyle get font12W500Error => TextStyle(
    fontSize: AppSize.f12,
    fontWeight: AppFontWeight.medium.value,
    color: AppColors.primary,
  );

  static TextStyle get font12W700Brand => TextStyle(
    fontSize: AppSize.f12,
    fontWeight: AppFontWeight.bold.value,
    color: AppColors.textBrand,
  );

  static TextStyle get font13W400Secondary => TextStyle(
    fontSize: AppSize.f13,
    fontWeight: AppFontWeight.regular.value,
    color: AppColors.textSecondary,
  );

  static TextStyle get font14W500Primary => TextStyle(
    fontSize: AppSize.f14,
    fontWeight: AppFontWeight.medium.value,
    color: AppColors.textPrimary,
  );

  static TextStyle get font14W500Secondary => TextStyle(
    fontSize: AppSize.f14,
    fontWeight: AppFontWeight.medium.value,
    color: AppColors.textSecondary,
  );

  static TextStyle get font14W500Error => TextStyle(
    fontSize: AppSize.f14,
    fontWeight: AppFontWeight.medium.value,
    color: AppColors.primary,
  );

  static TextStyle get font14W700Primary => TextStyle(
    fontSize: AppSize.f14,
    fontWeight: AppFontWeight.bold.value,
    color: AppColors.textPrimary,
  );

  static TextStyle get font14W700Brand => TextStyle(
    fontSize: AppSize.f14,
    fontWeight: AppFontWeight.bold.value,
    color: AppColors.textBrand,
  );

  static TextStyle get font14W700OnPrimary => TextStyle(
    fontSize: AppSize.f14,
    fontWeight: AppFontWeight.bold.value,
    color: AppColors.textOnPrimary,
  );

  static TextStyle get font15W400Secondary => TextStyle(
    fontSize: AppSize.f15,
    fontWeight: AppFontWeight.regular.value,
    color: AppColors.textSecondary,
    height: AppConstants.lineHeightBody,
  );

  static TextStyle get font16W500Primary => TextStyle(
    fontSize: AppSize.f16,
    fontWeight: AppFontWeight.medium.value,
    color: AppColors.textPrimary,
    height: AppConstants.lineHeightBody,
  );

  static TextStyle get font16W500Secondary => TextStyle(
    fontSize: AppSize.f16,
    fontWeight: AppFontWeight.medium.value,
    color: AppColors.textSecondary,
    height: AppConstants.lineHeightBody,
  );

  static TextStyle get font16W700Primary => TextStyle(
    fontSize: AppSize.f16,
    fontWeight: AppFontWeight.bold.value,
    color: AppColors.textPrimary,
    height: AppConstants.lineHeightTitle,
  );

  static TextStyle get font20W700Primary => TextStyle(
    fontSize: AppSize.f20,
    fontWeight: AppFontWeight.bold.value,
    color: AppColors.textPrimary,
    height: AppConstants.lineHeightTitle,
  );

  static TextStyle get font30W800Primary => TextStyle(
    fontSize: AppSize.f30,
    fontWeight: AppFontWeight.extraBold.value,
    color: AppColors.textPrimary,
    height: AppConstants.lineHeightTitle,
  );

  static TextStyle get font30W800OnSecondary => TextStyle(
    fontSize: AppSize.f30,
    fontWeight: AppFontWeight.extraBold.value,
    color: AppColors.textOnSecondary,
    height: AppConstants.lineHeightTitle,
  );

  static TextStyle get font32W800Brand => TextStyle(
    fontSize: AppSize.f32,
    fontWeight: AppFontWeight.extraBold.value,
    color: AppColors.textBrand,
    height: AppConstants.lineHeightTitle,
  );

  static TextStyle get font34W800Primary => TextStyle(
    fontSize: AppSize.f34,
    fontWeight: AppFontWeight.extraBold.value,
    color: AppColors.textPrimary,
    height: AppConstants.lineHeightTitle,
  );

  static TextStyle get font150W800Watermark => TextStyle(
    fontSize: AppSize.f150,
    fontWeight: AppFontWeight.extraBold.value,
    color: AppColors.textWatermark,
    height: AppConstants.lineHeightTitle,
  );
}
