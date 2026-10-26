# Project Documentation Generator Guide

When executing this skill, the AI agent **must generate and customize the 9 standard architecture and UI rule files** inside the `docs/` folder in the project root. Every file must be tailored specifically to the project's chosen architecture, state management, colors, and features:

---

## The 9 Mandatory Rule Files

### 1. `docs/architecture/01_naming.md`
- File and folder conventions (`snake_case.dart`).
- Screen naming: **`View` suffix only**, strictly forbid `Page` or `Screen`.
- Prefix rules: **Forbid `My` prefix**, always use `App` (e.g. `AppColors`, not `MyColors`).
- If **Riverpod**: `Notifier` suffix for state holders, `Provider` suffix for instances, `providers/` folder.
- If **Cubit**: `Cubit` and `State` suffixes, `cubits/` folder.
- Feature DI files: `<feature>_providers.dart` or `<feature>_di.dart`.

### 2. `docs/architecture/02_logging_and_errors.md`
- Single logging owner: The repository or data source logs an error once; views never log.
- Forbid raw `print` or `debugPrint`; use `AppLogger`.
- UI error strings: Must be Arabic, safe, sourced from `AppStrings`; never expose raw platform errors or stack traces to users.
- Result architecture: Data/Domain return `Result<T>` (`Success` or `FailureResult`); Presentation consumes `AsyncValue<T>` (Riverpod) or States (Cubit).
- Document crash reporting policy (e.g. Crashlytics disabled in initial baseline).

### 3. `docs/architecture/03_code_conventions.md`
- Shared code in `lib/core/` if used in 2+ locations.
- **No cross-feature imports:** Features are isolated vertical slices.
- Comments: Short English comments; **no comments above class declarations (including Views)**.
- **YAML Exception:** Banner sections (`# ----------`) are allowed and required in YAML, but forbidden in Dart.
- File length ceiling: Max 300 lines per Dart file. Forbid `_buildX()` helper methods returning widgets; extract widget classes instead.

### 4. `docs/design_system/01_theme.md`
- Document the chosen theme model (Single Theme vs Dual Light/Dark).
- Canonical color values in `AppColors` with hex codes and purpose comments.
- Access rules: Direct `AppColors.*` for single theme, or `AppColorsExtension` via `context.colors` for dual themes.
- Typography: System default fonts vs custom variable font files.
- Icons: Flutter `Icons.*` directly with semantic sizing.

### 5. `docs/design_system/02_tokens.md`
- Dynamic responsive metrics via `AppSize` (`_shortestSide / 375` clamped `[0.8× … 1.3×]`).
- Durations, opacities, and line height limits via `AppConstants`.
- Input validation specifications via `AppValidators`.

### 6. `docs/ui/01_layout.md`
- Screen shell layout: `CustomScrollView` + slivers (`CommonSliverAppBar`, `AppSliverList`, `AppSliverGrid`).
- Safe areas placed inside scrollables (`SliverSafeArea`), never wrapping `CustomScrollView`.
- Directionality rules: `TextDirection.rtl` for Arabic, bidirectional padding (`EdgeInsetsDirectional`).
- Tablet maximum content constraint (`AppSize.contentMaxWidth = 640`).

### 7. `docs/ui/02_widgets.md`
- Flat widget architecture: Shared widgets reside directly in `lib/core/widgets/` without subdirectories.
- Inventory of the 20 shared core widgets and their usage contracts.
- Prohibition of re-implementing existing core widgets.

### 8. `docs/ui/03_text.md`
- Single source of truth for text copy: `AppStrings` (or `AppLocalizations` if multi-language).
- Language standard: Modern Simplified Fusha (فصحى مبسطة) without colloquial dialects.
- Numerals: Western digits (`0-9`) exclusively across all UI strings and databases.
- Semantic styling from `AppTextStyles`.

### 9. `docs/ui/04_tap.md`
- Single interaction owner: `AppPressable` with opacity fade to `0.55` without splash ripple.
- Buttons fade entirely; cards fade interior content while surface stays solid.
- Minimum touch target: 48×48 px (`AppConstants.minTapTarget`).

---

## 10. `docs/PROJECT_SPECIFICATION.md`
- The agent must update the project specification to mirror approved technical choices (correct state management, backend, database, and authentication policy).
