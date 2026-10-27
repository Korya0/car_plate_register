import 'dart:async';

import 'package:car_register/core/constants/app_assets.dart';
import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/router/app_routes.dart';
import 'package:car_register/core/theme/app_text_styles.dart';
import 'package:car_register/core/widgets/app_gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // _timer = Timer(AppConstants.splashDuration1500ms, _openHome);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Opens the main shell once the splash has been shown.
  // ignore: unused_element
  void _openHome() {
    if (!mounted) return;
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo
          Image.asset(
            AppAssets.logo,
            width: AppSize.w200,
          ).animate().scale(
            duration: AppConstants.splashFade250ms,
            begin: const Offset(0.5, 0.5),
            end: const Offset(1.0, 1.0),
            curve: Curves.easeInOut,
          ),

          // Title
          Text(
            AppStrings.splashTitle,
            style: AppTextStyles.font34W800Primary,
            textAlign: TextAlign.center,
          ).animate().fadeIn(
            duration: AppConstants.splashFade250ms,
            curve: Curves.easeInOut,
          ),

          AppGap.h(AppSize.p8),

          // Subtitle
          Text(
            AppStrings.splashSubtitle,
            style: AppTextStyles.font15W400Secondary,
            textAlign: TextAlign.center,
          ).animate().fadeIn(
            duration: AppConstants.splashFade250ms,
            curve: Curves.easeInOut,
          ),
        ],
      ),
    ),
  );
}
