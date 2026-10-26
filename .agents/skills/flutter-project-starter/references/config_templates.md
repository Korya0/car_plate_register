# Configuration Templates Blueprint

---

## 1. Standard `pubspec.yaml` Template

The `pubspec.yaml` file must strictly follow the `# ----------` section separators and comment conventions:

```yaml
# ----------
# Project Info
# ----------
name: {{PROJECT_NAME}}
description: "{{PROJECT_DESCRIPTION}}"
publish_to: 'none'
version: 1.0.0+1

# ----------
# Environment
# ----------
environment:
  sdk: ^3.13.3

# ----------
# Dependencies
# ----------
dependencies:
  flutter:
    sdk: flutter

  # Localization
  flutter_localizations:
    sdk: flutter

  # State Management & Navigation
  flutter_riverpod: ^3.4.3
  go_router: ^18.1.1

  # Local Database (Optional)
  drift: ^2.35.3
  drift_flutter: ^0.3.1

  # Local Storage & Security
  shared_preferences: ^2.5.3
  flutter_secure_storage: ^11.2.0
  local_auth: ^3.0.2

  # Backend & Cloud (Firebase or Supabase or Dio)
  firebase_core: ^5.1.0
  cloud_firestore: ^7.1.0

  # Connectivity & Utilities
  connectivity_plus: ^7.3.2
  intl: ^0.20.3

  # UI & Animations
  flutter_animate: ^4.5.2
  skeletonizer: ^3.0.0

# ----------
# Dev Dependencies
# ----------
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0

  # Code Generation
  build_runner: ^2.4.15
  drift_dev: ^2.35.3

  # Assets & Branding Tools
  flutter_launcher_icons: ^0.14.4
  flutter_native_splash: ^2.4.6

# ----------
# Flutter Configuration
# ----------
flutter:
  uses-material-design: true

  assets:
    - assets/native/
    - assets/images/
    - assets/svgs/

# ----------
# App Icons Configuration
# ----------
flutter_launcher_icons:
  android: true
  ios: false
  image_path: "assets/native/app_icon.png"

# ----------
# Native Splash Configuration
# ----------
flutter_native_splash:
  color: "{{SCAFFOLD_BACKGROUND_COLOR}}"
  image: "assets/native/splash.png"
  android_12:
    color: "{{SCAFFOLD_BACKGROUND_COLOR}}"
    image: "assets/native/splash.png"
```

---

## 2. Strict `analysis_options.yaml` Template

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"

linter:
  rules:
    prefer_single_quotes: true
    require_trailing_commas: true
    avoid_print: true
    prefer_final_locals: true
    prefer_const_constructors: true
    prefer_const_declarations: true
    unnecessary_breaks: true
    avoid_unnecessary_containers: true
    prefer_is_empty: true
    prefer_is_not_empty: true
```

---

## 3. High-Quality `README.md` Template

```markdown
<div align="center">

<!-- Badges at Top -->
<p>
  <a href="https://github.com/{{GITHUB_USERNAME}}/{{REPO_NAME}}/graphs/contributors">
    <img src="https://img.shields.io/github/contributors/{{GITHUB_USERNAME}}/{{REPO_NAME}}" alt="contributors" />
  </a>
  <a href="https://github.com/{{GITHUB_USERNAME}}/{{REPO_NAME}}/commits/main">
    <img src="https://img.shields.io/github/last-commit/{{GITHUB_USERNAME}}/{{REPO_NAME}}" alt="last update" />
  </a>
  <a href="https://github.com/{{GITHUB_USERNAME}}/{{REPO_NAME}}/stargazers">
    <img src="https://img.shields.io/github/stars/{{GITHUB_USERNAME}}/{{REPO_NAME}}" alt="stars" />
  </a>
  <a href="https://github.com/{{GITHUB_USERNAME}}/{{REPO_NAME}}/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/{{GITHUB_USERNAME}}/{{REPO_NAME}}" alt="license" />
  </a>
</p>

<!-- Typing Logo -->
<img src="https://readme-typing-svg.herokuapp.com/?font=Inter&weight=800&size=50&center=true&vCenter=true&width=600&height=100&duration=4000&color={{PRIMARY_HEX_WITHOUT_HASH}}&lines={{APP_NAME_EN_ESCAPED}}"/>

<!-- Links Section -->
<p>
  <a href="{{REVIEW_LINK}}">
    <img src="https://img.shields.io/badge/⭐_Client_Review-{{PRIMARY_HEX_WITHOUT_HASH}}?style=for-the-badge" alt="Client Review"/>
  </a>
  <a href="{{LINKEDIN_LINK}}">
    <img src="https://img.shields.io/badge/💬_LinkedIn-{{SECONDARY_HEX_WITHOUT_HASH}}?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn"/>
  </a>
</p>

</div>

<img src="https://img.shields.io/badge/-%20-C8CBCD?style=flat-square" width="100%" height="2" alt="" />

<div align="center">
  <img src="https://img.shields.io/badge/%F0%9F%93%B8_App_Preview-{{SECONDARY_HEX_WITHOUT_HASH}}?style=for-the-badge" alt="App Preview" />
</div>

<div align="center">

<img src="assets/native/app_icon.png" width="220" alt="App Screens" />

<br/>
<br/>

| | |
|:---:|:---:|
| <img src="assets/native/app_icon.png" width="180"/> | <img src="assets/native/app_icon.png" width="180"/> |
| **Live Demo** | **All Views** |

</div>

<img src="https://img.shields.io/badge/-%20-C8CBCD?style=flat-square" width="100%" height="2" alt="" />

<div align="center">
  <img src="https://img.shields.io/badge/%F0%9F%9A%80_Key_Features-{{SECONDARY_HEX_WITHOUT_HASH}}?style=for-the-badge" alt="Key Features" />
</div>

<details>
<summary><b>📋 {{FEATURE_1_TITLE}}</b></summary>
<br>

- **{{FEATURE_1_SUB}}**: {{FEATURE_1_DESC}}

</details>

<img src="https://img.shields.io/badge/-%20-C8CBCD?style=flat-square" width="100%" height="2" alt="" />

<div align="center">
  <img src="https://img.shields.io/badge/%F0%9F%9B%A0%EF%B8%8F_Tech_Stack-{{SECONDARY_HEX_WITHOUT_HASH}}?style=for-the-badge" alt="Tech Stack" />
</div>

- **Framework**: `Flutter`
- **Language**: `Dart`
- **State Management**: `{{STATE_MANAGEMENT}}`
- **Local Database**: `{{LOCAL_DATABASE}}`
- **Cloud Database**: `{{CLOUD_DATABASE}}`
- **Architecture**: `Feature-First Clean Architecture`
- **Testing**: `Unit, Widget, Integration Tests`

<img src="https://img.shields.io/badge/-%20-C8CBCD?style=flat-square" width="100%" height="2" alt="" />

<div align="center">
Made with ❤️ by {{AUTHOR}}
<br/>
<b>© 2026 {{APP_NAME}}</b>
</div>
```
