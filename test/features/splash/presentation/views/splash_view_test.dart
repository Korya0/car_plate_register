import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:car_register/core/constants/app_assets.dart';
import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/router/app_routes.dart';
import 'package:car_register/features/splash/presentation/views/splash_view.dart';

void main() {
  Widget buildApp(GoRouter router) {
    return MaterialApp.router(
      routerConfig: router,
      builder: (context, child) {
        AppSize.init(context);
        return child ?? const SizedBox.shrink();
      },
    );
  }

  GoRouter buildRouter() => GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: '/home',
        name: AppRoutes.home,
        builder: (context, state) => const Scaffold(body: Text('home-stub')),
      ),
    ],
  );

  testWidgets('renders the logo, title, and subtitle', (tester) async {
    await tester.pumpWidget(buildApp(buildRouter()));
    await tester.pumpAndSettle();

    expect(find.byType(SplashView), findsOneWidget);

    final logo = tester.widget<Image>(find.byType(Image));

    expect((logo.image as AssetImage).assetName, AppAssets.logo);
    expect(find.text(AppStrings.splashTitle), findsOneWidget);
    expect(find.text(AppStrings.splashSubtitle), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'opens home after the splash duration',
    (tester) async {
      final router = buildRouter();
      await tester.pumpWidget(buildApp(router));
      await tester.pump();

      expect(find.text('home-stub'), findsNothing);

      await tester.pump(AppConstants.splashDuration1500ms);
      await tester.pumpAndSettle();

      expect(find.text('home-stub'), findsOneWidget);
    },
    // The splash timer is intentionally disabled for now.
    skip: true,
  );
}
