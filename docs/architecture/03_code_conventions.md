# Code Conventions

## 1. Shared code

- Any reusable logic, utility, constant, extension, or helper used in **2+ places**
  goes in `core/`.
- Check `core/` before writing new shared code — never duplicate across features.
- **No cross-feature imports:** each feature is an isolated vertical slice; only
  `core/` is shared.
- `core/` never imports a feature. If core needs feature-aware behavior, the
  feature supplies it through a provider or a callback.
- Shared UI goes flat in `lib/core/widgets/`. This project does not use widget
  subfolders.

## 2. Comments

- Extremely short and consistent: a label or 1–4 words.
- **No comments above class declarations, including `View` classes.**
- In UI trees, label the `Header`, `Body`, and major sections.
- For widgets, use hierarchical comments to identify the widget and its main
  contents when useful, e.g. `// Info (number + date)`, followed by `// Number`
  and `// Date` for the nested elements when needed.
- In data and domain, put a short purpose comment above each method.
- Longer comments are allowed only when necessary to explain complex behavior or
  non-obvious decisions (a race, a sync rule, a platform quirk).
- Never use banners, separators, decorative blocks, or comments that merely
  restate the code.
- Comments are written in English. User-facing Arabic lives only in
  `AppStrings`.
- **YAML exception:** section banners and per-group comments are required in
  `pubspec.yaml` and other YAML files. They are not allowed in Dart.

```dart
// Header
const BrochuresHeader(),

// Body
Expanded(child: ...),
```

```dart
// Info (number + date)
const BrochureInfo(
  child: Column(
    children: [
      // Number
      NumberWidget(),

      // Date
      DateWidget(),
    ],
  ),
),
```

```dart
// Loads the cached list, then refreshes from Firestore.
Future<void> loadBrochures() async {}
```

## 3. Size & structure

- A Dart file stays under **300 lines**. Split by responsibility, not by line
  count.
- One public class per file unless the second class is a tiny private-partner
  widget used by the first.
- No `_buildX()` methods that return widgets. Extract a widget class instead.
- A method that needs more than ~3 levels of nesting is split.
- A `View` is a thin shell: layout + state switch. Business rules live in the
  notifier, use case, or repository.

## 4. Dart style

- `dart format .` before every hand-off; formatting is not a review topic.
- Trailing commas are required (`require_trailing_commas`).
- Single quotes (`prefer_single_quotes`).
- `const` constructors and `const` literals wherever possible.
- `final` for locals (`prefer_final_locals`).
- No `print`; use `AppLogger` (`avoid_print`).
- No `dynamic` unless a platform API forces it; cast at the boundary.
- Do not use `late` to silence initialization problems. Use it only when the
  value is guaranteed before first read (`AppSize._shortestSide` is the model).
- Prefer `switch` expressions over long `if/else` chains for sealed types.
- Prefer records for small private value groupings; do not invent a class for
  three fields that never travel.

## 5. Imports

- Project imports are absolute: `package:car_register/...`.
- Order: `dart:` → `package:` (Flutter, third-party, project). One blank line
  between groups.
- Never import a feature from another feature.
- Never import a `data/` or `domain/` file directly into a `View`. Go through a
  provider.

## 6. State & providers

- State is Riverpod. No Cubit, BLoC, GetIt, or `ChangeNotifier` for feature
  state.
- A view is a `ConsumerWidget` only when it reads state; otherwise it stays a
  `StatelessWidget`.
- Use `ref.watch` in `build`, `ref.read` in callbacks, and `ref.listen` for
  side effects (toasts, navigation).
- Select narrowly: `ref.watch(provider.select((s) => s.count))`.
- Do not create providers inside `build`.
- Do not pass `WidgetRef` into data or domain.

## 7. Errors

- Follow `docs/architecture/02_logging_and_errors.md`.
- A repository logs once, maps to `Failure`, returns `Result`.
- A view never sees a raw exception.

## 8. Generated files

- `*.g.dart`, `*.freezed.dart`, and other generated files are never edited by
  hand.
- Regenerate with the documented command and commit the generator config, not a
  manual patch.
- Generated files are excluded from analysis.

## 9. Tests

- Test the logic that can fail: validators, mappers, result/failure handling,
  repository mapping, notifier transitions, storage wrappers.
- Do not test Flutter framework behavior.
- A widget test covers the app shell and one real state branch, not every pixel.
- Tests use the same naming and folder shape as the source.
- A bug fix adds a test that fails before the fix.
- `flutter analyze` and `flutter test` must both pass before hand-off.

## 10. Hard stops

- No `Page` or `Screen` suffix.
- No `My*` prefix.
- No themes beyond the single approved theme.
- No `ThemeExtension` color lookup.
- No font family other than Cairo; no custom icon fonts.
- No authentication layer.
- No new `docs/` file for a rule; extend the existing nine.
