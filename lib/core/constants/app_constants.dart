class AppConstants {
  AppConstants._();

  // Locale
  static const String arLocaleCode = 'ar';

  // UI limits
  static const int maxOneLine = 1;
  static const int maxTwoLines = 2;
  static const int maxThreeLines = 3;
  static const int minLines3 = 3;
  static const int maxLines5 = 5;

  // Brochure numbers
  static const int brochureNumberMinLength = 1;
  static const int brochureNumberMaxLength = 4;
  static const int brochureListSkeletonCount = 3;

  // Access control
  static const int accessCodeMaxLength = 10;
  // Temporary until the access API is wired.
  static const String accessCodeDemoValue = 'KORYA';

  // Touch
  // Unscaled on purpose: this is the accessibility floor, not a design size.
  static const double minTapTarget = 48;

  // Text line heights
  static const double lineHeightBody = 1.5;
  static const double lineHeightTitle = 1.3;
  static const double lineHeightDialog = 1.5;

  // Animations
  static const Duration hapticGap200ms = Duration(milliseconds: 200);
  static const Duration animationFast200ms = Duration(milliseconds: 200);
  static const Duration animationNormal300ms = Duration(milliseconds: 300);
  static const Duration animationSlow400ms = Duration(milliseconds: 400);
  static const Duration animationSlower500ms = Duration(milliseconds: 500);
  static const Duration toastDuration2s = Duration(seconds: 2);
  static const Duration pressFadeIn70ms = Duration(milliseconds: 70);
  static const Duration pressFadeOut150ms = Duration(milliseconds: 150);
  static const Duration pressMinVisible100ms = Duration(milliseconds: 100);
  static const Duration searchDebounce300ms = Duration(milliseconds: 300);
  static const Duration accessCodeStagger60ms = Duration(milliseconds: 60);
  static const Duration accessCodeLogoDelay500ms = Duration(milliseconds: 500);
  static const Duration accessCodeLogoSlide700ms = Duration(milliseconds: 700);
  static const Duration accessCodeDividerFillDelay500ms = Duration(
    milliseconds: 500,
  );
  static const Duration accessCodeDividerFill700ms = Duration(
    milliseconds: 700,
  );
  static const Duration homeHeaderCurveDelay300ms = Duration(
    milliseconds: 300,
  );
  static const Duration homeHeaderCurveDraw900ms = Duration(milliseconds: 900);

  // Opacity
  static const double opacityTransparent = 0;
  static const double opacitySubtle = 0.2;
  static const double opacitySoft = 0.3;
  static const double opacityFaint = 0.4;
  static const double opacityMuted = 0.5;
  static const double opacityWatermark = 0.7;
  static const double opacityFull = 1;
  static const double opacityPressed = 0.55;
  static const double opacityDisabled = 0.45;

  // Motion
  static const double slideOffsetNone = 0;
  static const double slideOffsetSmall = 0.2;

  // Scale
  static const double scaleCompleted = 0.98;
  static const double scaleNormal = 1;

  // Elevation
  static const double elevationNone = 0;
}
