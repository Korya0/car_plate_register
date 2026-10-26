import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:car_register/core/utils/app_logger.dart';

final class AppProviderObserver extends ProviderObserver {
  const AppProviderObserver();

  final AppLogger logger = const AppLogger();

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    super.providerDidFail(context, error, stackTrace);

    logger.error(
      '${context.provider.name ?? context.provider.runtimeType} failed',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
