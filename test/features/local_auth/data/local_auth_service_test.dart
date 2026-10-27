import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mocktail/mocktail.dart';

import 'package:car_register/features/local_auth/data/local_auth_service.dart';
import 'package:car_register/features/local_auth/domain/local_auth_result.dart';

class MockLocalAuthentication extends Mock implements LocalAuthentication {}

void main() {
  late MockLocalAuthentication authentication;
  late DeviceLocalAuthService service;

  setUp(() {
    authentication = MockLocalAuthentication();
    service = DeviceLocalAuthService(authentication: authentication);
  });

  void stubAuthenticate(Future<bool> Function() answer) {
    when(
      () => authentication.authenticate(
        localizedReason: any(named: 'localizedReason'),
        biometricOnly: any(named: 'biometricOnly'),
        persistAcrossBackgrounding: any(named: 'persistAcrossBackgrounding'),
      ),
    ).thenAnswer((_) => answer());
  }

  void stubAuthenticateError(Object error) {
    when(
      () => authentication.authenticate(
        localizedReason: any(named: 'localizedReason'),
        biometricOnly: any(named: 'biometricOnly'),
        persistAcrossBackgrounding: any(named: 'persistAcrossBackgrounding'),
      ),
    ).thenThrow(error);
  }

  test('returns success when the device authenticates', () async {
    stubAuthenticate(() async => true);

    final result = await service.authenticate(reason: 'delete');

    expect(result, LocalAuthResult.success);
    verify(
      () => authentication.authenticate(
        localizedReason: 'delete',
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      ),
    ).called(1);
  });

  test('returns cancelled when the challenge fails', () async {
    stubAuthenticate(() async => false);

    final result = await service.authenticate(reason: 'delete');

    expect(result, LocalAuthResult.cancelled);
  });

  test('maps a user cancellation', () async {
    stubAuthenticateError(
      const LocalAuthException(code: LocalAuthExceptionCode.userCanceled),
    );

    final result = await service.authenticate(reason: 'delete');

    expect(result, LocalAuthResult.cancelled);
  });

  test('maps missing device credentials', () async {
    stubAuthenticateError(
      const LocalAuthException(code: LocalAuthExceptionCode.noCredentialsSet),
    );

    final result = await service.authenticate(reason: 'delete');

    expect(result, LocalAuthResult.notEnrolled);
  });

  test('maps a temporary lockout', () async {
    stubAuthenticateError(
      const LocalAuthException(code: LocalAuthExceptionCode.temporaryLockout),
    );

    final result = await service.authenticate(reason: 'delete');

    expect(result, LocalAuthResult.lockedOut);
  });

  test('maps an unavailable auth UI', () async {
    stubAuthenticateError(
      const LocalAuthException(code: LocalAuthExceptionCode.uiUnavailable),
    );

    final result = await service.authenticate(reason: 'delete');

    expect(result, LocalAuthResult.unavailable);
  });

  test('maps an authentication already in progress', () async {
    stubAuthenticateError(
      const LocalAuthException(code: LocalAuthExceptionCode.authInProgress),
    );

    final result = await service.authenticate(reason: 'delete');

    expect(result, LocalAuthResult.busy);
  });

  test('maps an unknown failure to an error', () async {
    stubAuthenticateError(
      const LocalAuthException(code: LocalAuthExceptionCode.unknownError),
    );

    final result = await service.authenticate(reason: 'delete');

    expect(result, LocalAuthResult.error);
  });

  test('maps a non-local-auth exception to an error', () async {
    stubAuthenticateError(Exception('boom'));

    final result = await service.authenticate(reason: 'delete');

    expect(result, LocalAuthResult.error);
  });

  test('isAvailable follows the device support check', () async {
    when(() => authentication.isDeviceSupported()).thenAnswer(
      (_) async => true,
    );

    expect(await service.isAvailable(), isTrue);
  });

  test('isAvailable is false when the device does not support auth', () async {
    when(() => authentication.isDeviceSupported()).thenAnswer(
      (_) async => false,
    );

    expect(await service.isAvailable(), isFalse);
  });

  test('isAvailable is false when the plugin throws', () async {
    when(() => authentication.isDeviceSupported()).thenThrow(
      const LocalAuthException(code: LocalAuthExceptionCode.unknownError),
    );

    expect(await service.isAvailable(), isFalse);
  });
}
