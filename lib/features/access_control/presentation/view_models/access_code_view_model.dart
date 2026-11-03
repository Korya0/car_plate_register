import 'package:car_register/core/error/result.dart';
import 'package:car_register/features/access_control/domain/use_cases/validate_access_code_use_case.dart';
import 'package:flutter/material.dart';

enum AccessCodeState {
  initial,
  loading,
  success,
  failure,
}

class AccessCodeViewModel extends ChangeNotifier {
  AccessCodeViewModel({
    required this.verifyAccessCode,
  });

  final ValidateAccessCodeUseCase verifyAccessCode;

  AccessCodeState _state = AccessCodeState.initial;
  AccessCodeState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _state == AccessCodeState.loading;

  Future<bool> submit(String code) async {
    if (_state == AccessCodeState.loading) return false;

    final trimmed = code.trim();
    if (trimmed.isEmpty) return false;

    _state = AccessCodeState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await verifyAccessCode(trimmed);

      if (result is Success && result.dataOrNull != null) {
        final entity = result.dataOrNull!;
        if (entity.isActive) {
          _state = AccessCodeState.success;
          notifyListeners();
          return true;
        }
      }

      _errorMessage = 'Access Code is invalid';
      _state = AccessCodeState.failure;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Something went wrong';
      _state = AccessCodeState.failure;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    if (_state == AccessCodeState.failure) {
      _state = AccessCodeState.initial;
      _errorMessage = null;
      notifyListeners();
    }
  }
}
