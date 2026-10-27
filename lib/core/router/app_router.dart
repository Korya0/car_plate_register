import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/router/app_routes.dart';
import 'package:car_register/core/widgets/app_error_view.dart';
import 'package:car_register/core/widgets/main_view.dart';
import 'package:car_register/features/access_control/presentation/views/access_code_view.dart';
import 'package:car_register/features/brochures/presentation/views/brochures_view.dart';
import 'package:car_register/features/home/presentation/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.accessCode,
    routes: [
      GoRoute(
        path: AppRoutes.accessCode,
        name: AppRoutes.accessCode,
        builder: (context, state) => const AccessCodeView(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainView(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: AppRoutes.home,
                builder: (context, state) => const HomeView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.brochures,
                name: AppRoutes.brochures,
                builder: (context, state) => const BrochuresView(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverSafeArea(
            sliver: SliverFillRemaining(
              hasScrollBody: false,
              child: AppErrorView(message: AppStrings.pageNotFound),
            ),
          ),
        ],
      ),
    ),
  );
}
