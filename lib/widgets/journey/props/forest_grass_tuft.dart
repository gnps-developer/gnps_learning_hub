import 'dart:math';
import 'package:flutter/material.dart';

class ForestGrassTuft {
  static void paint(Canvas canvas, Offset base, Random random) {
    final paint = Paint()
      ..color = const Color(0xFF6FA85C).withValues(alpha: 0.85)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (int blade = 0; blade < 3; blade++) {
      final angle =
          -pi / 2 + (blade - 1) * 0.4 + (random.nextDouble() - 0.5) * 0.2;
      final length = 8 + random.nextDouble() * 7;
      final tip = base + Offset(cos(angle), sin(angle)) * length;
      canvas.drawLine(base, tip, paint);
    }
  }
}
