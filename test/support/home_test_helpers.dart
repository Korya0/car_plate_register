import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:car_register/app.dart';
import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/router/app_router.dart';
import 'package:car_register/core/router/app_routes.dart';
import 'package:car_register/core/widgets/app_primary_button.dart';

Future<void> openHome(WidgetTester tester) async {
  AppRouter.router.go(AppRoutes.accessCode);
  await tester.pumpWidget(
    const ProviderScope(child: CarRegisterApp()),
  );
  await tester.pumpAndSettle();

  await tester.enterText(
    find.byType(TextField),
    AppConstants.accessCodeDemoValue,
  );
  await tester.pump();

  final button = tester.widget<AppPrimaryButton>(
    find.byType(AppPrimaryButton),
  );
  button.onPressed!();
  await tester.pump();
  await tester.pump(AppConstants.animationSlower500ms);
  await tester.pumpAndSettle();
}

Future<void> openSearch(WidgetTester tester) async {
  await tester.tap(find.byTooltip(AppStrings.brochuresSearchHint));
  await tester.pumpAndSettle();
}

Future<void> addBrochure(WidgetTester tester, String number) async {
  await tester.tap(find.byType(TextField));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField), number);
  await tester.testTextInput.receiveAction(TextInputAction.send);
  await tester.pumpAndSettle();
  tester.testTextInput.hide();
  await tester.pumpAndSettle();
}
