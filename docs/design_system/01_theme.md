# Design Theme — Colors, Typography, Icons & Assets

**Single source of truth.** Read this file before adding or changing any color, text style, icon, or asset.

- Colors: `lib/core/theme/app_colors.dart`
- Theme configuration: `lib/core/theme/app_theme.dart`
- Typography: `lib/core/theme/app_text_styles.dart`
- Font family & weights: `lib/core/theme/app_font.dart`
- Icons: Flutter `Icons.*` directly (no icon wrapper class)
- Assets: `lib/core/constants/app_assets.dart`
- Sizes & Spacing: [`02_tokens.md`](02_tokens.md)

---

## 1. Core Rules

- **Single theme only:** Car Register runs on a single light theme with a white background, pale neutral surfaces, and brand red/navy accents. There is no light/dark mode switching.
- **Direct color access:** All colors are accessed directly through `AppColors.*` (e.g. `AppColors.primary`, `AppColors.scaffoldBackgroundColor`). There is no `ThemeExtension`, no `context.color`, and no `MyColors`.
- **Never use raw color values in UI code:** No `Color(0x...)` or random hex codes inside widgets. Every color must come from `AppColors`.
- **Single custom font:** The app uses only the Cairo variable font (`assets/fonts/cairo/Cairo-VariableFont_slnt,wght.ttf`), registered in `pubspec.yaml` and applied through `AppFont.family`. No other font family is allowed.
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
| `scaffoldBackgroundColor` | `#FFFFFF` | White — screen background |
| `secondaryScaffoldBackgroundColor` | `#F4F6F8` | Pale gray-blue — cards, sheets, dialogs, surfaces |
| `primary` | `#D91B21` | Logo red — primary brand action & highlight |
| `secondary` | `#091E30` | Logo navy — secondary brand accent |
| `textPrimary` | `#091E30` | Main readable text |
| `textSecondary` | `#636C74` | Gray supporting text |
| `textDisabled` | `#A7AEB5` | Disabled text / muted labels |
| `iconPrimary` | `#D91B21` | Default brand icon color |
| `iconSecondary` | `#636C74` | Supporting icon color |
| `iconDisabled` | `#A7AEB5` | Disabled icon color |
| `textBrand` | `#C4191F` | Darker red for readable brand text on white |
| `textBrandSecondary` | `#091E30` | Navy brand text |
| `iconBrand` | `#D91B21` | Brand red icon |
| `iconBrandSecondary` | `#091E30` | Secondary brand navy icon |
| `surfaceBrand` | `#D91B21` | Brand red container fill |
| `surfaceBrandSecondary` | `#091E30` | Secondary navy container fill |
| `surfaceSelected` | `#FDECEC` | Selected item background (light red tint) |
| `surfaceDisabled` | `#EEF0F2` | Disabled item background |
| `borderBrand` | `#D91B21` | Focused / active brand border |
| `dividerColor` | `#E1E5E9` | Neutral subtle separators |
| `actionPrimary` | `#D91B21` | Primary CTA background |
| `actionSecondary` | `#091E30` | Secondary CTA background |
| `textOnPrimary` | `#FFFFFF` | Text on red buttons / actions |
| `textOnSecondary` | `#FFFFFF` | Text on navy buttons / actions |
| `transparent` | `#00000000` | Transparent fills and gradients |
| `black` | `#000000` | Shadows and scrims base |

---

## 3. Typography — `AppTextStyles`

- File location: `lib/core/theme/app_text_styles.dart`
- Uses the Cairo variable font only — loaded from the bundled asset.
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

### Font Weights — `AppFontWeight`

The only approved weights live in the `AppFontWeight` enum. Use it instead of
raw `FontWeight.*` values:

| Enum value | Flutter value |
|---|---|
| `AppFontWeight.regular` | `FontWeight.w400` |
| `AppFontWeight.medium` | `FontWeight.w500` |
| `AppFontWeight.bold` | `FontWeight.w700` |
| `AppFontWeight.extraBold` | `FontWeight.w800` |

- Read the Flutter value through `.value`: `AppFontWeight.extraBold.value`.
- `AppTextStyles` is the only place that reads the enum. Widgets keep using
  `AppTextStyles.*`.
- A new weight is added to the enum, never written inline.

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
