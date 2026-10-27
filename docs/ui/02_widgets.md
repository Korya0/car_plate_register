# Widget Rules — Reuse, Decomposition, States, Structure

Guidelines for decomposing screens, implementing widgets, handling states, and maintaining code quality.

File naming is documented in [`../architecture/01_naming.md`](../architecture/01_naming.md).
Tokens are in [`../design_system/02_tokens.md`](../design_system/02_tokens.md).
Layout rules are in [`01_layout.md`](01_layout.md).

---

## 1. Reuse Before You Build

> **Before writing any custom widget or UI block, verify whether a reusable widget exists in `lib/core/widgets/`.**
> Re-inventing existing shared widgets (buttons, inputs, app bars, empty views, error views, dividers) is strictly forbidden.

### Core Widget Inventory (Located flat in `lib/core/widgets/`)

| Need / Purpose | Shared Widget | Key Parameters |
|---|---|---|
| **Primary Action Button** | `AppPrimaryButton` | `label`, `onPressed`, `isLoading`, `icon` |
| **Secondary Action Button** | `AppSecondaryButton` | `label`, `onPressed`, `isLoading`, `icon` |
| **Text Action Button** | `AppTextButton` | `label`, `onPressed` |
| **Icon Button** | `AppIconButton` | `icon`, `onPressed`, `tooltip`, `color` |
| **Tap / Press Feedback** | `AppPressable` | `child`, `onPressed`, `fadeOpacity` |
| **Text Input** | `AppTextField` | `controller`, `hint`, `validator`, `prefixIcon`, `keyboardType` |
| **Section Header** | `AppSectionHeader` | `title`, `actionLabel`, `onAction` |
| **Page Header** | `AppPageHeader` | `watermarkText`, `child` |
| **Page Header Curve** | `AppPageHeaderCurve` | — |
| **Dividers & Gaps** | `AppDivider`, `AppGap` | `AppGap.h(...)`, `AppGap.w(...)` |
| **Empty State** | `AppEmptyView` | `title`, `subtitle`, `icon`, `actionButton` |
| **Error State** | `AppErrorView` | `message`, `onRetry` |
| **Sliver App Bar** | `CommonSliverAppBar` | `title`, `leading`, `actions`, `pinned` |
| **Sliver List** | `AppSliverList` | `itemCount`, `itemBuilder`, `padding` |
| **Sliver Grid** | `AppSliverGrid` | `itemCount`, `itemBuilder`, `maxCrossAxisExtent` |
| **Bottom Sheet** | `AppBottomSheet` | `title`, `child` |
| **Confirmation Dialog** | `CustomConfirmationDialog`| `title`, `message`, `confirmText`, `cancelText`, `onConfirm` |
| **In-App Toast** | `AppToast` | `AppToast.show(context, message)` |
| **Navigation Shell** | `MainView`, `AppBottomNavBar` | `tabs`, `currentIndex`, `onTabSelected` |

---

## 2. Directory Structure

- **All core widgets live flat in `lib/core/widgets/`.** Subdirectories inside `widgets/` are not used in this project.
- Feature-specific widgets live in their respective feature presentation folder:
  `lib/features/<feature>/presentation/widgets/`

---

## 3. Widget Decomposition & Cleanliness

### No `_build*()` Widget Helper Methods

Extract separate widget classes instead of writing helper methods like `_buildHeader()` or `_buildList()` within a parent widget. Helper methods:
- Do not optimize element tree rebuilds.
- Cannot be made `const`.
- Pollute the parent build scope with excessive variables.

```dart
// ❌ Forbidden
Widget _buildCard(BrochureEntity item) {
  return Container(...);
}

// ✅ Correct: Extract a private or public widget class
class BrochureCard extends StatelessWidget {
  const BrochureCard({required this.brochure, super.key});
  final BrochureEntity brochure;

  @override
  Widget build(BuildContext context) { ... }
}
```

### File Size Limit

- Keep Dart widget files under **300 lines**.
- When a widget exceeds 300 lines, extract sub-components into dedicated files inside `presentation/widgets/`.

### Use `const` Everywhere Possible

- Mark constructors as `const` whenever all fields are immutable.
- Use `const` widget invocations in layout trees to prevent unnecessary rebuilds.
