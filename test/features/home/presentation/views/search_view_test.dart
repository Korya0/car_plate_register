import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/features/home/presentation/widgets/home_brochure_empty_state.dart';

import '../../../../support/home_test_helpers.dart';

void main() {
  testWidgets('opens search as a separate screen and returns home', (
    WidgetTester tester,
  ) async {
    await openHome(tester);
    await openSearch(tester);

    expect(find.byKey(const Key('search-view')), findsOneWidget);
    expect(find.byKey(const Key('home-view')), findsNothing);
    expect(find.text(AppStrings.appName), findsNothing);

    await tester.tap(find.byTooltip(AppStrings.back));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('home-view')), findsOneWidget);
    expect(find.byKey(const Key('search-view')), findsNothing);
  });

  testWidgets('filters the same brochure list in search', (
    WidgetTester tester,
  ) async {
    await openHome(tester);
    await addBrochure(tester, '123');
    await openSearch(tester);

    await tester.enterText(find.byType(TextField), '2');
    await tester.pumpAndSettle();

    expect(find.text('123', findRichText: true), findsOneWidget);
    expect(find.textContaining('عدد النتائج'), findsNothing);
  });

  testWidgets('shows the empty state when a search has no matches', (
    WidgetTester tester,
  ) async {
    await openHome(tester);
    await addBrochure(tester, '123');
    await openSearch(tester);

    await tester.enterText(find.byType(TextField), '999');
    await tester.pumpAndSettle();

    expect(find.byType(HomeBrochureEmptyState), findsOneWidget);
    expect(find.text(AppStrings.noBrochuresYet), findsOneWidget);
    expect(find.text(AppStrings.firstBrochurePrompt), findsNothing);
    expect(find.text(AppStrings.addFirstBrochure), findsNothing);
  });

  testWidgets('deletes and restores a brochure from search', (
    WidgetTester tester,
  ) async {
    await openHome(tester);
    await addBrochure(tester, '123');
    await openSearch(tester);

    await tester.enterText(find.byType(TextField), '1');
    await tester.pumpAndSettle();

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
  });

  testWidgets('deletes all in search and returns home from the empty state', (
    WidgetTester tester,
  ) async {
    await openHome(tester);
    await addBrochure(tester, '123');
    await openSearch(tester);

    await tester.tap(find.byTooltip(AppStrings.moreOptions));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.deleteAll));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.delete).last);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.emptyCount), findsOneWidget);
    expect(find.text(AppStrings.addFirstBrochure), findsOneWidget);

    await tester.pump(AppConstants.toastDuration2s);
    await tester.ensureVisible(find.text(AppStrings.addFirstBrochure));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.addFirstBrochure));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('home-view')), findsOneWidget);
    expect(find.byKey(const Key('search-view')), findsNothing);
  });

  testWidgets('keeps the keyboard hidden when deleting from search', (
    WidgetTester tester,
  ) async {
    await openHome(tester);
    await addBrochure(tester, '123');
    await openSearch(tester);

    await tester.enterText(find.byType(TextField), '1');
    await tester.pumpAndSettle();

    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    expect(tester.testTextInput.isVisible, isFalse);

    await tester.tap(find.byTooltip(AppStrings.deleteBrochure));
    await tester.pumpAndSettle();
    expect(tester.testTextInput.isVisible, isFalse);

    await tester.tap(find.text(AppStrings.cancel).last);
    await tester.pumpAndSettle();
    expect(tester.testTextInput.isVisible, isFalse);
  });
}
