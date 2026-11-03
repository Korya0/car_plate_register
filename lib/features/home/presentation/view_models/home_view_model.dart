import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/error/result.dart';
import 'package:car_register/features/home/domain/entities/brochure_entity.dart';
import 'package:car_register/features/home/domain/use_cases/add_brochure_use_case.dart';
import 'package:car_register/features/home/domain/use_cases/delete_brochure_use_case.dart';
import 'package:car_register/features/home/domain/use_cases/get_brochures_use_case.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required this.getBrochuresUseCase,
    required this.addBrochureUseCase,
    required this.deleteBrochureUseCase,
  });

  final GetBrochuresUseCase getBrochuresUseCase;
  final AddBrochureUseCase addBrochureUseCase;
  final DeleteBrochureUseCase deleteBrochureUseCase;

  List<BrochureEntity> _entries = <BrochureEntity>[];
  List<BrochureEntity> get entries => _entries;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  String? _errorText;
  String? get errorText => _errorText;

  String get _accessCode => AppConstants.accessCodeDemoValue;

  Future<void> loadBrochures() async {
    final result = await getBrochuresUseCase(accessCode: _accessCode);

    if (result is Success<List<BrochureEntity>>) {
      _entries = result.data;
      _errorText = null;
      notifyListeners();
    } else if (result is FailureResult<List<BrochureEntity>>) {
      _errorText = result.failure.message;
      _entries = [];
      notifyListeners();
    }
  }

  Future<bool> addBrochure(String number) async {
    if (_isSaving) return false;

    final trimmed = number.trim();
    if (trimmed.isEmpty) return false;

    _isSaving = true;
    _errorText = null;
    notifyListeners();

    final result = await addBrochureUseCase(
      accessCode: _accessCode,
      number: trimmed,
    );

    if (result is Success<BrochureEntity>) {
      await loadBrochures();
      _isSaving = false;
      notifyListeners();
      return true;
    } else if (result is FailureResult<BrochureEntity>) {
      _errorText = result.failure.message;
      _isSaving = false;
      notifyListeners();
      return false;
    }

    _isSaving = false;
    notifyListeners();
    return false;
  }

  Future<void> deleteBrochure(BrochureEntity entry) async {
    final result = await deleteBrochureUseCase(
      accessCode: _accessCode,
      id: entry.id,
    );

    if (result is Success<void>) {
      await loadBrochures();
    } else if (result is FailureResult<void>) {
      _errorText = result.failure.message;
      notifyListeners();
    }
  }

  void clearError() {
    if (_errorText == null) return;
    _errorText = null;
    notifyListeners();
  }
}
