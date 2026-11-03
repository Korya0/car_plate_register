import 'package:car_register/core/error/result.dart';
import 'package:car_register/features/access_control/domain/use_cases/validate_access_code_use_case.dart';
import 'package:flutter/material.dart';

class AccessCodeViewModel extends ChangeNotifier {
  AccessCodeViewModel({
    required this.verifyAccessCode,
  });

  final ValidateAccessCodeUseCase verifyAccessCode;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorText;
  String? get errorText => _errorText;

  Future<bool> submit(String code) async {
    if (_isLoading) return false;

    final trimmed = code.trim();
    if (trimmed.isEmpty) return false;

    _isLoading = true;
    _errorText = null;
    notifyListeners();

    try {
      final result = await verifyAccessCode(trimmed);

      if (result is Success && result.dataOrNull != null) {
        final entity = result.dataOrNull!;
        _isLoading = false;
        notifyListeners();
        return entity.isActive;
      } else if (result is FailureResult) {
        _errorText = 'Access Code is invalid';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _errorText = 'Access Code is invalid';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorText = 'Something went wrong';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    if (_errorText == null) return;
    _errorText = null;
    notifyListeners();
  }
}
