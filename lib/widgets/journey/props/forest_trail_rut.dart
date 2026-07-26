import 'dart:math';
import 'package:flutter/material.dart';

class ForestTrailRut {
  static void paint(
    Canvas canvas,
    Offset start,
    Offset end,
    double baseWidth,
    Random random,
  ) {
    final rutPaint = Paint()
      ..color = const Color(0xFF9C8459).withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    for (final rutSide in [-1.0, 1.0]) {
      final rutPath = Path();
      const rutSegments = 8;
      for (int s = 0; s <= rutSegments; s++) {
        final t = s / rutSegments;
        final onLine = Offset.lerp(start, end, t)!;
        final wobble = (random.nextDouble() - 0.5) * 6;
        final point =
            onLine +
            Offset(rutSide * baseWidth * 0.22 + wobble, wobble * 0.5);
        if (s == 0) {
          rutPath.moveTo(point.dx, point.dy);
        } else {
          rutPath.lineTo(point.dx, point.dy);
        }
      }
      canvas.drawPath(rutPath, rutPaint);
    }
  }
}
