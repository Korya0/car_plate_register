import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:car_register/app.dart';
import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/router/app_router.dart';
import 'package:car_register/core/router/app_routes.dart';
import 'package:car_register/core/theme/app_colors.dart';
import 'package:car_register/core/theme/app_scroll_behavior.dart';
import 'package:car_register/core/widgets/app_primary_button.dart';

void main() {
  testWidgets('shows the access code, then the home shell', (
    WidgetTester tester,
  ) async {
    AppRouter.router.go(AppRoutes.accessCode);
    await tester.pumpWidget(
      const ProviderScope(child: CarRegisterApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.accessCodeTitle), findsOneWidget);

    await tester.enterText(
      find.byType(TextField),
      AppConstants.accessCodeDemoValue,
    );
    await tester.pump();

    final button = tester.widget<AppPrimaryButton>(
      find.byType(AppPrimaryButton),
    );
    button.onPressed!();
    await tester.pump();
    await tester.pump(AppConstants.animationSlower500ms);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.accessCodeTitle), findsNothing);
    expect(find.text(AppStrings.homeTab), findsOneWidget);
    expect(find.text(AppStrings.settingsTab), findsOneWidget);
  });

  testWidgets('disables the platform overscroll stretch', (tester) async {
    AppRouter.router.go(AppRoutes.accessCode);
    await tester.pumpWidget(
      const ProviderScope(child: CarRegisterApp()),
    );
    await tester.pumpAndSettle();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));

    expect(app.scrollBehavior, isA<AppScrollBehavior>());
  });

  testWidgets('dismisses the keyboard when a scrollable is dragged', (
    tester,
  ) async {
    AppRouter.router.go(AppRoutes.accessCode);
    await tester.pumpWidget(
      const ProviderScope(child: CarRegisterApp()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TextField));
    await tester.pump();

    expect(tester.testTextInput.isVisible, isTrue);

    await tester.dragFrom(
      const Offset(400, 550),
      const Offset(0, -100),
    );
    await tester.pump();

    expect(tester.testTextInput.isVisible, isFalse);
  });

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
