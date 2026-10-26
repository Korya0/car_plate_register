# Local Storage Abstraction Blueprint

Enforces a clean local storage architecture so Features never depend directly on storage packages (`shared_preferences`, `flutter_secure_storage`).

```text
Feature ──► Storage Abstraction ──► Package Implementation ──► Third-Party SDK
```

---

## 1. Abstract Interfaces

### `lib/core/services/local_storage/local_storage.dart`
```dart
abstract interface class LocalStorage {
  Future<void> write<T>(String key, T value);
  T? read<T>(String key);
  Future<void> delete(String key);
  Future<void> clear();
  bool contains(String key);
}
```

### `lib/core/services/local_storage/secure_storage.dart`
```dart
abstract interface class SecureStorage {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<void> clear();
  Future<bool> contains(String key);
}
```

---

## 2. Centralized Storage Keys

### `lib/core/services/local_storage/local_storage_keys.dart`
```dart
abstract final class LocalStorageKeys {
  static const onboardingCompleted = 'onboarding_completed';
  static const language = 'language';
  static const themeMode = 'theme_mode';
  static const lastSyncTimestamp = 'last_sync_timestamp';
}
```

### `lib/core/services/local_storage/secure_storage_keys.dart`
```dart
abstract final class SecureStorageKeys {
  static const accessToken = 'access_token';
  static const refreshToken = 'refresh_token';
  static const appLockPin = 'app_lock_pin';
  static const sharedAccessPin = 'shared_access_pin';
}
```

---

## 3. Implementations (Encapsulated)

### `lib/core/services/local_storage/implementations/shared_preferences_storage.dart`
```dart
import 'package:shared_preferences/shared_preferences.dart';
import '../local_storage.dart';

final class SharedPreferencesStorage implements LocalStorage {
  const SharedPreferencesStorage(this._prefs);
  final SharedPreferences _prefs;

  @override
  Future<void> write<T>(String key, T value) async {
    switch (value) {
      case final String v:
        await _prefs.setString(key, v);
      case final int v:
        await _prefs.setInt(key, v);
      case final double v:
        await _prefs.setDouble(key, v);
      case final bool v:
        await _prefs.setBool(key, v);
      case final List<String> v:
        await _prefs.setStringList(key, v);
      default:
        throw ArgumentError('Unsupported storage value type: ${value.runtimeType}');
    }
  }

  @override
  T? read<T>(String key) => _prefs.get(key) as T?;

  @override
  Future<void> delete(String key) => _prefs.remove(key);

  @override
  Future<void> clear() => _prefs.clear();

  @override
  bool contains(String key) => _prefs.containsKey(key);
}
```

### `lib/core/services/local_storage/implementations/flutter_secure_storage_service.dart`
```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../secure_storage.dart';

final class FlutterSecureStorageService implements SecureStorage {
  const FlutterSecureStorageService(this._storage);
  final FlutterSecureStorage _storage;

  @override
  Future<void> write(String key, String value) => _storage.write(key: key, value: value);

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> clear() => _storage.deleteAll();

  @override
  Future<bool> contains(String key) => _storage.containsKey(key: key);
}
```

---

## 4. DI Registration

- **Riverpod:**
  ```dart
  final localStorageProvider = Provider<LocalStorage>((ref) => throw StateError('Override in main'));
  final secureStorageProvider = Provider<SecureStorage>((ref) => throw StateError('Override in main'));
  ```
- **GetIt:**
  ```dart
  sl.registerLazySingleton<LocalStorage>(() => SharedPreferencesStorage(sharedPreferences));
  sl.registerLazySingleton<SecureStorage>(() => FlutterSecureStorageService(const FlutterSecureStorage()));
  ```
