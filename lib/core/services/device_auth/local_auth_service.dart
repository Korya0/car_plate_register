import 'package:local_auth/local_auth.dart';

import 'package:car_register/core/services/device_auth/local_auth_result.dart';
import 'package:car_register/core/utils/app_logger.dart';

abstract interface class LocalAuthService {
  Future<bool> isAvailable();

  Future<LocalAuthResult> authenticate({required String reason});
}

// Maps local_auth exceptions to typed results; unavailable hardware and
// unknown errors always log the original once.
final class DeviceLocalAuthService implements LocalAuthService {
  DeviceLocalAuthService({
    required this.logger,
    LocalAuthentication? authentication,
  }) : _authentication = authentication ?? LocalAuthentication();

  final AppLogger logger;

  final LocalAuthentication _authentication;

  @override
  Future<bool> isAvailable() async {
    try {
      return await _authentication.isDeviceSupported();
    } on LocalAuthException catch (e, st) {
      logger.warning(
        'Device authentication support check failed',
        error: e,
        stackTrace: st,
      );
      return false;
    } catch (e, st) {
      logger.error(
        'Device authentication support check failed unexpectedly',
        error: e,
        stackTrace: st,
      );
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
    } catch (e, st) {
      logger.error(
        'Device authentication failed unexpectedly',
        error: e,
        stackTrace: st,
      );
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
