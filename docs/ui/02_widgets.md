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
| **In-App Toast** | `AppToast` | Top overlay, optional action |

### Home Widget Inventory (Located in `lib/features/home/presentation/widgets/`)

Shared by the home and search screens (root of `widgets/`):

| Need / Purpose | Widget | Key Parameters |
|---|---|---|
| **Indexed Header Label** | `HomeIndexedLabel` | `index`, `label` |
| **Page Header** | `HomePageHeader` | `watermarkText`, `child`, `fillWatermarkHeight` |
| **Page Header Curve** | `HomePageHeaderCurve` | — |
| **Brochure List Body** | `BrochureListBody` | `entries`, `query`, `emptyState`, `noMatchesState`, `onConfirmDelete`, `onConfirmDeleteMany`, `onDelete` |
| **Brochure Card** | `HomeBrochureEntryRow` | `brochure`, `query`, `onPressed`; `.loading()` |
| **Empty State** | `HomeBrochureEmptyState` | `title`, `subtitle`, `onAdd` |

Home-only (`widgets/home/`):

| Need / Purpose | Widget | Key Parameters |
|---|---|---|
| **Home Header Content** | `HomeHeaderContent` | `numberController`, `numberFocusNode`, `onSave`, `onSearch` |

Search-only (`widgets/search/`):

| Need / Purpose | Widget | Key Parameters |
|---|---|---|
| **Search Header Content** | `SearchHeaderContent` | `searchController`, `searchFocusNode`, `onSearchChanged`, `onSubmit`, `onBack` |

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

### Brochure Cards

The home feature owns brochure entry, while search is a separate route inside the
same feature. Brochures render as bordered cards in a four-column grid
(`AppSliverGrid.count`), so the unused width of a phone screen is used instead of
leaving a single column stretched. Cards have no dividers and no fill: they are outlined
over the page background, and the border, radius, and padding live in
`HomeBrochureEntryRow`, which also holds
`HomeBrochureEntryRow.loading()` so placeholders sit in the same card layout as
real entries. `BrochureListBody` renders the shared loading, error, empty,
no-match, grid, and selection states for both screens.

Saved brochures render below the header on both screens. A single tap on a card
opens its delete confirmation dialog, and a confirmed delete removes the card
silently — no toast. A long press starts selection mode instead: every card shows
a selection circle in its top start corner, drawn as an overlay so the card and
its number keep the same size and position, tapping a card toggles it, and a bar
above the grid offers
«اختيار الكل» / «إلغاء الكل» plus a delete action for the selected cards (with its
own confirmation and count). Closing the bar leaves selection mode. Cards show
the number only (no date or time), do not swipe, and carry no delete icon. There is no selection mode, no select-all, no delete-all, and no undo. The home screen
shows the empty state without an add action because the entry field is already on
screen. Search filters the same brochure store and never renders a results-count
label. `HomeBrochureEmptyState` supports a title-only mode for searches with no
matches by omitting `subtitle` and `onAdd`.
