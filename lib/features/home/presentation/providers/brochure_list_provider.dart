import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:car_register/features/home/domain/entities/brochure_entity.dart';

final brochureListProvider =
    AsyncNotifierProvider<BrochureListNotifier, List<BrochureEntity>>(
      BrochureListNotifier.new,
    );

class BrochureListNotifier extends AsyncNotifier<List<BrochureEntity>> {
  List<BrochureEntity> _deletedEntries = const [];

  // Loads in-memory entries.
  @override
  Future<List<BrochureEntity>> build() async => [];

  // Adds a unique number.
  BrochureEntity? add(String number) {
    final entries = state.value ?? const <BrochureEntity>[];
    if (entries.any((entry) => entry.number == number)) return null;

    final now = DateTime.now();
    final entry = BrochureEntity(
      id: now.microsecondsSinceEpoch,
      number: number,
      createdAt: now,
    );
    state = AsyncData([entry, ...entries]);
    return entry;
  }

  // Deletes one entry.
  BrochureEntity? delete(int id) {
    final entries = state.value ?? const <BrochureEntity>[];
    final index = entries.indexWhere((entry) => entry.id == id);
    if (index < 0) return null;

    final entry = entries[index];
    _deletedEntries = [entry];
    state = AsyncData(entries.where((item) => item.id != id).toList());
    return entry;
  }

  // Deletes all entries.
  List<BrochureEntity> deleteAll() {
    final entries = state.value ?? const <BrochureEntity>[];
    _deletedEntries = entries;
    state = const AsyncData([]);
    return entries;
  }

  // Restores the last deletion.
  void undoDelete() {
    if (_deletedEntries.isEmpty) return;

    final entries = state.value ?? const <BrochureEntity>[];
    final restored = [...entries, ..._deletedEntries]
      ..sort((first, second) => second.createdAt.compareTo(first.createdAt));
    state = AsyncData(restored);
    _deletedEntries = const [];
  }
}
