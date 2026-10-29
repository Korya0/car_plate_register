import 'package:flutter/material.dart';

abstract final class AppColors {
  AppColors._();

  // Screen background (white)
  static const Color scaffoldBackgroundColor = Color(0xFFFFFFFF);
  // Cards and default surfaces (very light gray-blue)
  static const Color secondaryScaffoldBackgroundColor = Color(0xFFF4F6F8);

  // Primary brand (logo red)
  static const Color primary = Color(0xFFD91B21);
  // Secondary brand (logo navy)
  static const Color secondary = Color(0xFF091E30);

  // Main readable text (logo navy)
  static const Color textPrimary = Color(0xFF091E30);
  // Supporting text (logo car gray)
  static const Color textSecondary = Color(0xFF636C74);
  // Disabled text
  static const Color textDisabled = Color(0xFFA7AEB5);

  // Default icons
  static const Color iconPrimary = Color(0xFFD91B21);
  // Supporting icons
  static const Color iconSecondary = Color(0xFF636C74);
  // Disabled icons
  static const Color iconDisabled = Color(0xFFA7AEB5);

  // Brand-colored text (slightly darker red for contrast on white)
  static const Color textBrand = Color(0xFFC4191F);
  // Secondary brand text
  static const Color textBrandSecondary = Color(0xFF091E30);

  // Brand-colored icons
  static const Color iconBrand = Color(0xFFD91B21);
  // Secondary brand icons
  static const Color iconBrandSecondary = Color(0xFF091E30);

  // Brand backgrounds
  static const Color surfaceBrand = Color(0xFFD91B21);
  // Secondary brand backgrounds
  static const Color surfaceBrandSecondary = Color(0xFF091E30);

  // Selected backgrounds (light red tint)
  static const Color surfaceSelected = Color(0xFFFDECEC);
  // Disabled backgrounds
  static const Color surfaceDisabled = Color(0xFFEEF0F2);

  // Brand border
  static const Color borderBrand = Color(0xFFD91B21);
  // Neutral divider
  static const Color dividerColor = Color(0xFFE1E5E9);

  // Primary action background
  static const Color actionPrimary = Color(0xFFD91B21);
  // Secondary action background
  static const Color actionSecondary = Color(0xFF091E30);

  // Text on primary actions
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  // Text on secondary actions
  static const Color textOnSecondary = Color(0xFFFFFFFF);

  // Invisible fills and gradients
  static const Color transparent = Color(0x00000000);
  // Shadow and scrim base
  static const Color black = Color(0xFF000000);
}
