import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/widgets/app_icon_button.dart';
import 'package:car_register/features/home/presentation/widgets/home_brochure_empty_state.dart';
import 'package:car_register/features/home/presentation/widgets/home_brochure_entry_row.dart';
import 'package:car_register/features/home/presentation/widgets/home_page_header.dart';
import 'package:car_register/features/home/presentation/widgets/home_page_header_curve.dart';

import '../../../../support/home_test_helpers.dart';

void main() {
  testWidgets('adds and deletes a brochure in memory', (
    WidgetTester tester,
  ) async {
    await openHome(tester);
    await addBrochure(tester, '123');

    expect(find.text('123', findRichText: true), findsOneWidget);
    expect(find.textContaining('عدد النتائج'), findsNothing);

    tester.testTextInput.hide();
    await tester.pumpAndSettle();

    await tapToDelete(tester, '123');

    expect(find.byType(HomeBrochureEmptyState), findsOneWidget);
    expect(find.text('123', findRichText: true), findsNothing);
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

  testWidgets('opens with the home field ready for typing', (
    WidgetTester tester,
  ) async {
    await openHome(tester);

    final field = tester.widget<TextField>(find.byType(TextField));

    expect(field.focusNode?.hasFocus, isTrue);
    expect(tester.testTextInput.isVisible, isTrue);

    tester.testTextInput.hide();
    await tester.pumpAndSettle();
  });

  testWidgets('keeps the keyboard hidden when deleting from home', (
    WidgetTester tester,
  ) async {
    await openHome(tester);
    await addBrochure(tester, '123');

    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    expect(tester.testTextInput.isVisible, isFalse);

    await tapToDelete(tester, '123');
    expect(tester.testTextInput.isVisible, isFalse);

    await tester.pump(AppConstants.toastDuration2s);
    await tester.pumpAndSettle();
  });

  testWidgets('keeps the card when the delete dialog is cancelled', (
    WidgetTester tester,
  ) async {
    await openHome(tester);
    await addBrochure(tester, '123');

    tester.testTextInput.hide();
    await tester.pumpAndSettle();

    await openDeleteDialog(tester, '123');

    await tester.tap(find.text(AppStrings.cancel).last);
    await tester.pumpAndSettle();

    expect(find.text('123', findRichText: true), findsOneWidget);
    expect(find.byType(HomeBrochureEmptyState), findsNothing);
  });

  testWidgets('starts selecting on a long press instead of deleting', (
    WidgetTester tester,
  ) async {
    await openHome(tester);
    await addBrochure(tester, '123');

    tester.testTextInput.hide();
    await tester.pumpAndSettle();

    await tester.longPress(find.text('123', findRichText: true));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.deleteBrochureTitle), findsNothing);
    expect(find.text(AppStrings.selectedCount(1)), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

    await tester.tap(find.byTooltip(AppStrings.cancel));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.selectedCount(1)), findsNothing);
    expect(find.text('123', findRichText: true), findsOneWidget);
  });

  testWidgets('selects all cards and deletes the selection', (
    WidgetTester tester,
  ) async {
    await openHome(tester);
    await addBrochure(tester, '123');
    await addBrochure(tester, '456');

    tester.testTextInput.hide();
    await tester.pumpAndSettle();

    await tester.longPress(find.text('123', findRichText: true));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.selectedCount(1)), findsOneWidget);

    await tester.tap(find.text(AppStrings.selectAll));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.selectedCount(2)), findsOneWidget);

    await tester.tap(find.byTooltip(AppStrings.deleteSelected));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.deleteSelectedMessage(2)), findsOneWidget);
    await tester.tap(find.text(AppStrings.delete).last);
    await tester.pumpAndSettle();

    expect(find.byType(HomeBrochureEmptyState), findsOneWidget);
    expect(find.text('123', findRichText: true), findsNothing);
    expect(find.text('456', findRichText: true), findsNothing);
  });

  testWidgets('adds a second card to the selection by tapping it', (
    WidgetTester tester,
  ) async {
    await openHome(tester);
    await addBrochure(tester, '123');
    await addBrochure(tester, '456');

    tester.testTextInput.hide();
    await tester.pumpAndSettle();

    await tester.longPress(find.text('123', findRichText: true));
    await tester.pumpAndSettle();

    await tester.tap(find.text('456', findRichText: true));
    await tester.pump();
    await tester.pump(AppConstants.pressMinVisible100ms);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.selectedCount(2)), findsOneWidget);
    expect(find.text(AppStrings.deleteBrochureTitle), findsNothing);
    expect(find.byIcon(Icons.check_circle_rounded), findsNWidgets(2));
  });

  testWidgets('clears the whole selection from the bar', (
    WidgetTester tester,
  ) async {
    await openHome(tester);
    await addBrochure(tester, '123');
    await addBrochure(tester, '456');

    tester.testTextInput.hide();
    await tester.pumpAndSettle();

    await tester.longPress(find.text('123', findRichText: true));
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.selectAll));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check_circle_rounded), findsNWidgets(2));

    await tester.tap(find.text(AppStrings.clearAllSelection));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.selectedCount(0)), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsNothing);
    expect(find.byIcon(Icons.radio_button_unchecked_rounded), findsNWidgets(2));
  });

  testWidgets('shows no delete icon on the card', (
    WidgetTester tester,
  ) async {
    await openHome(tester);
    await addBrochure(tester, '123');

    expect(find.byIcon(Icons.delete_outline_rounded), findsNothing);
    expect(
      find.descendant(
        of: find.byType(HomeBrochureEntryRow),
        matching: find.byType(AppIconButton),
      ),
      findsNothing,
    );
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

    tester.testTextInput.hide();
    await tester.pumpAndSettle();
  });
}
