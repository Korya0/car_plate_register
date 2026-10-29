import 'package:flutter/material.dart';

import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/theme/app_colors.dart';

class HomePageHeaderCurve extends StatelessWidget {
  const HomePageHeaderCurve({super.key});

  @override
  Widget build(BuildContext context) => const CustomPaint(
    painter: _HomePageHeaderCurvePainter(),
  );
}

class _HomePageHeaderCurvePainter extends CustomPainter {
  const _HomePageHeaderCurvePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height * 0.48)
      ..cubicTo(
        size.width * 0.2,
        size.height * 0.3,
        size.width * 0.38,
        size.height * 0.58,
        size.width * 0.56,
        size.height * 0.48,
      )
      ..cubicTo(
        size.width * 0.73,
        size.height * 0.44,
        size.width * 0.9,
        size.height * 0.3,
        size.width,
        size.height * 0.16,
      );
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppSize.borderWidthThick
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_HomePageHeaderCurvePainter oldDelegate) => false;
}
