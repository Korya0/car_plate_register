import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:car_register/core/services/firebase/firebase_options.dart';
import 'package:car_register/core/services/local_storage/app_secure_storage.dart';

final class AppInitializer {
  const AppInitializer({
    required this.secureStorage,
  });

  final AppSecureStorage secureStorage;

  // Initializes platform services and opens local storage once.
  static Future<AppInitializer> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    if (!kIsWeb) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    final secureStorage = await AppSecureStorage.open();

    return AppInitializer(
      secureStorage: secureStorage,
    );
  }
}
