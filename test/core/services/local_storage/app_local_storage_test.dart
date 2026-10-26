import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:car_register/core/services/local_storage/app_local_storage.dart';
import 'package:car_register/core/services/local_storage/app_storage_keys.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppLocalStorageImpl', () {
    late AppLocalStorage storage;

    setUp(() async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      storage = await AppLocalStorageImpl.open();
    });

    test('writes and reads supported types', () async {
      await storage.write<String>('string', 'value');
      await storage.write<int>('int', 7);
      await storage.write<double>('double', 1.5);
      await storage.write<bool>('bool', true);
      await storage.write<List<String>>('list', <String>['a', 'b']);

      expect(storage.read<String>('string'), 'value');
      expect(storage.read<int>('int'), 7);
      expect(storage.read<double>('double'), 1.5);
      expect(storage.read<bool>('bool'), isTrue);
      expect(storage.read<List<String>>('list'), <String>['a', 'b']);
    });

    test('contains, deletes and clears keys', () async {
      await storage.write<bool>(AppStorageKeys.appLockEnabled, true);

      expect(storage.contains(AppStorageKeys.appLockEnabled), isTrue);

      await storage.delete(AppStorageKeys.appLockEnabled);
      expect(storage.contains(AppStorageKeys.appLockEnabled), isFalse);

      await storage.write<int>('one', 1);
      await storage.write<int>('two', 2);
      await storage.clear();

      expect(storage.contains('one'), isFalse);
      expect(storage.contains('two'), isFalse);
    });

    test('rejects unsupported value types', () async {
      await expectLater(
        storage.write<Object>('object', Object()),
        throwsArgumentError,
      );
    });
  });
}
