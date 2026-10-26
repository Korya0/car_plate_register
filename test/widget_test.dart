import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:car_register/app.dart';
import 'package:car_register/core/constants/app_strings.dart';

void main() {
  testWidgets('renders the Arabic home view', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: CarRegisterApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.homeTitle), findsOneWidget);
    expect(find.text(AppStrings.homeSubtitle), findsOneWidget);
    expect(find.text(AppStrings.emptyTitle), findsOneWidget);
    expect(find.text(AppStrings.settingsTab), findsOneWidget);
  });
}
