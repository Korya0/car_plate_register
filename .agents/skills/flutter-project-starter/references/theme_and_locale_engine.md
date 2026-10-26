# Theme, Locale & Edge-to-Edge Engine

Use this reference when the project requires Light/Dark dual themes, multi-language localization (ARB), or full edge-to-edge transparent system UI.

---

## 1. Full Edge-to-Edge System UI Configuration

Ensures fully transparent status bar and gesture navigation bar on Android 10+ and 15:

### A. In `AppInitializer`:
```dart
SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
```

### B. In `MaterialApp.router` `builder`:
```dart
builder: (context, child) {
  AppSize.init(context);
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: context.unfocus,
    child: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColorsCommon.transparent,
        systemNavigationBarColor: AppColorsCommon.transparent,
        systemNavigationBarContrastEnforced: false,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: context.preventTextScaling(child ?? const SizedBox.shrink()),
    ),
  );
}
```

---

## 2. Dual Themes (Light & Dark) via `ThemeExtension`

When dual modes are required:

### A. `lib/core/theme/extensions/app_colors_extension.dart`
```dart
import 'package:flutter/material.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.divider,
  });

  final Color primary;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color divider;

  @override
  ThemeExtension<AppColorsExtension> copyWith({ ... }) => ...;

  @override
  ThemeExtension<AppColorsExtension> lerp(covariant ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }
}
```

### B. Widget Sugar via `ContextExtension`:
```dart
extension ThemeContextExtension on BuildContext {
  AppColorsExtension get colors => Theme.of(this).extension<AppColorsExtension>()!;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
```

---

## 3. Theme Toggle & Persistence

### A. Riverpod Option (`ThemeNotifier`):
```dart
final themeNotifierProvider = NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);

class ThemeNotifier extends Notifier<ThemeMode> {
  late final LocalStorage _storage = ref.read(localStorageProvider);

  @override
  ThemeMode build() {
    final saved = _storage.read<String>(LocalStorageKeys.themeMode);
    return switch (saved) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> changeTheme(ThemeMode mode) async {
    await _storage.write(LocalStorageKeys.themeMode, mode.name);
    state = mode;
  }

  Future<void> toggleTheme() async {
    final next = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await changeTheme(next);
  }
}
```

### B. Cubit Option (`ThemeCubit`):
```dart
final class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._storage) : super(ThemeMode.system) {
    loadSavedTheme();
  }

  final LocalStorage _storage;

  void loadSavedTheme() {
    final saved = _storage.read<String>(LocalStorageKeys.themeMode);
    final mode = switch (saved) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    emit(mode);
  }

  Future<void> changeTheme(ThemeMode mode) async {
    await _storage.write(LocalStorageKeys.themeMode, mode.name);
    emit(mode);
  }
}
```

---

## 4. Multi-Language Support (ARB Localization)

When multi-language is selected:
- Enable `generate: true` in `pubspec.yaml` and add `l10n.yaml`.
- Create translation files:
  - `lib/core/l10n/app_ar.arb`
  - `lib/core/l10n/app_en.arb`
- Manage language switching and storage via `LocaleNotifier` (Riverpod) or `LocaleCubit` (Bloc) persisting to `LocalStorageKeys.language`.
