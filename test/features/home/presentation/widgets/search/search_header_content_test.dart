import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/widgets/app_pressable.dart';
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

  testWidgets('submits from the field action without an options menu', (
    WidgetTester tester,
  ) async {
    await openHome(tester);
    await addBrochure(tester, '123');
    await openSearch(tester);

    expect(find.byType(PopupMenuButton<String>), findsNothing);
    expect(find.byTooltip(AppStrings.searchNow), findsOneWidget);

    AppPressable submitButton() => tester.widget<AppPressable>(
      find.descendant(
        of: find.byTooltip(AppStrings.searchNow),
        matching: find.byType(AppPressable),
      ),
    );

    expect(submitButton().onPressed, isNull);

    await tester.enterText(find.byType(TextField), '1');
    await tester.pumpAndSettle();
    expect(submitButton().onPressed, isNotNull);

    await tester.tap(find.byTooltip(AppStrings.searchNow));
    await tester.pumpAndSettle();

    expect(tester.testTextInput.isVisible, isFalse);
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
