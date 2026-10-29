import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:car_register/features/home/presentation/providers/brochure_list_provider.dart';

void main() {
  test('keeps duplicates out and supports delete undo in memory', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(brochureListProvider.future);
    final notifier = container.read(brochureListProvider.notifier);

    final entry = notifier.add('007');

    expect(entry?.number, '007');
    expect(notifier.add('007'), isNull);
    expect(container.read(brochureListProvider).value, hasLength(1));

    notifier.delete(entry!.id);
    expect(container.read(brochureListProvider).value, isEmpty);

    notifier.undoDelete();
    expect(container.read(brochureListProvider).value?.single.number, '007');
  });
}
