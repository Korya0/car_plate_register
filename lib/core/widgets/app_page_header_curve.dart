import 'package:flutter/material.dart';

import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/theme/app_colors.dart';

class AppPageHeaderCurve extends StatelessWidget {
  const AppPageHeaderCurve({super.key});

  @override
  Widget build(BuildContext context) => const CustomPaint(
    painter: _AppPageHeaderCurvePainter(),
  );
}

class _AppPageHeaderCurvePainter extends CustomPainter {
  const _AppPageHeaderCurvePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height * 0.68)
      ..cubicTo(
        size.width * 0.2,
        size.height * 0.5,
        size.width * 0.38,
        size.height * 0.78,
        size.width * 0.56,
        size.height * 0.68,
      )
      ..cubicTo(
        size.width * 0.73,
        size.height * 0.64,
        size.width * 0.9,
        size.height * 0.5,
        size.width,
        size.height * 0.36,
      );
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppSize.borderWidth * 2
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_AppPageHeaderCurvePainter oldDelegate) => false;
}
