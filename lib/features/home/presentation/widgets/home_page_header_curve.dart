import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/theme/app_colors.dart';
import 'package:car_register/core/utils/context_extension.dart';

class HomePageHeaderCurve extends StatelessWidget {
  const HomePageHeaderCurve({super.key});

  @override
  Widget build(BuildContext context) {
    // Reduced motion: show the finished curve without animating.
    if (context.reduceMotion) {
      return const CustomPaint(
        painter: HomePageHeaderCurvePainter(progress: 1),
      );
    }

    return const CustomPaint(
      painter: HomePageHeaderCurvePainter(progress: 0),
    ).animate().custom(
      delay: AppConstants.homeHeaderCurveDelay300ms,
      duration: AppConstants.homeHeaderCurveDraw900ms,
      curve: Curves.easeOutCubic,
      begin: 0,
      end: 1,
      builder: (context, value, _) => CustomPaint(
        painter: HomePageHeaderCurvePainter(progress: value),
      ),
    );
  }
}

// Draws the header wave, revealing it from the bottom end up to the top tip.
class HomePageHeaderCurvePainter extends CustomPainter {
  const HomePageHeaderCurvePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final path = drawnPath(size);
    if (path == null) return;

    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppSize.borderWidthThick
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, paint);
  }

  // Visible part of the wave for the current progress; null when nothing shows.
  Path? drawnPath(Size size) {
    final value = progress.clamp(0.0, 1.0);
    if (value <= 0) return null;

    return _revealed(_curvePath(size), value);
  }

  // Same wave shape as before the animation.
  Path _curvePath(Size size) => Path()
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

  // Extracts the drawn part of the wave for the current progress.
  Path _revealed(Path path, double value) {
    if (value >= 1) return path;

    final metric = path.computeMetrics().first;
    final length = metric.length;
    if (length == 0) return path;

    return metric.extractPath(0, length * value);
  }

  @override
  bool shouldRepaint(HomePageHeaderCurvePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
