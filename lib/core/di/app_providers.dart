import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:car_register/core/services/local_storage/app_local_storage.dart';
import 'package:car_register/core/services/local_storage/app_secure_storage.dart';
import 'package:car_register/core/utils/app_logger.dart';

final appLoggerProvider = Provider<AppLogger>((ref) => const AppLogger());

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
