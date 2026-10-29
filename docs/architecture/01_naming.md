# Naming Rules

## 1. Files & folders

| Element | Convention | Example |
|---|---|---|
| Dart file | `snake_case.dart` | `brochure_list_notifier.dart` |
| Feature folder | `snake_case` | `brochures/` |
| Data folders | `repositories/` · `data_sources/` · `models/` · `mappers/` · `services/` · `constants/` | — |
| Domain folders | `entities/` · `repositories/` · `use_cases/` · `params/` · `validators/` · `enums/` | — |
| Presentation folders | `providers/` · `views/` · `widgets/` | — |
| Feature DI file | `<feature>_providers.dart` | `brochures_providers.dart` |
| Asset | `snake_case`, inside a category folder | `assets/native/app_icon.png` |
| Generated file | follows its generator's convention; never edit by hand | `*.g.dart` |
| Test | `<file>_test.dart` | `brochure_list_notifier_test.dart` |

- Write `repositories`, not `repos`.
- `providers/` is the only presentation state folder. There is no `cubits/`,
  `blocs/`, or `controllers/`.
- Core dependencies live in `core/di/app_providers.dart`. A feature's own
  dependency wiring lives in `features/<feature>/di/<feature>_providers.dart`.

## 2. Classes

`PascalCase`. An implementation defaults to `<Contract>Impl`; a descriptive name is
allowed only when it clarifies the technology (`FirestoreSyncService`,
`DriftBrochureDataSource`).

| Element | Rule | Example |
|---|---|---|
| Screen-level view | `View` suffix, **never** `Page` or `Screen` | `HomeView`, `SearchView`, `AccessCodeView` |
| Widget | named by responsibility; `Widget` suffix not required | `BrochureCard` |
| Riverpod notifier | `Notifier` suffix | `BrochureListNotifier` |
| Notifier state | `<Feature>State`; variants `extends` it | `BrochureListState` → `BrochureListLoaded` |
| Async state | `AsyncValue` is used directly; no custom wrapper | `AsyncValue<List<Brochure>>` |
| Entity | `Entity` suffix | `BrochureEntity` |
| Model | `Model` suffix | `BrochureModel` |
| Repository | no `I`, full `Repository`, impl `Impl` | `BrochureRepository` → `BrochureRepositoryImpl` |
| Data source | no `I`, `Local`/`Remote` + `DataSource`, impl `Impl` | `BrochureLocalDataSource` → `BrochureLocalDataSourceImpl` |
| Use case | `UseCase` suffix | `AddBrochureUseCase` |
| Service | no `I`, `Service` suffix, impl `Impl` | `SyncService` → `SyncServiceImpl` |
| Constant / theme class | `App` prefix | `AppSize`, `AppTextStyles`, `AppColors` |
| DI provider | `lowerCamelCase` ending in `Provider` | `brochureRepositoryProvider` |
| Route class | `PascalCase` | `AppRouter`, `AppRoutes` |
| API client | `ApiClient` suffix | `BrochureApiClient` |
| Interceptor | `Interceptor` suffix | `DeviceHeaderInterceptor` |
| Failure | `Failure` suffix, sealed | `NetworkFailure`, `SyncFailure` |
| Result | `Result<T>` only | `Result<BrochureEntity>` |

- **No `My*` names.** Use the `App` prefix instead: `AppColors`, not `MyColors`.
- No `Cubit`, `Bloc`, `GetIt`, `sl`, or `setup*Dependencies` naming — Riverpod
  providers own dependency wiring.
- Use an abstract contract (and an `Impl`) only when substitution or testing
  requires it.
- States: don't force four. Model the real conditions (empty, syncing, offline,
  error). `Loaded` and `Success` are not interchangeable.
- `AsyncValue` is reserved for presentation. Data and domain return `Result<T>`
  (see `docs/architecture/02_logging_and_errors.md`).

## 3. Variables & identifiers

- **Private:** `_lowerCamelCase` — `_repository`, `_preferences`.
- **Variables, functions, getters, parameters:** `lowerCamelCase`; a function
  starts with a verb — `addBrochureNumber()`.
- **Boolean:** reads as a condition — `isSyncing`, `hasPendingWrites`,
  `canUndoDelete`.
- **Constant:** `lowerCamelCase`, never `UPPER_SNAKE_CASE` — `defaultPageSize`.
  `const` for compile-time, `final` for assigned once at runtime.
- **Route path:** `kebab-case` string — `'/brochure-details'`; its Dart holder is
  `lowerCamelCase` — `brochureDetailsPath`.
- **Storage key:** `snake_case` — `shared_access_device_id`. Renaming a key breaks
  access to already-stored data.
- **Database table:** plural `snake_case` — `brochures`.
- **Database column:** `snake_case` — `brochure_number`, `created_at`.
- **Dart model field:** `lowerCamelCase` — `brochureNumber`, `createdAt`. Drift
  maps it to the snake_case column explicitly.
- **Enum:** type `PascalCase`, values `lowerCamelCase` — `SyncStatus.pending`.
- **Mixin / extension / typedef:** `PascalCase` — `NumberFormatting`,
  `BrochureCallback`.
- **Provider:** `lowerCamelCase` + `Provider` — `appLocalStorageProvider`.
- **Notifier method:** a verb — `add`, `delete`, `retry`, `clearAll`.

## 4. Constructor

- A static-only utility class uses a private constructor to prevent
  instantiation:

```dart
class AppSize {
  AppSize._();

  static double get p16 => _scaled(16);
}
```

- An instantiable class gets a private constructor only for a specific reason.
- Widgets use `const` constructors wherever possible.
- A Riverpod `Notifier` starts with `super()` and exposes `build()` as its only
  initialization entry point.

## 5. Imports

- Every project import is absolute:
  `import 'package:car_register/core/theme/app_colors.dart';`
- No relative imports that cross a feature boundary.
- Order: `dart:` → `package:` (Flutter, third-party, project) → blank line between
  groups.

## 6. Examples — Car Register

| Wrong | Right |
|---|---|
| `HomePage` | `HomeView` |
| `SettingsScreen` | `SettingsView` |
| `BrochuresCubit` | `BrochureListNotifier` |
| `SetupBrochuresDependencies(sl)` | `brochureRepositoryProvider` |
| `MyColors` | `AppColors` |
| `brochureNumber` column in Dart | `brochureNumber` field + `brochure_number` column |
