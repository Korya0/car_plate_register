# Layout Rules — Screen Shell, Alignment, Direction

How a screen is laid out and how it stays correct in an always-RTL Arabic Flutter application.

Colors, sizes, and text styles are in [`../design_system/01_theme.md`](../design_system/01_theme.md) and [`../design_system/02_tokens.md`](../design_system/02_tokens.md).
Strings and wording are in [`03_text.md`](03_text.md).

---

## 1. Screen Shell

**Every route-level screen (`View`) uses `CustomScrollView`.** There is one primary template:

```dart
Scaffold(
  body: CustomScrollView(
    slivers: [
      const CommonSliverAppBar(title: AppStrings.homeTitle),
      AppSliverList(
        padding: AppSize.shp,
        itemCount: brochures.length,
        itemBuilder: (context, index) => BrochureCard(brochure: brochures[index]),
      ),
      SliverToBoxAdapter(child: AppGap.h(AppSize.sbp)),
    ],
  ),
)
```

### Screens Without an App Bar

The safe area lives **inside** the scrollable as a sliver (`SliverSafeArea`). Never wrap the outer `CustomScrollView` with `SafeArea`.

```dart
Scaffold(
  body: CustomScrollView(
    slivers: [
      SliverSafeArea(
        bottom: false, // The bottom inset comes from the trailing gap sliver
        sliver: AppSliverList(
          padding: EdgeInsets.only(top: AppSize.stp),
          itemCount: items.length,
          itemBuilder: (context, index) => ItemWidget(item: items[index]),
        ),
      ),
      SliverToBoxAdapter(child: AppGap.h(AppSize.sbp)),
    ],
  ),
)
```

### Overscroll (Android Stretch)

The Android 12+ overscroll **stretch** is a platform `MaterialScrollBehavior` indicator (`StretchingOverscrollIndicator`), **not** a `CustomScrollView` layout bug. It is disabled globally in `lib/core/theme/app_scroll_behavior.dart` and wired in `lib/app.dart`:

```dart
scrollBehavior: const AppScrollBehavior(),
```

Never work around it by replacing `CustomScrollView` or by changing scroll physics per screen.

---

## 2. RTL Directionality

- The application automatically derives `TextDirection.rtl` from the Arabic locale (`Locale('ar')`) and localizations delegates configured at the application root (`CarRegisterApp`).
- All alignment and padding must respect bidirectional rules:
  - Prefer `EdgeInsetsDirectional` when asymmetry is required (e.g., `EdgeInsetsDirectional.only(start: AppSize.p16)`).
  - Use `AlignmentDirectional` over `Alignment` for directional items.
  - Back buttons, navigation icons, and arrows: use `Icons.arrow_back_ios_new` or standard directional glyphs that correctly mirror in RTL.

---

## 3. Spacing with `AppGap`

- Never use raw `SizedBox(width: ...)` or `SizedBox(height: ...)` for visual spacing.
- Use `AppGap.h(...)` for vertical spacing and `AppGap.w(...)` for horizontal spacing.
- Pass tokens from `AppSize.p*`:

```dart
Column(
  children: [
    const TitleWidget(),
    AppGap.h(AppSize.p12),
    const SubtitleWidget(),
  ],
)
```

---

## 4. Screen-Level Views

- **Naming:** Every full screen is suffixed with `View` (e.g. `HomeView`, `SettingsView`, `BrochuresView`). The suffixes `Page` and `Screen` are strictly forbidden.
- **Responsibility:** A `View` coordinates layout and watches Riverpod providers. It does not perform network calls or database writes directly.
- **Max Content Width:** On wide screens (tablets), content should be constrained to `AppSize.contentMaxWidth` (640) to prevent stretched inputs or overly wide cards.
