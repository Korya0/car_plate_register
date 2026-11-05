import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:car_register/core/services/local_storage/app_local_storage.dart';
import 'package:car_register/core/services/local_storage/app_secure_storage.dart';
import 'package:car_register/core/utils/app_logger.dart';

final appLoggerProvider = Provider<AppLogger>((ref) => const AppLogger());

final firebaseFirestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final appLocalStorageProvider = Provider<AppLocalStorage>(
  (ref) => throw StateError(
    'appLocalStorageProvider must be overridden in main()',
  ),
);

final appSecureStorageProvider = Provider<AppSecureStorage>(
  (ref) => throw StateError(
    'appSecureStorageProvider must be overridden in main()',
  ),
);

final accessCodeProvider = Provider<ValueNotifier<String>>(
  (ref) => ValueNotifier(''),
);
