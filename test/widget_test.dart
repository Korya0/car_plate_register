import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:car_register/app.dart';
import 'package:car_register/core/constants/app_strings.dart';

void main() {
  testWidgets('renders the empty feature shell and navigation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: CarRegisterApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.appName), findsNothing);
    expect(find.text(AppStrings.homeTitle), findsNothing);
    expect(find.text(AppStrings.emptyTitle), findsNothing);
    expect(find.byType(Image), findsNothing);
    expect(find.byType(Scaffold), findsNWidgets(2));
    expect(find.text(AppStrings.settingsTab), findsOneWidget);
    expect(find.text(AppStrings.homeTab), findsOneWidget);
  });
}
