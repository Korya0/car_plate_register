import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:car_register/app.dart';
import 'package:car_register/core/di/app_initializer.dart';
import 'package:car_register/core/di/app_providers.dart';
import 'package:car_register/core/utils/app_provider_observer.dart';

Future<void> main() async {
  final bootstrap = await AppInitializer.initialize();

  runApp(
    ProviderScope(
      overrides: [
        appLocalStorageProvider.overrideWithValue(bootstrap.localStorage),
        appSecureStorageProvider.overrideWithValue(bootstrap.secureStorage),
      ],
      observers: const [AppProviderObserver()],
      child: const CarRegisterApp(),
    ),
  );
}
