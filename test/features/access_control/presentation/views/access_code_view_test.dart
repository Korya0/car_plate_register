import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/router/app_routes.dart';
import 'package:car_register/core/theme/app_colors.dart';
import 'package:car_register/core/widgets/app_primary_button.dart';
import 'package:car_register/core/widgets/app_text_field.dart';
import 'package:car_register/features/access_control/presentation/views/access_code_view.dart';

void main() {
  Widget buildApp(GoRouter router) => MaterialApp.router(
    routerConfig: router,
    locale: const Locale('ar'),
    supportedLocales: const [Locale('ar')],
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    builder: (context, child) {
      AppSize.init(context);
      return child ?? const SizedBox.shrink();
    },
  );

  GoRouter buildRouter() => GoRouter(
    initialLocation: AppRoutes.accessCode,
    routes: [
      GoRoute(
        path: AppRoutes.accessCode,
        builder: (context, state) => const AccessCodeView(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const Scaffold(body: Text('home-stub')),
      ),
    ],
  );

  testWidgets('renders the access code header and form', (tester) async {
    await tester.pumpWidget(buildApp(buildRouter()));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.accessCodeTitle), findsOneWidget);
    expect(find.text(AppStrings.accessCodeSubtitle), findsOneWidget);
    expect(find.text(AppStrings.accessCodeLabel), findsOneWidget);
    expect(find.byType(AppTextField), findsOneWidget);
    expect(find.byType(AppPrimaryButton), findsOneWidget);
  });

  testWidgets('slides the logo from the opposite side to its start position', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp(buildRouter()));
    await tester.pump();

    final logo = find.byType(Image);
    final startX = tester.getTopLeft(logo).dx;

    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    final endX = tester.getTopLeft(logo).dx;

    expect(endX, greaterThan(startX));
  });

  testWidgets('fills the brand divider after the delay', (tester) async {
    await tester.pumpWidget(buildApp(buildRouter()));
    await tester.pump();

    final fill = find.byWidgetPredicate(
      (widget) => widget is ColoredBox && widget.color == AppColors.borderBrand,
    );
    final initialWidth = tester.getSize(fill).width;

    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    final finalWidth = tester.getSize(fill).width;

    expect(initialWidth, 0);
    expect(finalWidth, greaterThan(initialWidth));
  });

  testWidgets('disables submit until a code is entered', (tester) async {
    await tester.pumpWidget(buildApp(buildRouter()));
    await tester.pumpAndSettle();

    AppPrimaryButton button() =>
        tester.widget<AppPrimaryButton>(find.byType(AppPrimaryButton));

    expect(button().onPressed, isNull);

    await tester.enterText(find.byType(TextField), 'KORYA');
    await tester.pump();

    expect(button().onPressed, isNotNull);
  });

  testWidgets('strips Arabic and limits the code to 10 characters', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp(buildRouter()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'عربيKORYA123456');
    await tester.pump();

    final field = tester.widget<TextField>(find.byType(TextField));

    expect(field.controller?.text, 'KORYA12345');
  });

  testWidgets('shows the invalid code message under the button', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp(buildRouter()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'WRONG');
    await tester.pump();

    final button = tester.widget<AppPrimaryButton>(
      find.byType(AppPrimaryButton),
    );
    button.onPressed!();
    await tester.pump();

    expect(find.byType(CupertinoActivityIndicator), findsOneWidget);

    await tester.pump(AppConstants.animationSlower500ms);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.accessCodeInvalid), findsOneWidget);
    expect(find.byType(CupertinoActivityIndicator), findsNothing);
  });

  testWidgets('opens home with the demo access code', (tester) async {
    await tester.pumpWidget(buildApp(buildRouter()));
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

    expect(find.text('home-stub'), findsOneWidget);
  });
}
