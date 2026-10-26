import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AppLocalStorage {
  Future<void> write<T>(String key, T value);

  T? read<T>(String key);

  Future<void> delete(String key);

  bool contains(String key);

  Future<void> clear();
}

final class AppLocalStorageImpl implements AppLocalStorage {
  AppLocalStorageImpl._(this._preferences);

  final SharedPreferences _preferences;

  // Opens the single app preferences box.
  static Future<AppLocalStorageImpl> open() async {
    final preferences = await SharedPreferences.getInstance();
    return AppLocalStorageImpl._(preferences);
  }

  @override
  Future<void> write<T>(String key, T value) async {
    switch (value) {
      case final String v:
        await _preferences.setString(key, v);
      case final int v:
        await _preferences.setInt(key, v);
      case final double v:
        await _preferences.setDouble(key, v);
      case final bool v:
        await _preferences.setBool(key, v);
      case final List<String> v:
        await _preferences.setStringList(key, v);
      default:
        throw ArgumentError.value(
          value,
          'value',
          'Unsupported local storage type: ${value.runtimeType}',
        );
    }
  }

  @override
  T? read<T>(String key) => _preferences.get(key) as T?;

  @override
  Future<void> delete(String key) => _preferences.remove(key);

  @override
  bool contains(String key) => _preferences.containsKey(key);

  @override
  Future<void> clear() => _preferences.clear();
}
