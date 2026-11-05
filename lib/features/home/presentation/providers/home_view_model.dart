import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:car_register/core/error/failure.dart';
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
    this.loadingIds = const {},
    this.accessCodeInvalid = false,
  });

  final List<BrochureEntity> brochures;
  final bool isLoading;
  final String? error;
  final String query;
  final Set<String> loadingIds;
  final bool accessCodeInvalid;

  List<BrochureEntity> get visibleEntries =>
      brochures.where((entry) => entry.number.contains(query)).toList();

  HomeState copyWith({
    List<BrochureEntity>? brochures,
    bool? isLoading,
    String? error,
    String? query,
    Set<String>? loadingIds,
    bool? accessCodeInvalid,
    bool clearError = false,
    bool clearBrochures = false,
    bool clearLoadingIds = false,
    bool clearAccessCodeInvalid = false,
  }) {
    return HomeState(
      brochures: clearBrochures ? const [] : (brochures ?? this.brochures),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      query: query ?? this.query,
      loadingIds: clearLoadingIds ? const {} : (loadingIds ?? this.loadingIds),
      accessCodeInvalid: clearAccessCodeInvalid
          ? false
          : (accessCodeInvalid ?? this.accessCodeInvalid),
    );
  }
}

class HomeViewModel extends Notifier<HomeState> {
  @override
  HomeState build() => const HomeState();

  Future<void> loadBrochures({required String accessCode}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await ref.read(getBrochuresUseCaseProvider)(
      accessCode: accessCode,
    );
    state = state.copyWith(isLoading: false);
    switch (result) {
      case Success(:final data):
        state = state.copyWith(brochures: data);
      case FailureResult(:final failure):
        if (failure is AccessCodeFailure) {
          state = state.copyWith(
            accessCodeInvalid: true,
            error: failure.message,
          );
        } else {
          state = state.copyWith(error: failure.message);
        }
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

    final formattedNumber = BrochureNumberValidator.format(number);
    final tempId = 'temp:$formattedNumber';

    state = state.copyWith(
      brochures: [
        BrochureEntity(
          id: tempId,
          number: formattedNumber,
          createdAt: DateTime.now(),
        ),
        ...state.brochures,
      ],
      loadingIds: {...state.loadingIds, tempId},
      clearError: true,
    );

    final result = await ref.read(addBrochureUseCaseProvider)(
      accessCode: accessCode,
      number: formattedNumber,
    );
    state = state.copyWith(
      loadingIds: state.loadingIds..remove(tempId),
    );
    switch (result) {
      case Success():
        await loadBrochures(accessCode: accessCode);
      case FailureResult(:final failure):
        if (failure is AccessCodeFailure) {
          state = state.copyWith(
            brochures: state.brochures.where((e) => e.id != tempId).toList(),
            accessCodeInvalid: true,
            error: failure.message,
          );
        } else {
          state = state.copyWith(
            brochures: state.brochures.where((e) => e.id != tempId).toList(),
            error: failure.message,
          );
        }
    }
  }

  Future<void> deleteBrochure({
    required String accessCode,
    required String id,
  }) async {
    final deleted = state.brochures.firstWhere((e) => e.id == id);

    state = state.copyWith(
      brochures: state.brochures.where((e) => e.id != id).toList(),
      loadingIds: {...state.loadingIds, id},
      clearError: true,
    );

    final result = await ref.read(deleteBrochureUseCaseProvider)(
      accessCode: accessCode,
      id: id,
    );
    state = state.copyWith(loadingIds: state.loadingIds..remove(id));
    switch (result) {
      case Success():
        await loadBrochures(accessCode: accessCode);
      case FailureResult(:final failure):
        if (failure is AccessCodeFailure) {
          state = state.copyWith(
            brochures: [...state.brochures, deleted]
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
            accessCodeInvalid: true,
            error: failure.message,
          );
        } else {
          state = state.copyWith(
            brochures: [...state.brochures, deleted]
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
            error: failure.message,
          );
        }
    }
  }

  Future<void> deleteManyBrochures({
    required String accessCode,
    required List<String> ids,
  }) async {
    final deleted = state.brochures.where((e) => ids.contains(e.id)).toList();

    state = state.copyWith(
      brochures: state.brochures.where((e) => !ids.contains(e.id)).toList(),
      loadingIds: {...state.loadingIds, ...ids},
      clearError: true,
    );

    final result = await ref
        .read(deleteBrochureUseCaseProvider)
        .many(
          accessCode: accessCode,
          ids: ids,
        );
    state = state.copyWith(loadingIds: state.loadingIds..removeAll(ids));
    switch (result) {
      case Success():
        await loadBrochures(accessCode: accessCode);
      case FailureResult(:final failure):
        if (failure is AccessCodeFailure) {
          state = state.copyWith(
            brochures: [...state.brochures, ...deleted]
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
            accessCodeInvalid: true,
            error: failure.message,
          );
        } else {
          state = state.copyWith(
            brochures: [...state.brochures, ...deleted]
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
            error: failure.message,
          );
        }
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
