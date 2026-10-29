import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/theme/app_colors.dart';

import '../../../../../support/home_test_helpers.dart';

void main() {
  testWidgets('shows the app name and search action in entry mode', (
    WidgetTester tester,
  ) async {
    await openHome(tester);

    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.byTooltip(AppStrings.brochuresSearchHint), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_ios_new), findsNothing);
    expect(find.text(AppStrings.homeEntryTitle), findsWidgets);
    expect(find.text(AppStrings.homeSearchHint), findsWidgets);
  });

  testWidgets('opens the more options menu under its button with red text', (
    WidgetTester tester,
  ) async {
    await openHome(tester);
    await addBrochure(tester, '123');

    final button = find.byType(PopupMenuButton<String>);
    final buttonRect = tester.getRect(button);

    await tester.tap(button);
    await tester.pumpAndSettle();

    final menuItem = find.byType(PopupMenuItem<String>);
    expect(menuItem, findsOneWidget);

    final menuRect = tester.getRect(menuItem);
    expect(menuRect.top, greaterThanOrEqualTo(buttonRect.bottom));
    expect(menuRect.left, closeTo(buttonRect.left, 0.5));

    final label = tester.widget<Text>(find.text(AppStrings.deleteAll));
    expect(label.style?.color, AppColors.textBrand);

    await tester.tap(find.text(AppStrings.deleteAll));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.deleteAllTitle), findsOneWidget);
  });
}
