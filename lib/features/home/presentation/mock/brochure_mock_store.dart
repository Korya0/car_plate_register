import 'package:car_register/features/home/domain/entities/brochure_entity.dart';

class BrochureMockStore {
  BrochureMockStore._();

  // Temporary in-memory list. Delete it when Riverpod returns.
  static final List<BrochureEntity> _entries = [];

  // Preview seed: swap the line above for this list to try a filled screen.
  // static final List<BrochureEntity> _entries = [
  //   BrochureEntity(
  //     id: 1,
  //     number: '007',
  //     createdAt: DateTime(2026, 10, 29, 9, 15),
  //   ),
  //   BrochureEntity(
  //     id: 2,
  //     number: '042',
  //     createdAt: DateTime(2026, 10, 29, 9, 40),
  //   ),
  //   BrochureEntity(
  //     id: 3,
  //     number: '1284',
  //     createdAt: DateTime(2026, 10, 29, 10, 5),
  //   ),
  // ];

  // Current entries, newest first.
  static List<BrochureEntity> get entries => List.unmodifiable(_entries);

  // Adds a unique number; null when it already exists.
  static BrochureEntity? add(String number) {
    final exists = _entries.any((entry) => entry.number == number);
    if (exists) return null;

    final now = DateTime.now();
    final entry = BrochureEntity(
      id: now.microsecondsSinceEpoch,
      number: number,
      createdAt: now,
    );
    _entries.insert(0, entry);
    return entry;
  }

  // Deletes one entry; null when it is missing.
  static BrochureEntity? delete(int id) {
    final index = _entries.indexWhere((entry) => entry.id == id);
    if (index < 0) return null;

    return _entries.removeAt(index);
  }

  // Clears the mock list; used by tests and previews.
  static void reset() => _entries.clear();
}
