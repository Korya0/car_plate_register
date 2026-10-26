import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final class AppSecureStorage {
  AppSecureStorage._(this._storage);

  final FlutterSecureStorage _storage;

  // Opens the encrypted storage wrapper.
  static Future<AppSecureStorage> open() async =>
      AppSecureStorage._(const FlutterSecureStorage());

  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  Future<String?> read(String key) => _storage.read(key: key);

  Future<void> delete(String key) => _storage.delete(key: key);

  Future<void> clear() => _storage.deleteAll();
}
