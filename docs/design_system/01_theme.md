# Design Theme — Colors, Typography, Icons & Assets

**Single source of truth.** Read this file before adding or changing any color, text style, icon, or asset.

- Colors: `lib/core/theme/app_colors.dart`
- Theme configuration: `lib/core/theme/app_theme.dart`
- Typography: `lib/core/theme/app_text_styles.dart`
- Icons: Flutter `Icons.*` directly (no icon wrapper class)
- Assets: `lib/core/constants/app_assets.dart`
- Sizes & Spacing: [`02_tokens.md`](02_tokens.md)

---

## 1. Core Rules

- **Single theme only:** Car Register runs on a single unified theme with a dark navy and brand red palette. There is no light/dark mode switching.
- **Direct color access:** All colors are accessed directly through `AppColors.*` (e.g. `AppColors.primary`, `AppColors.scaffoldBackgroundColor`). There is no `ThemeExtension`, no `context.color`, and no `MyColors`.
- **Never use raw color values in UI code:** No `Color(0x...)` or random hex codes inside widgets. Every color must come from `AppColors`.
- **System / Flutter fonts:** No custom downloaded font files (e.g. Cairo, Amiri, or Tajawal). We rely entirely on Flutter's default typography engine.
- **System / Flutter icons:** Use `Icons.*` directly from Flutter's Material icons package.
- **Every color token has a purpose comment** describing where and when it is used.

```dart
// ✅ Correct
color: AppColors.primary
color: AppColors.textPrimary
color: AppColors.dividerColor

// ❌ Forbidden
color: Color(0xFFD91B21)
color: Colors.red
color: context.color.primary
```

---

## 2. Approved Color Palette (`AppColors`)

All colors are defined as `static const Color` in `AppColors`:

| Token | Hex Value | Usage |
|---|---|---|
| `scaffoldBackgroundColor` | `#050D14` | Very dark navy — screen background |
| `secondaryScaffoldBackgroundColor` | `#091E30` | Logo navy — cards, sheets, dialogs, surfaces |
| `primary` | `#D91B21` | Logo red — primary brand action & highlight |
| `secondary` | `#1F5C8F` | Steel blue — secondary brand accent |
| `textPrimary` | `#FFFFFF` | Main readable text |
| `textSecondary` | `#9AA3AB` | Light gray supporting text, readable on dark navy |
| `textDisabled` | `#636C74` | Disabled text / muted labels |
| `iconPrimary` | `#D91B21` | Default brand icon color |
| `iconSecondary` | `#9AA3AB` | Supporting icon color |
| `iconDisabled` | `#636C74` | Disabled icon color |
| `textBrand` | `#EE3B41` | Lighter red for high contrast text on dark backgrounds |
| `textBrandSecondary` | `#4F93C9` | Lighter blue for high contrast text on dark backgrounds |
| `iconBrand` | `#D91B21` | Brand red icon |
| `iconBrandSecondary` | `#4F93C9` | Secondary brand blue icon |
| `surfaceBrand` | `#D91B21` | Brand red container fill |
| `surfaceBrandSecondary` | `#1F5C8F` | Secondary blue container fill |
| `surfaceSelected` | `#22161B` | Selected item background (dark red tint) |
| `surfaceDisabled` | `#0C141B` | Disabled item background |
| `borderBrand` | `#EC4A50` | Focused / active brand border |
| `dividerColor` | `#1E2F40` | Neutral subtle separators |
| `actionPrimary` | `#D91B21` | Primary CTA background |
| `actionSecondary` | `#1F5C8F` | Secondary CTA background |
| `textOnPrimary` | `#FFFFFF` | Text on red buttons / actions |
| `textOnSecondary` | `#FFFFFF` | Text on blue buttons / actions |
| `transparent` | `#00000000` | Transparent fills and gradients |
| `black` | `#000000` | Shadows and scrims base |

---

## 3. Typography — `AppTextStyles`

- File location: `lib/core/theme/app_text_styles.dart`
- Uses system default fonts — no asset font loading required.
- Font sizes come from `AppSize.f*` tokens (`AppSize.f12`, `f14`, `f16`, `f20`, `f32`).
- Line heights come from `AppConstants.lineHeightBody` and `lineHeightTitle`.
- Text styles are accessed through static getters on `AppTextStyles`.

### Naming Pattern

```text
font{Size}W{Weight}{Role}
```

Examples:
- `font12W500Secondary`
- `font12W700Brand`
- `font14W500Primary`
- `font14W700OnPrimary`
- `font16W500Primary`
- `font16W700Primary`
- `font20W700Primary`
- `font32W800Brand`

**Rules:**
- Never create inline `TextStyle(...)` inside UI widgets.
- Never use `.copyWith(...)` on text styles inside widgets unless overriding only a non-color layout parameter.
- Always choose the semantic style that represents the role of the text.

---

## 4. Icons

- Use Flutter's standard `Icons.*` directly (e.g. `Icons.add`, `Icons.delete_outline`, `Icons.search`, `Icons.arrow_back_ios_new`).
- Size icons using `AppSize.icon*` tokens (`icon16`, `icon24`, `icon32`, `icon48`).
- Color icons using `AppColors.iconPrimary`, `AppColors.iconSecondary`, etc.

---

## 5. Assets

- Defined centrally in `lib/core/constants/app_assets.dart`.
- Categorized by type:
  - `AppAssets.appIcon`: Native app icon (`assets/native/app_icon.png`).
- Never hardcode asset path strings directly inside widgets.

---

## 6. Language & Numerals

- **Arabic only:** All user-facing strings are in Modern Simplified Fusha (فصحى مبسطة) and reside in `AppStrings` (`lib/core/constants/app_strings.dart`).
- **Western Numerals:** All displayed digits must be Western Arabic numerals (`0`, `1`, `2`, `3` ... `9`), **never** Eastern Arabic numerals (`٠`, `١`, `٢` ...).
- **RTL by default:** The entire app runs with `TextDirection.rtl` configured in `CarRegisterApp`.
