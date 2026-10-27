import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import 'package:car_register/features/local_auth/domain/local_auth_result.dart';

abstract interface class LocalAuthService {
  Future<bool> isAvailable();

  Future<LocalAuthResult> authenticate({required String reason});
}

final localAuthServiceProvider = Provider<LocalAuthService>(
  (ref) => DeviceLocalAuthService(),
);

final class DeviceLocalAuthService implements LocalAuthService {
  DeviceLocalAuthService({LocalAuthentication? authentication})
    : _authentication = authentication ?? LocalAuthentication();

  final LocalAuthentication _authentication;

  @override
  Future<bool> isAvailable() async {
    try {
      return await _authentication.isDeviceSupported();
    } on LocalAuthException {
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<LocalAuthResult> authenticate({required String reason}) async {
    try {
      final success = await _authentication.authenticate(
        localizedReason: reason,
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
      return success ? LocalAuthResult.success : LocalAuthResult.cancelled;
    } on LocalAuthException catch (error) {
      return _mapException(error.code);
    } catch (_) {
      return LocalAuthResult.error;
    }
  }

  LocalAuthResult _mapException(LocalAuthExceptionCode code) => switch (code) {
    LocalAuthExceptionCode.userCanceled ||
    LocalAuthExceptionCode.systemCanceled ||
    LocalAuthExceptionCode.timeout ||
    LocalAuthExceptionCode.userRequestedFallback => LocalAuthResult.cancelled,
    LocalAuthExceptionCode.noCredentialsSet ||
    LocalAuthExceptionCode.noBiometricsEnrolled => LocalAuthResult.notEnrolled,
    LocalAuthExceptionCode.noBiometricHardware ||
    LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable ||
    LocalAuthExceptionCode.uiUnavailable => LocalAuthResult.unavailable,
    LocalAuthExceptionCode.temporaryLockout ||
    LocalAuthExceptionCode.biometricLockout => LocalAuthResult.lockedOut,
    LocalAuthExceptionCode.authInProgress => LocalAuthResult.busy,
    LocalAuthExceptionCode.deviceError ||
    LocalAuthExceptionCode.unknownError => LocalAuthResult.error,
  };
}
