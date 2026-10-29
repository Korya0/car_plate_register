import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/features/home/presentation/widgets/home_page_header_curve.dart';

void main() {
  const size = Size(300, 120);

  Widget buildCurve({bool reduceMotion = false}) => MaterialApp(
    builder: (context, child) {
      AppSize.init(context);
      return MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(disableAnimations: reduceMotion),
        child: child ?? const SizedBox.shrink(),
      );
    },
    home: const Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Center(
          child: SizedBox(
            width: 300,
            height: 120,
            child: HomePageHeaderCurve(),
          ),
        ),
      ),
    ),
  );

  HomePageHeaderCurvePainter painter(WidgetTester tester) =>
      tester
              .widget<CustomPaint>(
                find.descendant(
                  of: find.byType(HomePageHeaderCurve),
                  matching: find.byType(CustomPaint),
                ),
              )
              .painter!
          as HomePageHeaderCurvePainter;

  testWidgets('reveals the header curve after a delay', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildCurve());

    expect(painter(tester).progress, 0);

    await tester.pump(AppConstants.homeHeaderCurveDelay300ms);
    await tester.pump(const Duration(milliseconds: 450));

    expect(painter(tester).progress, greaterThan(0));
    expect(painter(tester).progress, lessThan(1));

    await tester.pumpAndSettle();

    expect(painter(tester).progress, 1);
  });

  testWidgets('shows the finished curve when motion is reduced', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildCurve(reduceMotion: true));

    expect(painter(tester).progress, 1);
  });

  test('reveals the wave from its bottom end up to the top tip', () {
    final half = const HomePageHeaderCurvePainter(progress: 0.5)
        .drawnPath(size)!;
    final full = const HomePageHeaderCurvePainter(progress: 1).drawnPath(size)!;

    // The start of the wave (the lower left end) is drawn first.
    expect(half.getBounds().left, closeTo(0, 0.5));
    expect(half.getBounds().right, lessThan(size.width));

    // The top-right tip only shows at the end.
    expect(full.getBounds().right, closeTo(size.width, 0.5));

    expect(
      const HomePageHeaderCurvePainter(progress: 0).drawnPath(size),
      isNull,
    );
    expect(
      half.computeMetrics().first.length,
      closeTo(full.computeMetrics().first.length / 2, 1),
    );
  });
}
