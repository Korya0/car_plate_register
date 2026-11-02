import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/error/result.dart';
import 'package:car_register/features/home/domain/entities/brochure_entity.dart';
import 'package:car_register/features/home/domain/use_cases/add_brochure_use_case.dart';
import 'package:car_register/features/home/domain/use_cases/delete_brochure_use_case.dart';
import 'package:car_register/features/home/domain/use_cases/get_brochures_use_case.dart';
import 'package:flutter/material.dart';

class HomeViewModel {
  HomeViewModel({
    required this.getBrochuresUseCase,
    required this.addBrochureUseCase,
    required this.deleteBrochureUseCase,
  });

  final GetBrochuresUseCase getBrochuresUseCase;
  final AddBrochureUseCase addBrochureUseCase;
  final DeleteBrochureUseCase deleteBrochureUseCase;

  final ValueNotifier<List<BrochureEntity>> entries =
      ValueNotifier<List<BrochureEntity>>([]);
  final ValueNotifier<bool> isSaving = ValueNotifier<bool>(false);
  final ValueNotifier<String?> errorText = ValueNotifier<String?>(null);

  String get _accessCode => AppConstants.accessCodeDemoValue;

  Future<void> loadBrochures() async {
    final result = await getBrochuresUseCase(accessCode: _accessCode);

    if (result is Success<List<BrochureEntity>>) {
      entries.value = result.data;
      errorText.value = null;
    } else if (result is FailureResult<List<BrochureEntity>>) {
      errorText.value = result.failure.message;
      entries.value = [];
    }
  }

  Future<bool> addBrochure(String number) async {
    if (isSaving.value) return false;

    isSaving.value = true;
    errorText.value = null;

    final result = await addBrochureUseCase(
      accessCode: _accessCode,
      number: number.trim(),
    );

    if (result is Success<BrochureEntity>) {
      await loadBrochures();
      isSaving.value = false;
      return true;
    } else if (result is FailureResult<BrochureEntity>) {
      errorText.value = result.failure.message;
      isSaving.value = false;
      return false;
    }

    isSaving.value = false;
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
      errorText.value = result.failure.message;
    }
  }

  void clearError() {
    errorText.value = null;
  }

  void dispose() {
    entries.dispose();
    isSaving.dispose();
    errorText.dispose();
  }
}
