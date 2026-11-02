import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/error/result.dart';
import 'package:car_register/features/home/domain/entities/brochure_entity.dart';
import 'package:car_register/features/home/domain/use_cases/delete_brochure_use_case.dart';
import 'package:car_register/features/home/domain/use_cases/get_brochures_use_case.dart';
import 'package:car_register/features/home/domain/use_cases/search_brochures_use_case.dart';
import 'package:flutter/material.dart';

class SearchViewModel {
  SearchViewModel({
    required this.searchBrochuresUseCase,
    required this.deleteBrochureUseCase,
    required this.getBrochuresUseCase,
  });

  final SearchBrochuresUseCase searchBrochuresUseCase;
  final DeleteBrochureUseCase deleteBrochureUseCase;
  final GetBrochuresUseCase getBrochuresUseCase;

  final ValueNotifier<List<BrochureEntity>> results =
      ValueNotifier<List<BrochureEntity>>([]);
  final ValueNotifier<bool> isSearching = ValueNotifier<bool>(false);
  final ValueNotifier<String?> errorText = ValueNotifier<String?>(null);

  String get _accessCode => AppConstants.accessCodeDemoValue;

  Future<void> loadBrochures() async {
    await getBrochuresUseCase(accessCode: _accessCode);
    // After loading, show all if no query
    search('');
  }

  void search(String query) {
    final trimmed = query.trim();

    isSearching.value = true;
    errorText.value = null;

    final result = searchBrochuresUseCase(trimmed);

    if (result is Success<List<BrochureEntity>>) {
      results.value = result.data;
    } else if (result is FailureResult<List<BrochureEntity>>) {
      errorText.value = result.failure.message;
      results.value = [];
    }

    isSearching.value = false;
  }

  Future<void> deleteBrochure(BrochureEntity entry) async {
    final result = await deleteBrochureUseCase(
      accessCode: _accessCode,
      id: entry.id,
    );

    if (result is Success<void>) {
      results.value = List<BrochureEntity>.from(results.value)
        ..removeWhere((e) => e.id == entry.id);
      // Reload cache
      await getBrochuresUseCase(accessCode: _accessCode);
    } else if (result is FailureResult<void>) {
      errorText.value = result.failure.message;
    }
  }

  void clearError() {
    errorText.value = null;
  }

  void dispose() {
    results.dispose();
    isSearching.dispose();
    errorText.dispose();
  }
}
