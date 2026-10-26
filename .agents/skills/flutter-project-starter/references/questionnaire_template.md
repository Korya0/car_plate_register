# Project Customization Questionnaire

This template is used by the AI agent upon receiving a project specification (`PROJECT_SPECIFICATION.md` or user brief). The agent must generate `QUESTIONS.md` in the project root to clarify all architectural decisions before writing any code.

---

## 1. Build Flavors
- **Options:**
  1. `Single Environment` (Default for single-client or offline apps).
  2. `Development + Production` (Distinct app names, `.dev` application ID suffix).
  3. `Development + Staging + Production`.
> **Agent Question:** Does the project require multi-environment build flavors (e.g. dev/prod)?

---

## 2. State Management & Dependency Injection
- **Options:**
  1. `Riverpod` (Recommended: ProviderScope, overrides, synchronous DI, AsyncValue in UI).
  2. `Bloc / Cubit + GetIt` (GetIt service locator, AppBlocObserver).
> **Agent Question:** Which state management & DI solution do you prefer? (Default: Riverpod)

---

## 3. Backend & Cloud Integration
- **Options:**
  1. `REST API (Dio + Retrofit + Interceptors)` with `--dart-define=USE_FAKE_API` toggle.
  2. `Firebase` (Cloud Firestore, Core, Security Rules).
  3. `Supabase` (PostgreSQL, Auth, Realtime).
  4. `Offline / Local Only` (No cloud backend).
> **Agent Question:** How will the app communicate with the cloud or backend?

---

## 4. Authentication Architecture
- **Options:**
  1. `No Traditional Auth` (Shared Access PIN, device token, or direct backend record without user auth sessions).
  2. `Full Authentication Flow` (Login, Register, Forgot Password, and GoRouter AuthGuard).
> **Agent Question:** Does the application require user authentication, or a PIN/device-code only?

---

## 5. Theme, Colors & System UI
- **Options:**
  1. `Single Theme` (Direct `AppColors.*` access, no ThemeExtension overhead).
  2. `Dual Theme (Light & Dark)` (AppColorsExtension, ThemeMode toggle persisted in storage).
- **Edge-to-Edge:** Enabled by default (transparent status bar & navigation bar).
- **Typography:** System fonts (default) vs Custom variable font (e.g. Cairo).
> **Agent Question:** Single theme or Light/Dark dual themes? What are the brand colors (Scaffold, Surfaces, Primary, Secondary)? System or custom font?

---

## 6. Localization & Numerals
- **Options:**
  1. `Arabic Only (Modern Simplified Fusha)` via `AppStrings` with Western digits (`0-9`).
  2. `Multi-Language (Arabic + English)` via Flutter ARB (`app_ar.arb`, `app_en.arb`) with LocaleNotifier/LocaleCubit.
> **Agent Question:** Is the app Arabic-only or multi-language? Note: Western digits (0-9) are mandatory for numerical accuracy.

---

## 7. Local Storage & Database
- **Options:**
  1. `Drift (SQLite)` for relational tables, queries, search, and offline-first sync.
  2. `No Drift` (Lightweight storage only).
- **Storage Abstractions:**
  - `LocalStorage` (SharedPreferences) for non-sensitive preferences and flags.
  - `SecureStorage` (FlutterSecureStorage / Keystore) for encrypted PINs and auth tokens.
> **Agent Question:** Does the app require a local Drift (SQLite) database, or is key-value storage sufficient?

---

## 8. App Identity & Package Name
- Display Name: (e.g. `Car Register`).
- Application ID / Package Name: (e.g. `com.example.car_register`).
> **Agent Question:** What is the exact app title and target Android/iOS package name?
