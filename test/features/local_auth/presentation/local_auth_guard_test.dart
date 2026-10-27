import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:car_register/features/local_auth/data/local_auth_service.dart';
import 'package:car_register/features/local_auth/domain/local_auth_result.dart';
import 'package:car_register/features/local_auth/presentation/local_auth_guard.dart';

import '../fakes/fake_local_auth_service.dart';

void main() {
  late FakeLocalAuthService service;
  late ProviderContainer container;
  late LocalAuthResult? result;
  late bool actionRan;

  setUp(() {
    service = FakeLocalAuthService();
    container = ProviderContainer(
      overrides: [localAuthServiceProvider.overrideWithValue(service)],
    );
    addTearDown(container.dispose);
    result = null;
    actionRan = false;
  });

  Widget buildApp({required bool enabled}) => UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () async {
            result = await context.runWithLocalAuth(
              enabled: enabled,
              reason: 'delete',
              action: () {
                actionRan = true;
              },
            );
          },
          child: const Text('run'),
        ),
      ),
    ),
  );

  testWidgets('skips auth when the guard is disabled', (tester) async {
    await tester.pumpWidget(buildApp(enabled: false));
    await tester.tap(find.text('run'));
    await tester.pumpAndSettle();

    expect(actionRan, isTrue);
    expect(result, LocalAuthResult.success);
    expect(service.authenticateCalls, 0);
  });

  testWidgets('runs the action after successful authentication', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp(enabled: true));
    await tester.tap(find.text('run'));
    await tester.pumpAndSettle();

    expect(actionRan, isTrue);
    expect(result, LocalAuthResult.success);
    expect(service.authenticateCalls, 1);
    expect(service.lastReason, 'delete');
  });

  testWidgets('does not run the action when authentication is cancelled', (
    tester,
  ) async {
    service.result = LocalAuthResult.cancelled;

    await tester.pumpWidget(buildApp(enabled: true));
    await tester.tap(find.text('run'));
    await tester.pumpAndSettle();

    expect(actionRan, isFalse);
    expect(result, LocalAuthResult.cancelled);
    expect(service.authenticateCalls, 1);
  });

  testWidgets('does not run the action when device auth is unavailable', (
    tester,
  ) async {
    service.available = false;

    await tester.pumpWidget(buildApp(enabled: true));
    await tester.tap(find.text('run'));
    await tester.pumpAndSettle();

    expect(actionRan, isFalse);
    expect(result, LocalAuthResult.unavailable);
    expect(service.authenticateCalls, 0);
  });
}
