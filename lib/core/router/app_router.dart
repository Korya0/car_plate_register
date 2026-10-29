import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/router/app_routes.dart';
import 'package:car_register/core/widgets/app_error_view.dart';
import 'package:car_register/features/access_control/presentation/views/access_code_view.dart';
import 'package:car_register/features/home/presentation/views/home_view.dart';
import 'package:car_register/features/home/presentation/views/search_view.dart';

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
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: AppRoutes.search,
        name: AppRoutes.search,
        builder: (context, state) => const SearchView(),
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
