import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/widgets/app_pressable.dart';

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

  testWidgets('saves from the field action and drops the options menu', (
    WidgetTester tester,
  ) async {
    await openHome(tester);

    expect(find.byType(PopupMenuButton<String>), findsNothing);
    expect(find.byTooltip(AppStrings.saveNumber), findsOneWidget);

    AppPressable saveButton() => tester.widget<AppPressable>(
      find.descendant(
        of: find.byTooltip(AppStrings.saveNumber),
        matching: find.byType(AppPressable),
      ),
    );

    expect(saveButton().onPressed, isNull);

    await tester.enterText(find.byType(TextField), '007');
    await tester.pumpAndSettle();
    expect(saveButton().onPressed, isNotNull);

    await tester.tap(find.byTooltip(AppStrings.saveNumber));
    await tester.pump(AppConstants.animationFast200ms);
    await tester.pumpAndSettle();

    expect(find.text('007', findRichText: true), findsOneWidget);
  });
}
