import 'package:flutter/material.dart';

abstract final class AppColors {
  AppColors._();

  // Screen background (very dark navy)
  static const Color scaffoldBackgroundColor = Color(0xFF050D14);
  // Cards and default surfaces (logo navy)
  static const Color secondaryScaffoldBackgroundColor = Color(0xFF091E30);

  // Primary brand (logo red)
  static const Color primary = Color(0xFFD91B21);
  // Secondary brand (steel blue derived from the logo navy)
  static const Color secondary = Color(0xFF1F5C8F);

  // Main readable text
  static const Color textPrimary = Color(0xFFFFFFFF);
  // Supporting text (light gray, readable on navy)
  static const Color textSecondary = Color(0xFF9AA3AB);
  // Disabled text (logo car gray)
  static const Color textDisabled = Color(0xFF636C74);

  // Default icons
  static const Color iconPrimary = Color(0xFFD91B21);
  // Supporting icons
  static const Color iconSecondary = Color(0xFF9AA3AB);
  // Disabled icons
  static const Color iconDisabled = Color(0xFF636C74);

  // Brand-colored text (lighter red for better contrast on dark)
  static const Color textBrand = Color(0xFFEE3B41);
  // Secondary brand text (lighter blue for contrast)
  static const Color textBrandSecondary = Color(0xFF4F93C9);

  // Brand-colored icons
  static const Color iconBrand = Color(0xFFD91B21);
  // Secondary brand icons
  static const Color iconBrandSecondary = Color(0xFF4F93C9);

  // Brand backgrounds
  static const Color surfaceBrand = Color(0xFFD91B21);
  // Secondary brand backgrounds
  static const Color surfaceBrandSecondary = Color(0xFF1F5C8F);

  // Selected backgrounds (dark red tint)
  static const Color surfaceSelected = Color(0xFF22161B);
  // Disabled backgrounds
  static const Color surfaceDisabled = Color(0xFF0C141B);

  // Brand border
  static const Color borderBrand = Color(0xFFEC4A50);
  // Neutral divider
  static const Color dividerColor = Color(0xFF1E2F40);

  // Primary action background
  static const Color actionPrimary = Color(0xFFD91B21);
  // Secondary action background
  static const Color actionSecondary = Color(0xFF1F5C8F);

  // Text on primary actions
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  // Text on secondary actions
  static const Color textOnSecondary = Color(0xFFFFFFFF);

  // Invisible fills and gradients
  static const Color transparent = Color(0x00000000);
  // Shadow and scrim base
  static const Color black = Color(0xFF000000);
}
