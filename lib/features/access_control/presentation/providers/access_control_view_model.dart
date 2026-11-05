import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:car_register/core/error/result.dart';
import 'package:car_register/features/access_control/di/access_control_providers.dart';
import 'package:car_register/features/access_control/domain/entities/access_code_entity.dart';

@immutable
class AccessCodeState {
  const AccessCodeState({
    this.isLoading = false,
    this.accessCode,
    this.error,
  });

  final bool isLoading;
  final AccessCodeEntity? accessCode;
  final String? error;

  AccessCodeState copyWith({
    bool? isLoading,
    AccessCodeEntity? accessCode,
    String? error,
    bool clearAccessCode = false,
    bool clearError = false,
  }) {
    return AccessCodeState(
      isLoading: isLoading ?? this.isLoading,
      accessCode: clearAccessCode ? null : (accessCode ?? this.accessCode),
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AccessCodeViewModel extends Notifier<AccessCodeState> {
  @override
  AccessCodeState build() => const AccessCodeState();

  Future<void> validate(String code) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await ref.read(validateAccessCodeUseCaseProvider)(code);
    state = state.copyWith(isLoading: false);
    switch (result) {
      case Success(:final data):
        state = state.copyWith(accessCode: data);
      case FailureResult(:final failure):
        state = state.copyWith(error: failure.message);
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void reset() {
    state = const AccessCodeState();
  }
}

final accessCodeViewModelProvider =
    NotifierProvider<AccessCodeViewModel, AccessCodeState>(
      AccessCodeViewModel.new,
    );
