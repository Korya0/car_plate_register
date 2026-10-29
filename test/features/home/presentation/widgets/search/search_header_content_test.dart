import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/theme/app_colors.dart';
import 'package:car_register/features/home/presentation/widgets/home_page_header.dart';

import '../../../../../support/home_test_helpers.dart';

void main() {
  testWidgets('hides the app name and uses a smaller back icon', (
    WidgetTester tester,
  ) async {
    await openHome(tester);
    await openSearch(tester);

    expect(find.text(AppStrings.appName), findsNothing);
    expect(find.text(AppStrings.allBrochuresTitle), findsOneWidget);
    expect(find.text(AppStrings.brochuresHeaderIndex), findsOneWidget);
    expect(find.text(AppStrings.brochuresSearchHint), findsOneWidget);

    final icon = tester.widget<Icon>(find.byIcon(Icons.arrow_back_ios_new));
    expect(icon.size, AppSize.icon20);
  });

  testWidgets('opens the more options menu under its button with red text', (
    WidgetTester tester,
  ) async {
    await openHome(tester);
    await addBrochure(tester, '123');
    await openSearch(tester);

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

  testWidgets('shows the search field and clears it', (
    WidgetTester tester,
  ) async {
    await openHome(tester);
    await openSearch(tester);

    expect(find.text(AppStrings.brochuresSearchHint), findsOneWidget);
    expect(find.byTooltip(AppStrings.clearSearch), findsNothing);

    await tester.enterText(find.byType(TextField), '123');
    await tester.pumpAndSettle();

    expect(find.byTooltip(AppStrings.clearSearch), findsOneWidget);

    await tester.tap(find.byTooltip(AppStrings.clearSearch));
    await tester.pumpAndSettle();

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller?.text, isEmpty);
  });

  testWidgets('keeps the header height consistent with home', (
    WidgetTester tester,
  ) async {
    await openHome(tester);
    final homeHeaderHeight = tester.getSize(find.byType(HomePageHeader)).height;

    await openSearch(tester);

    expect(
      tester.getSize(find.byType(HomePageHeader)).height,
      homeHeaderHeight,
    );
  });
}
