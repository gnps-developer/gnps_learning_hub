import 'dart:math';
import 'package:flutter/material.dart';
import 'forest_utils.dart';

class ForestMushroom {
  static void paint(Canvas canvas, Offset base, double scale, Random random) {
    ForestUtils.paintShadow(canvas, base, scale * 1.4, scale * 0.5);

    const capColors = [Color(0xFFC1453B), Color(0xFFB56A3C), Color(0xFFDDCBA6)];
    final capColor = capColors[random.nextInt(capColors.length)];
    final mushroomCount = 1 + random.nextInt(2);

    for (int m = 0; m < mushroomCount; m++) {
      final offset = Offset((m - mushroomCount / 2) * scale * 0.8, 0);
      final origin = base + offset;
      final h = scale * (0.8 + random.nextDouble() * 0.4);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(origin.dx, origin.dy - h * 0.25),
            width: scale * 0.28,
            height: h * 0.5,
          ),
          Radius.circular(scale * 0.12),
        ),
        Paint()..color = const Color(0xFFEFE6D2),
      );

      final capRect = Rect.fromCenter(
        center: Offset(origin.dx, origin.dy - h * 0.5),
        width: scale * 0.9,
        height: scale * 0.55,
      );
      canvas.drawArc(capRect, pi, pi, true, Paint()..color = capColor);

      if (capColor == const Color(0xFFC1453B) && random.nextDouble() < 0.8) {
        final dotPaint = Paint()..color = Colors.white.withValues(alpha: 0.85);
        canvas.drawCircle(
          Offset(origin.dx - scale * 0.18, origin.dy - h * 0.62),
          scale * 0.06,
          dotPaint,
        );
        canvas.drawCircle(
          Offset(origin.dx + scale * 0.15, origin.dy - h * 0.58),
          scale * 0.05,
          dotPaint,
        );
      }
    }
  }
}
