import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/features/home/presentation/widgets/home_brochure_empty_state.dart';
import 'package:car_register/features/home/presentation/widgets/home_page_header.dart';
import 'package:car_register/features/home/presentation/widgets/home_page_header_curve.dart';

import '../../../../support/home_test_helpers.dart';

void main() {
  testWidgets('adds, deletes, and restores a brochure in memory', (
    WidgetTester tester,
  ) async {
    await openHome(tester);
    await addBrochure(tester, '123');

    expect(find.text('123', findRichText: true), findsOneWidget);
    expect(find.textContaining('عدد النتائج'), findsNothing);

    tester.testTextInput.hide();
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip(AppStrings.deleteBrochure));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.delete).last);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.deletedMessage('123')), findsOneWidget);
    await tester.tap(find.text(AppStrings.undo));
    await tester.pumpAndSettle();

    expect(find.text('123', findRichText: true), findsOneWidget);

    await tester.tap(find.byTooltip(AppStrings.moreOptions));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.deleteAll));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.delete).last);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.emptyCount), findsOneWidget);
    expect(find.text(AppStrings.noBrochuresYet), findsOneWidget);
    expect(find.text(AppStrings.addFirstBrochure), findsNothing);

    await tester.pump(AppConstants.toastDuration2s);
    await tester.pumpAndSettle();
  });

  testWidgets('shows saved brochures in entry mode without a results count', (
    WidgetTester tester,
  ) async {
    await openHome(tester);

    expect(find.byType(HomeBrochureEmptyState), findsOneWidget);
    expect(find.text(AppStrings.addFirstBrochure), findsNothing);

    await addBrochure(tester, '123');

    expect(find.text('123', findRichText: true), findsOneWidget);
    expect(find.textContaining('عدد النتائج'), findsNothing);
    expect(find.byType(HomeBrochureEmptyState), findsNothing);
  });

  testWidgets('uses the rounded trash icon for brochure deletion', (
    WidgetTester tester,
  ) async {
    await openHome(tester);
    await addBrochure(tester, '123');

    expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsNothing);
  });

  testWidgets('uses only the phone keyboard to enter brochure numbers', (
    WidgetTester tester,
  ) async {
    await openHome(tester);

    expect(
      find.descendant(
        of: find.byType(TextField),
        matching: find.byType(IconButton),
      ),
      findsNothing,
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    expect(tester.testTextInput.isVisible, isTrue);

    await tester.enterText(find.byType(TextField), '007');
    await tester.testTextInput.receiveAction(TextInputAction.send);
    await tester.pumpAndSettle();
    expect(tester.testTextInput.isVisible, isTrue);
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
  });

  testWidgets('shows the access code then the single home feature', (
    WidgetTester tester,
  ) async {
    await openHome(tester);

    expect(find.text(AppStrings.accessCodeTitle), findsNothing);
    expect(find.byKey(const Key('home-view')), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(HomePageHeader),
        matching: find.text(AppStrings.homeHeaderWatermark),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(HomePageHeader),
        matching: find.byType(HomePageHeaderCurve),
      ),
      findsOneWidget,
    );
    expect(find.byType(HomeBrochureEmptyState), findsOneWidget);
    expect(find.text(AppStrings.addFirstBrochure), findsNothing);
  });
}
