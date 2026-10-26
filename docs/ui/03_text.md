# Text Rules — AppStrings, Wording & Typography

**Single source of truth** for every user-facing string and text rule in Car Register.

---

## 1. The Core Architecture

```text
Widget  ──►  AppStrings.*           ← Single source of truth for Arabic copy
             lib/core/constants/app_strings.dart

Widget  ──►  AppTextStyles.*        ← Single source of truth for typography
             lib/core/theme/app_text_styles.dart
```

- **Arabic is the only supported language.** There is no translation file (`.arb`), no `context.l10n`, and no multi-locale setup.
- **Modern Simplified Fusha (فصحى مبسطة):** Wording must be clear, formal, and accessible across the Arab world. No regional dialects or slang.
- **Western Numerals Only:** All numbers and digits must appear in Western Arabic format (`0`, `1`, `2`, `3`, `4`, `5`, `6`, `7`, `8`, `9`). Never use Eastern Arabic/Hindi numerals (`٠`, `١`, `٢`, `٣` ...).

---

## 2. The Hard Rules

> **Every user-facing string must live in `AppStrings`. No raw string literals in UI widgets.**

```dart
// ✅ Correct
Text(AppStrings.appName)
Text(AppStrings.emptyTitle)
Text(AppStrings.confirmDeleteMessage)

// ❌ Forbidden
Text('سجل البروشورات')
Text('مفيش أرقام مسجلة')
Text('Delete')
```

---

## 3. Numbers in the App

- Car brochure numbers can be from 1 to 4 digits.
- Leading zeros must be preserved (`007`, `042`, etc.), which is why brochure numbers are stored and handled as `String`, not integer.
- The UI must always display brochure numbers and counts using Western numerals (`0-9`).

---

## 4. Typography & Styling

- Every `Text` widget must use a semantic style from `AppTextStyles`:
  ```dart
  Text(
    AppStrings.homeTitle,
    style: AppTextStyles.font20W700Primary,
  )
  ```
- Line heights are controlled via `AppConstants.lineHeightTitle` (1.3) and `lineHeightBody` (1.5).
- Use `overflow: TextOverflow.ellipsis` alongside `maxLines: AppConstants.maxOneLine` or `maxTwoLines` whenever text could overflow its container.
