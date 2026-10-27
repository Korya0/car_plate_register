import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:car_register/app.dart';
import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/theme/app_colors.dart';

void main() {
  testWidgets(
    'shows the splash, then the home shell and navigation',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: CarRegisterApp()),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.splashTitle), findsOneWidget);
      expect(find.text(AppStrings.splashSubtitle), findsOneWidget);

      await tester.pump(AppConstants.splashDuration1500ms);
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.splashTitle), findsNothing);
      expect(find.text(AppStrings.homeTab), findsOneWidget);
      expect(find.text(AppStrings.settingsTab), findsOneWidget);
    },
    // The splash timer is intentionally disabled for now.
    skip: true,
  );

  testWidgets('runs edge-to-edge with bars matching the app surface', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: CarRegisterApp()),
    );
    await tester.pumpAndSettle();

    final overlayFinder = find.byWidgetPredicate(
      (widget) =>
          widget is AnnotatedRegion<SystemUiOverlayStyle> &&
          widget.value.statusBarColor == AppColors.transparent &&
          widget.value.systemNavigationBarColor == AppColors.transparent &&
          widget.value.systemNavigationBarContrastEnforced == false,
    );

    expect(overlayFinder, findsWidgets);

    final overlay = tester.widget<AnnotatedRegion<SystemUiOverlayStyle>>(
      overlayFinder.first,
    );

    expect(overlay.value.statusBarIconBrightness, Brightness.dark);
    expect(overlay.value.systemNavigationBarIconBrightness, Brightness.dark);
  });
}
