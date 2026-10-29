import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/widgets/app_text_field.dart';

void main() {
  Widget buildApp(Widget field) => MaterialApp(
    locale: const Locale('ar'),
    supportedLocales: const [Locale('ar')],
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    builder: (context, child) {
      AppSize.init(context);
      return Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      );
    },
    home: Scaffold(
      body: Center(child: SizedBox(width: 300, child: field)),
    ),
  );

  AppTextField numberField(TextEditingController controller) => AppTextField(
    controller: controller,
    keyboardType: TextInputType.number,
  );

  testWidgets('lays digits out left-to-right inside the RTL app', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(buildApp(numberField(controller)));
    await tester.pumpAndSettle();

    final field = tester.widget<TextField>(find.byType(TextField));

    expect(field.textDirection, TextDirection.ltr);
    expect(field.textAlign, TextAlign.right);
  });

  testWidgets('deletes from the end of the number', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(buildApp(numberField(controller)));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '123');
    await tester.pump();

    controller.selection = const TextSelection.collapsed(offset: 3);
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.pump();

    expect(controller.text, '12');
  });
}
