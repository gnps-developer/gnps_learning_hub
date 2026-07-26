import 'dart:math';
import 'package:flutter/material.dart';

class ForestMossPatch {
  static void paint(
    Canvas canvas,
    Offset base,
    double radius,
    Random random,
  ) {
    final paint = Paint()
      ..color = const Color(0xFF5C8A4A).withValues(alpha: 0.5);
    for (int b = 0; b < 5; b++) {
      final angle = random.nextDouble() * 2 * pi;
      final dist = random.nextDouble() * radius * 0.5;
      final blobCenter = base + Offset(cos(angle), sin(angle)) * dist;
      canvas.drawCircle(
        blobCenter,
        radius * (0.4 + random.nextDouble() * 0.3),
        paint,
      );
    }
  }
}
