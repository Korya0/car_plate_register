import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:car_register/features/local_auth/data/local_auth_service.dart';
import 'package:car_register/features/local_auth/domain/local_auth_result.dart';

extension LocalAuthContextX on BuildContext {
  /// Runs [action] only after the user passes device authentication.
  ///
  /// The guard is opt-in: nothing runs until an action is wrapped with this
  /// method. Set [enabled] to false to skip authentication for this action.
  /// The returned result lets the caller show a message on failure.
  Future<LocalAuthResult> runWithLocalAuth({
    required String reason,
    required FutureOr<void> Function() action,
    bool enabled = true,
  }) async {
    if (!enabled) {
      await action();
      return LocalAuthResult.success;
    }

    final service = ProviderScope.containerOf(
      this,
      listen: false,
    ).read(localAuthServiceProvider);

    if (!await service.isAvailable()) {
      return LocalAuthResult.unavailable;
    }

    final result = await service.authenticate(reason: reason);
    if (result.isSuccess) {
      await action();
    }
    return result;
  }
}
