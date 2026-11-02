import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:car_register/core/services/local_storage/app_local_storage.dart';
import 'package:car_register/core/services/local_storage/app_secure_storage.dart';

final class AppInitializer {
  const AppInitializer({
    required this.localStorage,
    required this.secureStorage,
  });

  final AppLocalStorage localStorage;
  final AppSecureStorage secureStorage;

  // Initializes platform services and opens local storage once.
  static Future<AppInitializer> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    final localStorage = await AppLocalStorageImpl.open();
    final secureStorage = await AppSecureStorage.open();

    return AppInitializer(
      localStorage: localStorage,
      secureStorage: secureStorage,
    );
  }
}
