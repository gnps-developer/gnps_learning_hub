import 'dart:math';
import 'package:flutter/material.dart';

class ForestTrailSegment {
  static void paint(
    Canvas canvas,
    Offset start,
    Offset end,
    double baseWidth,
    Random random,
  ) {
    const segments = 6;
    for (int s = 0; s < segments; s++) {
      final t0 = s / segments;
      final t1 = (s + 1) / segments;
      final p0 = Offset.lerp(start, end, t0)!;
      final p1 = Offset.lerp(start, end, t1)!;

      final width = 42 + random.nextDouble() * 16;
      final colorMix = random.nextDouble();
      final trailPaint = Paint()
        ..color = Color.lerp(
          const Color(0xFFDCC49A),
          const Color(0xFFC9AF7C),
          colorMix,
        )!.withValues(alpha: 0.75)
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(p0, p1, trailPaint);
    }

    // Worn center line
    final wornPaint = Paint()
      ..color = const Color(0xFFE8D5AE).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = baseWidth * 0.4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(start, end, wornPaint);
  }
}
