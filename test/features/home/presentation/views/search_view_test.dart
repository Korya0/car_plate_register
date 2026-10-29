import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

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
    expect(tester.testTextInput.isVisible, isFalse);
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

  testWidgets('deletes a brochure from search', (
    WidgetTester tester,
  ) async {
    await openHome(tester);
    await addBrochure(tester, '123');
    await openSearch(tester);

    await tester.enterText(find.byType(TextField), '1');
    await tester.pumpAndSettle();

    tester.testTextInput.hide();
    await tester.pumpAndSettle();

    await tapToDelete(tester, '123');

    expect(find.text('123', findRichText: true), findsNothing);
    expect(find.text(AppStrings.addFirstBrochure), findsOneWidget);
  });

  testWidgets('opens with the search field ready for typing', (
    WidgetTester tester,
  ) async {
    await openHome(tester);
    await openSearch(tester);

    final field = tester.widget<TextField>(find.byType(TextField));

    expect(field.focusNode?.hasFocus, isTrue);
    expect(tester.testTextInput.isVisible, isTrue);

    tester.testTextInput.hide();
    await tester.pumpAndSettle();
  });

  testWidgets('deletes the last brochure in search and returns home', (
    WidgetTester tester,
  ) async {
    await openHome(tester);
    await addBrochure(tester, '123');
    await openSearch(tester);

    tester.testTextInput.hide();
    await tester.pumpAndSettle();

    await tapToDelete(tester, '123');

    expect(find.text(AppStrings.emptyCount), findsOneWidget);
    expect(find.text(AppStrings.addFirstBrochure), findsOneWidget);

    await tester.ensureVisible(find.text(AppStrings.addFirstBrochure));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.addFirstBrochure));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('home-view')), findsOneWidget);
    expect(find.byKey(const Key('search-view')), findsNothing);
  });

  testWidgets('refreshes the home list after deleting from search', (
    WidgetTester tester,
  ) async {
    await openHome(tester);
    await addBrochure(tester, '123');
    await openSearch(tester);

    tester.testTextInput.hide();
    await tester.pumpAndSettle();

    await tapToDelete(tester, '123');

    await tester.tap(find.byTooltip(AppStrings.back));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('home-view')), findsOneWidget);
    expect(find.text('123', findRichText: true), findsNothing);
    expect(find.text(AppStrings.noBrochuresYet), findsOneWidget);
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

    await openDeleteDialog(tester, '123');
    expect(tester.testTextInput.isVisible, isFalse);

    await tester.tap(find.text(AppStrings.cancel).last);
    await tester.pumpAndSettle();
    expect(tester.testTextInput.isVisible, isFalse);
  });
}
