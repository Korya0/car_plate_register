# Tokens & Constants — AppSize, AppConstants, Validators

**Single source of truth** for every dimension, threshold, duration, and input validation rule in `lib/core/`.

Colors and text styles are documented in [`01_theme.md`](01_theme.md).

| File | Responsibility |
|---|---|
| `lib/core/constants/app_sizes.dart` | Every pixel value in the app (dynamically scaled) |
| `lib/core/constants/app_constants.dart` | Non-pixel values: durations, opacities, limits, constraints |
| `lib/core/utils/app_validators.dart` | Brochure number validation rules |

---

## 1. The Core Rule

> **Never write raw literal numbers in a widget. Every pixel dimension must come from `AppSize.*`; every duration, opacity, or line limit must come from `AppConstants.*`.**

```dart
// ✅ Correct
height: AppSize.h48
padding: AppSize.shp
maxLines: AppConstants.maxOneLine
duration: AppConstants.animationNormal300ms

// ❌ Forbidden
height: 48
padding: EdgeInsets.symmetric(horizontal: 16)
maxLines: 1
duration: Duration(milliseconds: 300)
```

---

## 2. `AppSize` — Scaled Pixel Tokens

### Principles

- `AppSize` values are **dynamic getters**, scaled based on screen width via `_shortestSide / 375` and clamped between `0.8×` and `1.3×` to ensure balanced rendering on compact devices, phones, and tablets.
- `AppSize.init(context)` is invoked once inside `CarRegisterApp`'s `MaterialApp.router` `builder`.
- Because they are dynamic getters and not compile-time constants, widgets that need them as default values define nullable parameters and resolve with `?? AppSize.*` inside `build()`.

### Token Families

| Family | Prefix | Available Tokens | Typical Use Cases |
|---|---|---|---|
| **Icons** | `icon*` | `icon16`, `icon20`, `icon24`, `icon32`, `icon48` | Icon sizes and icon button bounding boxes |
| **Padding & Spacing** | `p*` | `p4`, `p8`, `p12`, `p16`, `p20`, `p24`, `p32`, `p40`, `p48` | `AppGap`, `EdgeInsets`, card insets |
| **Fonts** | `f*` | `f12`, `f13`, `f14`, `f15`, `f16`, `f20`, `f24`, `f30`, `f32`, `f34`, `f40`, `f48`, `f150` | Sizing for `AppTextStyles` |
| **Heights** | `h*` | `h12`, `h18`, `h24`, `h40`, `h48`, `h56`, `h64`, `h150` | Heights of buttons, inputs, cards |
| **Widths** | `w*` | `w4`, `w24`, `w40`, `w48`, `w100`, `w200` | Specific widths, indicators, logos |
| **Radii** | `r*` | `r4`, `r8`, `r12`, `r16`, `r20`, `r24`, `r40`, `circularRadius` | `BorderRadius.circular(...)` on cards & buttons |
| **Borders & Dividers** | — | `borderWidth`, `borderWidthThick`, `dividerThickness`, `dividerHeight` | Borders, outlines, and horizontal dividers |

### Composite Layout Insets

- `AppSize.shp`: `EdgeInsets.symmetric(horizontal: p16)` — standard screen horizontal padding.
- `AppSize.stp`: `p16` — screen top padding.
- `AppSize.sbp`: `p40` — screen bottom padding (ensures scrollable content clears bottom sheets/bars).
- `AppSize.keyboardHeight(context)`: Resolves active keyboard inset.
- `AppSize.contentMaxWidth`: `640` — max width for center-constrained tablets/foldables.

---

## 3. `AppConstants` — Non-Pixel Thresholds

### Categories

1. **Locale:**
   - `arLocaleCode = 'ar'`
2. **Text Lines:**
   - `maxOneLine = 1`, `maxTwoLines = 2`, `maxThreeLines = 3`, `minLines3 = 3`, `maxLines5 = 5`
3. **Brochure Numbers:**
   - `brochureNumberMinLength = 1`
   - `brochureNumberMaxLength = 4`
   - `brochureListSkeletonCount = 3`
4. **Touch Target:**
   - `minTapTarget = 48` (unscaled accessibility floor)
5. **Line Heights:**
   - `lineHeightBody = 1.5`, `lineHeightTitle = 1.3`, `lineHeightDialog = 1.5`
6. **Animations & Durations:**
   - `pressFadeIn70ms`, `pressMinVisible100ms`, `pressFadeOut150ms`
   - `animationFast200ms`, `animationNormal300ms`, `animationSlow400ms`, `animationSlower500ms`
   - `searchDebounce300ms`, `toastDuration2s`, `hapticGap200ms`
   - `accessCodeStagger60ms`, `accessCodeLogoDelay500ms`, `accessCodeLogoSlide700ms`
   - `accessCodeDividerFillDelay500ms`, `accessCodeDividerFill700ms`
   - `homeHeaderCurveDelay300ms`, `homeHeaderCurveDraw900ms`
   - `slideOffsetNone = 0`, `slideOffsetSmall = 0.2`
7. **Opacities:**
   - `opacityPressed = 0.55`, `opacityDisabled = 0.45`
   - `opacityTransparent = 0`, `opacitySubtle = 0.2`, `opacitySoft = 0.3`, `opacityFaint = 0.4`, `opacityMuted = 0.5`, `opacityWatermark = 0.7`, `opacityFull = 1.0`
8. **Scale:**
   - `scaleCompleted = 0.98`, `scaleNormal = 1`
9. **Access Control:**
   - `accessCodeMaxLength = 10`
   - `accessCodeDemoValue = 'KORYA'` (temporary until the access API is wired)
10. **Elevation:**
   - `elevationNone = 0`

---

## 4. `AppValidators` — Input Validation Rules

### Brochure Number Validator (`AppValidators.brochureNumber`)

- **Field length:** 1 to 4 characters.
- **Allowed characters:** Western digits `0-9` only.
- **Leading zeros:** Valid and preserved (e.g., `007`, `0000`).
- **Whitespace:** Automatically trimmed before length and character verification.
- **Error messages:** Localized Arabic strings sourced from `AppStrings`:
  - Null or empty: `AppStrings.numberRequired`
  - Over 4 digits: `AppStrings.numberLength`
  - Non-digit or Arabic/Hindi digits: `AppStrings.numberDigitsOnly`
