import 'dart:async';

import 'package:car_register/features/local_auth/data/local_auth_service.dart';
import 'package:car_register/features/local_auth/domain/local_auth_result.dart';

class FakeLocalAuthService implements LocalAuthService {
  FakeLocalAuthService({
    this.available = true,
    this.result = LocalAuthResult.success,
  });

  bool available;
  LocalAuthResult result;
  Completer<LocalAuthResult>? completer;
  int authenticateCalls = 0;
  String? lastReason;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<LocalAuthResult> authenticate({required String reason}) {
    authenticateCalls++;
    lastReason = reason;
    final pending = completer;
    if (pending != null) return pending.future;
    return Future.value(result);
  }
}
