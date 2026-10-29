# Tap Rules — Pressables, Feedback & Touch Targets

Guidelines for touch interactions, press feedback, accessibility targets, and tap behavior across Car Register.

---

## 1. Single Owner for Touch Interactions

Every tappable surface in the application must use `AppPressable` (`lib/core/widgets/app_pressable.dart`) or a dedicated button built upon it.

| Interaction Type | Recommended Widget |
|---|---|
| **Primary Action** | `AppPrimaryButton` |
| **Secondary Action** | `AppSecondaryButton` |
| **Text Action** | `AppTextButton` |
| **Icon Action** | `AppIconButton` |
| **Custom Card / Row / Tile** | `AppPressable` |

---

## 2. Feedback Effect: Opacity Fade Only

Car Register uses a unified, modern opacity-fade interaction across the app:

| Parameter | Value | Source |
|---|---|---|
| **Effect Type** | Opacity fade | `AppPressable` |
| **Pressed Opacity** | `0.55` | `AppConstants.opacityPressed` |
| **Fade In Duration** | `70 ms` | `AppConstants.pressFadeIn70ms` |
| **Fade Out Duration** | `150 ms` | `AppConstants.pressFadeOut150ms` |
| **Minimum Visible Duration** | `100 ms` | `AppConstants.pressMinVisible100ms` |
| **Ripples / Water Splashes** | **None** | `NoSplash.splashFactory` in `AppTheme` |

### Card vs Button Rule

- **Buttons:** The whole button fades as one unit (background, border, icon, and label).
- **Cards, Rows & Tiles:** The card background and border remain solid. Only the interior content (text and icons) fades when pressed. This prevents seeing the underlying scaffold through the card surface during a press.

```dart
// ✅ Card: Surface remains solid, content fades
Container(
  decoration: BoxDecoration(
    color: AppColors.secondaryScaffoldBackgroundColor,
    borderRadius: BorderRadius.circular(AppSize.r12),
  ),
  child: AppPressable(
    onPressed: onTap,
    child: Padding(
      padding: EdgeInsets.all(AppSize.p16),
      child: Row(
        children: [
          Text(brochure.number, style: AppTextStyles.font16W700Primary),
        ],
      ),
    ),
  ),
)
```

---

## 3. Minimum Touch Target (48 px)

- Every interactive element must provide a touch target of at least **48 × 48 px** (`AppConstants.minTapTarget`).
- For small visual glyphs (such as 16 px or 24 px icons), wrap them with `AppIconButton` or ensure padding expands the hit area to at least 48 px.

---

## 4. Keyboard & Focus

- A text field requests focus the first time its screen appears (`autofocus: true`): home, search, and access code open with the keyboard ready.
- After that, only the user reopens the keyboard. Delete, dialogs, validation errors, and navigation must never bring it back.
- Always dismiss with `context.unfocus()` or the field's `FocusNode.unfocus()`. Both move focus to the enclosing scope; unfocusing the scope itself (`FocusScope.of(context).unfocus()`) leaves the field remembered, so Flutter restores it — and the keyboard — when a dialog closes.
