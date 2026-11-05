import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:car_register/core/error/result.dart';
import 'package:car_register/features/home/domain/entities/brochure_entity.dart';
import 'package:car_register/features/home/domain/validators/brochure_number_validator.dart';
import 'package:car_register/features/home/di/brochures_providers.dart';

@immutable
class HomeState {
  const HomeState({
    this.brochures = const [],
    this.isLoading = false,
    this.error,
    this.query = '',
  });

  final List<BrochureEntity> brochures;
  final bool isLoading;
  final String? error;
  final String query;

  List<BrochureEntity> get visibleEntries =>
      brochures.where((entry) => entry.number.contains(query)).toList();

  HomeState copyWith({
    List<BrochureEntity>? brochures,
    bool? isLoading,
    String? error,
    String? query,
    bool clearError = false,
    bool clearBrochures = false,
  }) {
    return HomeState(
      brochures: clearBrochures ? const [] : (brochures ?? this.brochures),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      query: query ?? this.query,
    );
  }
}

class HomeViewModel extends Notifier<HomeState> {
  @override
  HomeState build() => const HomeState();

  Future<void> loadBrochures({required String accessCode}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await ref.read(getBrochuresUseCaseProvider)(accessCode: accessCode);
    state = state.copyWith(isLoading: false);
    switch (result) {
      case Success(:final data):
        state = state.copyWith(brochures: data);
      case FailureResult(:final failure):
        state = state.copyWith(error: failure.message);
    }
  }

  Future<void> addBrochure({
    required String accessCode,
    required String number,
  }) async {
    final validationError = BrochureNumberValidator.validate(number);
    if (validationError != null) {
      state = state.copyWith(error: validationError);
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    final result = await ref.read(addBrochureUseCaseProvider)(
      accessCode: accessCode,
      number: number,
    );
    state = state.copyWith(isLoading: false);
    switch (result) {
      case Success():
        await loadBrochures(accessCode: accessCode);
      case FailureResult(:final failure):
        state = state.copyWith(error: failure.message);
    }
  }

  Future<void> deleteBrochure({
    required String accessCode,
    required String id,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await ref.read(deleteBrochureUseCaseProvider)(
      accessCode: accessCode,
      id: id,
    );
    state = state.copyWith(isLoading: false);
    switch (result) {
      case Success():
        await loadBrochures(accessCode: accessCode);
      case FailureResult(:final failure):
        state = state.copyWith(error: failure.message);
    }
  }

  Future<void> deleteManyBrochures({
    required String accessCode,
    required List<String> ids,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await ref.read(deleteBrochureUseCaseProvider).many(
      accessCode: accessCode,
      ids: ids,
    );
    state = state.copyWith(isLoading: false);
    switch (result) {
      case Success():
        await loadBrochures(accessCode: accessCode);
      case FailureResult(:final failure):
        state = state.copyWith(error: failure.message);
    }
  }

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(
  HomeViewModel.new,
);
