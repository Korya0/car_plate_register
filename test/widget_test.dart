import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:car_register/app.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/router/app_router.dart';
import 'package:car_register/core/router/app_routes.dart';
import 'package:car_register/core/theme/app_colors.dart';
import 'package:car_register/core/theme/app_scroll_behavior.dart';
import 'package:car_register/core/widgets/app_text_field.dart';

import 'support/home_test_helpers.dart';

void main() {
  testWidgets('reuses AppTextField with readable text on every screen', (
    WidgetTester tester,
  ) async {
    await openHome(tester);

    expect(find.byType(AppTextField), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).style?.color,
      AppColors.textPrimary,
    );

    await tester.tap(find.byTooltip(AppStrings.brochuresSearchHint));
    await tester.pumpAndSettle();
    expect(find.byType(AppTextField), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).style?.color,
      AppColors.textPrimary,
    );

    AppRouter.router.go(AppRoutes.accessCode);
    await tester.pumpAndSettle();
    expect(find.byType(AppTextField), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).style?.color,
      AppColors.textPrimary,
    );
  });

  testWidgets('uses rounded red focus borders on all text fields', (
    WidgetTester tester,
  ) async {
    void expectFocusedBorder() {
      final fieldContainer = find
          .ancestor(
            of: find.byType(TextField),
            matching: find.byWidgetPredicate((widget) {
              if (widget is! Container) return false;
              final decoration = widget.decoration;
              return decoration is BoxDecoration &&
                  decoration.borderRadius != null;
            }),
          )
          .first;
      final decoration =
          tester.widget<Container>(fieldContainer).decoration! as BoxDecoration;

      expect(decoration.border!.top.color, AppColors.borderBrand);
      expect(decoration.borderRadius, BorderRadius.circular(AppSize.r12));
    }

    await openHome(tester);
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    expectFocusedBorder();
    tester.testTextInput.hide();
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip(AppStrings.brochuresSearchHint));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    expectFocusedBorder();
    tester.testTextInput.hide();
    await tester.pumpAndSettle();

    AppRouter.router.go(AppRoutes.accessCode);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    expectFocusedBorder();
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
