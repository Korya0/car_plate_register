import 'package:car_register/core/constants/app_strings.dart';

enum LocalAuthResult {
  success,
  cancelled,
  unavailable,
  notEnrolled,
  lockedOut,
  busy,
  error,
}

extension LocalAuthResultX on LocalAuthResult {
  bool get isSuccess => this == LocalAuthResult.success;

  String get message => switch (this) {
    LocalAuthResult.success => '',
    LocalAuthResult.cancelled => AppStrings.localAuthResultCancelled,
    LocalAuthResult.unavailable => AppStrings.localAuthResultUnavailable,
    LocalAuthResult.notEnrolled => AppStrings.localAuthResultNotEnrolled,
    LocalAuthResult.lockedOut => AppStrings.localAuthResultLockedOut,
    LocalAuthResult.busy => AppStrings.localAuthResultBusy,
    LocalAuthResult.error => AppStrings.localAuthResultError,
  };
}
