# Flutter Build Flavors Blueprint

Use this reference when the project specification or questionnaire requires multiple build environments (e.g. `development`, `staging`, `production`).

---

## 1. Android Configuration

### A. `android/gradle.properties`
Add this property to enable `resValue` generation inside product flavors:
```properties
android.defaults.buildfeatures.resvalues=true
```

### B. `android/app/build.gradle.kts`
Add flavor dimensions and flavor definitions inside the `android { ... }` block:
```kotlin
flavorDimensions += "default"

productFlavors {
    create("development") {
        dimension = "default"
        applicationIdSuffix = ".dev"
        resValue("string", "app_name", "{{APP_NAME}} Dev")
    }

    create("staging") {
        dimension = "default"
        applicationIdSuffix = ".stg"
        resValue("string", "app_name", "{{APP_NAME}} Staging")
    }

    create("production") {
        dimension = "default"
        resValue("string", "app_name", "{{APP_NAME}}")
    }
}
```

### C. `android/app/src/main/AndroidManifest.xml`
Point `android:label` to the flavor-generated resource string:
```xml
<application
    android:label="@string/app_name"
    ... >
```

---

## 2. Distinct Entry Points (`lib/`)

Create dedicated entry point files for each flavor:

### `lib/main_development.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{APP_PACKAGE}}/app/app.dart';
import 'package:{{APP_PACKAGE}}/core/config/app_config.dart';
import 'package:{{APP_PACKAGE}}/core/di/app_initializer.dart';

Future<void> main() async {
  AppConfig.environment = AppEnvironment.development;
  final bootstrap = await AppInitializer.initialize();
  runApp(
    ProviderScope(
      overrides: bootstrap.overrides,
      child: const {{APP_CLASS_NAME}}(),
    ),
  );
}
```

### `lib/main_production.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{APP_PACKAGE}}/app/app.dart';
import 'package:{{APP_PACKAGE}}/core/config/app_config.dart';
import 'package:{{APP_PACKAGE}}/core/di/app_initializer.dart';

Future<void> main() async {
  AppConfig.environment = AppEnvironment.production;
  final bootstrap = await AppInitializer.initialize();
  runApp(
    ProviderScope(
      overrides: bootstrap.overrides,
      child: const {{APP_CLASS_NAME}}(),
    ),
  );
}
```

---

## 3. iOS Configuration (CI/CD Ready)

Create xcconfig files inside `ios/Flutter/`:

- `Debug-development.xcconfig`:
  ```
  #include "Generated.xcconfig"
  #include "Debug.xcconfig"
  FLUTTER_TARGET=lib/main_development.dart
  BUNDLE_SUFFIX=.dev
  APP_DISPLAY_NAME={{APP_NAME}} Dev
  ```
- `Release-production.xcconfig`:
  ```
  #include "Generated.xcconfig"
  #include "Release.xcconfig"
  FLUTTER_TARGET=lib/main_production.dart
  BUNDLE_SUFFIX=
  APP_DISPLAY_NAME={{APP_NAME}}
  ```

---

## 4. Run & Build Commands

```bash
# Run Development
flutter run --flavor development -t lib/main_development.dart

# Run Production
flutter run --flavor production -t lib/main_production.dart

# Build Production Release APK
flutter build apk --release --flavor production -t lib/main_production.dart
```
