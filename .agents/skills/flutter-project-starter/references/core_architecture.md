# Core Architecture Blueprint

Provides the full canonical implementation of `lib/core/` and the application entry point (`lib/main.dart` & `lib/app/app.dart`):

---

## 1. App Entry Points (`lib/main.dart` & `lib/app/app.dart`)

### A. `lib/main.dart` (Riverpod)
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:{{APP_PACKAGE}}/app/app.dart';
import 'package:{{APP_PACKAGE}}/core/di/app_initializer.dart';
import 'package:{{APP_PACKAGE}}/core/di/app_providers.dart';
import 'package:{{APP_PACKAGE}}/core/utils/app_provider_observer.dart';

Future<void> main() async {
  final bootstrap = await AppInitializer.initialize();

  runApp(
    ProviderScope(
      overrides: [
        appLocalStorageProvider.overrideWithValue(bootstrap.localStorage),
        appSecureStorageProvider.overrideWithValue(bootstrap.secureStorage),
      ],
      observers: const [AppProviderObserver()],
      child: const {{APP_CLASS_NAME}}(),
    ),
  );
}
```

### B. `lib/app/app.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:{{APP_PACKAGE}}/core/constants/app_constants.dart';
import 'package:{{APP_PACKAGE}}/core/constants/app_sizes.dart';
import 'package:{{APP_PACKAGE}}/core/constants/app_strings.dart';
import 'package:{{APP_PACKAGE}}/core/router/app_router.dart';
import 'package:{{APP_PACKAGE}}/core/theme/app_scroll_behavior.dart';
import 'package:{{APP_PACKAGE}}/core/theme/app_theme.dart';
import 'package:{{APP_PACKAGE}}/core/utils/context_extension.dart';

class {{APP_CLASS_NAME}} extends StatelessWidget {
  const {{APP_CLASS_NAME}}({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: AppStrings.appName,
    debugShowCheckedModeBanner: false,
    theme: AppTheme.theme,
    routerConfig: AppRouter.router,
    scrollBehavior: const AppScrollBehavior(),
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
```

---

## 2. Constants & Responsive Metrics (`lib/core/constants/`)

### A. `app_sizes.dart`
- Dynamic scaled getters based on `_shortestSide / 375`, clamped to `[0.8× … 1.3×]`.
- Token families: `icon16..48`, `p4..48`, `f12..32`, `h18..150`, `w4..48`, `r4..24`, `circularRadius` (99).
- Composite insets: `shp` (`EdgeInsets.symmetric(horizontal: p16)`), `stp` (p16), `sbp` (p40).
- `contentMaxWidth = 640` for tablet centering.

### B. `app_constants.dart`
- Limits: `maxOneLine = 1`, `maxTwoLines = 2`, `maxThreeLines = 3`.
- Accessibility floor: `minTapTarget = 48` (unscaled).
- Line heights: `lineHeightBody = 1.5`, `lineHeightTitle = 1.3`.
- Durations: `pressFadeIn70ms`, `pressFadeOut150ms`, `animationNormal300ms`.
- Opacity tokens: `opacityPressed = 0.55`, `opacityDisabled = 0.45`, `opacityFull = 1.0`.

---

## 3. Theme & Typography (`lib/core/theme/`)

- `AppColors`: Abstract final class with `static const Color` fields for every palette role.
- `AppTheme`:
  - `useMaterial3: true`.
  - `splashFactory: NoSplash.splashFactory` (removes material water ripples).
  - Explicit `ColorScheme`, `scaffoldBackgroundColor`, `appBarTheme`, `bottomSheetTheme`, `dialogTheme`.
- `AppTextStyles`:
  - Uses default Flutter system font engine.
  - Semantic roles: `font12W500Secondary`, `font14W500Primary`, `font14W700OnPrimary`, `font16W700Primary`, `font20W700Primary`, `font32W800Brand`.

### Scroll Behavior (`app_scroll_behavior.dart`)

Android 12+ applies a platform overscroll **stretch** effect to every scrollable. On screens whose content is shorter than the viewport (forms, empty states, splash-like screens), dragging looks like the whole screen is stretching. This is the platform `StretchingOverscrollIndicator` from the default `MaterialScrollBehavior`, **not** a `CustomScrollView` layout bug.

Disable it globally so every screen behaves consistently:

```dart
import 'package:flutter/material.dart';

class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;
}
```

Wire it in `MaterialApp.router` with `scrollBehavior: const AppScrollBehavior(),`. Scrolling still works; only the stretch/glow feedback is removed.

---

## 4. Routing & Navigation (`lib/core/router/`)

- `AppRoutes`: Centralized `kebab-case` path strings (`/`, `/settings`, etc.).
- `AppRouter`:
  - Configures `GoRouter` with `initialLocation`.
  - Smooth page transitions via `CustomTransitionPage` with `FadeTransition`.
  - Fallback error route via `AppErrorView`.
- `AppRouteArgs`: Type-safe route argument extraction.

---

## 5. Error & Result Pattern (`lib/core/error/`)

- Sealed `Failure` hierarchy:
  - `NetworkFailure`, `CacheFailure`, `DatabaseFailure`, `SyncFailure`, `ValidationFailure`, `UnknownFailure`.
- Sealed `Result<T>`:
  - `Success<T>(final T data)`
  - `FailureResult<T>(final Failure failure)`
  - Getters: `isSuccess`, `isFailure`, `dataOrNull`, `failureOrNull`.

---

## 6. Utilities & Extensions (`lib/core/utils/`)

- `AppValidators`: Input validation routines (digit formats, character lengths, required fields).
- `AppLogger`: Uniform console logging abstraction.
- `ContextExtension`: Extensions on `BuildContext`:
  - `unfocus()`: Hides keyboard.
  - `preventTextScaling()`: Locks text scaler to 1.0.
  - `sizeClass`: Resolves responsive screen breakpoints (`compact`, `medium`, `expanded`, `large`).
  - `isLandscape`, `isRtl`, `isArabic`.
