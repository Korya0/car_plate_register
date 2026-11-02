import 'package:car_register/core/error/result.dart';
import 'package:car_register/features/access_control/domain/use_cases/validate_access_code_use_case.dart';
import 'package:flutter/material.dart';

class AccessCodeViewModel {
  final ValidateAccessCodeUseCase verifyAccessCode;

  AccessCodeViewModel({
    required this.verifyAccessCode,
  });

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  final ValueNotifier<String?> errorText = ValueNotifier(null);

  Future<bool> submit(String code) async {
    if (isLoading.value) return false;

    isLoading.value = true;
    errorText.value = null;

    try {
      final result = await verifyAccessCode(code);

      return switch (result) {
        Success(:final data) => data.isActive,
        FailureResult() => () {
          errorText.value = 'Access Code is invalid';
          return false;
        }(),
      };
    } catch (e) {
      errorText.value = 'Something went wrong';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void clearError() {
    errorText.value = null;
  }

  void dispose() {
    isLoading.dispose();
    errorText.dispose();
  }
}
