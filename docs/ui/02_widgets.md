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
| **Primary Action Button** | `AppPrimaryButton` | `label`, `onPressed`, `isLoading`, `expand` |
| **Secondary Action Button** | `AppSecondaryButton` | `label`, `onPressed`, `expand` |
| **Text Action Button** | `AppTextButton` | `label`, `onPressed`, `textStyle`, `padding`, `expand` |
| **Icon Button** | `AppIconButton` | `icon`, `onPressed`, `tooltip`, `color`, `size`, `onLongPress` |
| **Tap / Press Feedback** | `AppPressable` | `child`, `onPressed`, `fadeOpacity` |
| **Text Input** | `AppTextField` | `controller`, `hint`, `validator`, `leading`, `trailing`, keyboard and visual customization, `keepKeyboardOpenOnSubmitted` |
| **Section Header** | `AppSectionHeader` | `title`, `trailing` |
| **Dividers & Gaps** | `AppDivider`, `AppGap` | `AppGap.h(...)`, `AppGap.w(...)` |
| **Empty State** | `AppEmptyView` | `title`, `message` |
| **Error State** | `AppErrorView` | `message`, `onRetry` |
| **Sliver App Bar** | `CommonSliverAppBar` | `title`, `onBackPressed`, `actions`, `hasBackButton`, `isPinned` |
| **Sliver List** | `AppSliverList` | `itemCount`, `itemBuilder`, `separatorBuilder`, `padding` |
| **Sliver Grid** | `AppSliverGrid` | `itemCount`, `itemBuilder`, `maxCrossAxisExtent` / `crossAxisCount`, spacing |
| **Bottom Sheet** | `AppBottomSheet` | `context`, `child` |
| **Confirmation Dialog** | `CustomConfirmationDialog` | `context`, `title`, `message`, `confirmText`, `cancelText` |
| **In-App Toast** | `AppToast` | Top overlay, optional undo action |

### Home Widget Inventory (Located in `lib/features/home/presentation/widgets/`)

Shared by the home and search screens (root of `widgets/`):

| Need / Purpose | Widget | Key Parameters |
|---|---|---|
| **Indexed Header Label** | `HomeIndexedLabel` | `index`, `label` |
| **Page Header** | `HomePageHeader` | `watermarkText`, `child`, `fillWatermarkHeight` |
| **Page Header Curve** | `HomePageHeaderCurve` | — |
| **Brochure List Body** | `BrochureListBody` | `query`, `emptyState`, `noMatchesState`, `onDelete` |
| **Brochure Options Menu** | `BrochureOptionsMenu` | `onDeleteAll` |
| **Brochure Row** | `HomeBrochureEntryRow` | `brochure`, `query`, `onDelete`; `.loading()` |
| **Empty State** | `HomeBrochureEmptyState` | `title`, `subtitle`, `onAdd` |

Home-only (`widgets/home/`):

| Need / Purpose | Widget | Key Parameters |
|---|---|---|
| **Home Header Content** | `HomeHeaderContent` | `numberController`, `numberFocusNode`, `onSave`, `onSearch`, `onDeleteAll` |

Search-only (`widgets/search/`):

| Need / Purpose | Widget | Key Parameters |
|---|---|---|
| **Search Header Content** | `SearchHeaderContent` | `searchController`, `searchFocusNode`, `onSearchChanged`, `onBack`, `onDeleteAll` |

---

## 2. Directory Structure

- **All core widgets live flat in `lib/core/widgets/`.** Subdirectories inside
  the core `widgets/` folder are not used in this project.
- Feature-specific widgets live in their respective feature presentation folder:
  `lib/features/<feature>/presentation/widgets/`.
- Widgets shared by more than one screen of the same feature stay directly in
  that feature's `widgets/` folder.
- Widgets used by only one screen live in a screen-named subfolder, for example
  `lib/features/home/presentation/widgets/home/` and
  `lib/features/home/presentation/widgets/search/`.
- Brochure entry and search behavior belong to the home feature; search is a
  separate route, not a separate presentation feature. There is no bottom
  navigation bar.

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

### Brochure List Rows

The home feature owns brochure entry, while search is a separate route inside the
same feature. `HomeBrochureEntryRow.loading()` renders loading placeholders
inside the same row layout as real entries. Keep row spacing, alignment, and
separators in `HomeBrochureEntryRow` so loading and loaded lists stay visually
aligned. `BrochureListBody` renders the shared loading, error, empty, no-match,
and list states for both screens.

Saved brochures render below the header on both screens. The home screen shows
the empty state without an add action because the entry field is already on
screen. Search filters the same brochure provider list and never renders a
results-count label. `HomeBrochureEmptyState` supports a title-only mode for
searches with no matches by omitting `subtitle` and `onAdd`.
