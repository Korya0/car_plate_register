import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/router/app_router.dart';
import 'package:car_register/core/theme/app_theme.dart';
import 'package:car_register/core/utils/context_extension.dart';

class CarRegisterApp extends StatelessWidget {
  const CarRegisterApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: AppStrings.appName,
    debugShowCheckedModeBanner: false,
    theme: AppTheme.theme,
    routerConfig: AppRouter.router,
    locale: const Locale(AppConstants.arLocaleCode),
    supportedLocales: const [Locale(AppConstants.arLocaleCode)],
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    builder: (context, child) {
      AppSize.init(context);
      return context.preventTextScaling(
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: context.unfocus,
          child: child ?? const SizedBox.shrink(),
        ),
      );
    },
  );
}
