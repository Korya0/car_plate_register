import 'package:car_register/core/services/device_auth/local_auth_service.dart';
import 'package:car_register/core/services/local_storage/app_secure_storage.dart';
import 'package:car_register/core/utils/app_logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appLoggerProvider = Provider<AppLogger>((ref) => const AppLogger());

final firebaseFirestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final appSecureStorageProvider = Provider<AppSecureStorage>(
  (ref) => throw StateError(
    'appSecureStorageProvider must be overridden in main()',
  ),
);

// Holds the validated shared access code for the current session; every
// feature reads it instead of re-prompting the user.
final class SharedAccessCodeNotifier extends Notifier<String> {
  @override
  String build() => '';

  // Saves the access code validated by the access control screen.
  void save(String code) => state = code;

  void clear() => state = '';
}

final accessCodeProvider = NotifierProvider<SharedAccessCodeNotifier, String>(
  SharedAccessCodeNotifier.new,
);

final localAuthProvider = Provider<LocalAuthService>(
  (ref) => DeviceLocalAuthService(logger: ref.watch(appLoggerProvider)),
);
