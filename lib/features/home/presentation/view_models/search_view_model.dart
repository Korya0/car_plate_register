import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/error/result.dart';
import 'package:car_register/features/home/domain/entities/brochure_entity.dart';
import 'package:car_register/features/home/domain/use_cases/delete_brochure_use_case.dart';
import 'package:car_register/features/home/domain/use_cases/get_brochures_use_case.dart';
import 'package:car_register/features/home/domain/use_cases/search_brochures_use_case.dart';
import 'package:flutter/material.dart';

class SearchViewModel extends ChangeNotifier {
  SearchViewModel({
    required this.searchBrochuresUseCase,
    required this.deleteBrochureUseCase,
    required this.getBrochuresUseCase,
  });

  final SearchBrochuresUseCase searchBrochuresUseCase;
  final DeleteBrochureUseCase deleteBrochureUseCase;
  final GetBrochuresUseCase getBrochuresUseCase;

  List<BrochureEntity> _results = <BrochureEntity>[];
  List<BrochureEntity> get results => _results;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  String? _errorText;
  String? get errorText => _errorText;

  String get _accessCode => AppConstants.accessCodeDemoValue;

  Future<void> loadBrochures() async {
    await getBrochuresUseCase(accessCode: _accessCode);
    search('');
  }

  void search(String query) {
    final trimmed = query.trim();

    _isSearching = true;
    _errorText = null;
    notifyListeners();

    final result = searchBrochuresUseCase(trimmed);

    if (result is Success<List<BrochureEntity>>) {
      _results = result.data;
    } else if (result is FailureResult<List<BrochureEntity>>) {
      _errorText = result.failure.message;
      _results = [];
    }

    _isSearching = false;
    notifyListeners();
  }

  Future<void> deleteBrochure(BrochureEntity entry) async {
    final result = await deleteBrochureUseCase(
      accessCode: _accessCode,
      id: entry.id,
    );

    if (result is Success<void>) {
      _results = List<BrochureEntity>.from(_results)
        ..removeWhere((e) => e.id == entry.id);
      await getBrochuresUseCase(accessCode: _accessCode);
      notifyListeners();
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
