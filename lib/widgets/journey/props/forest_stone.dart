import 'dart:math';
import 'package:flutter/material.dart';
import 'forest_utils.dart';

class ForestStone {
  static void paint(Canvas canvas, Offset center, double radius, Random random) {
    const baseColors = [
      Color(0xFF9C9284),
      Color(0xFFA8A296),
      Color(0xFF8A8175),
      Color(0xFFB0AA9C),
    ];
    final base = baseColors[random.nextInt(baseColors.length)];

    ForestUtils.paintShadow(canvas, center, radius * 1.1, radius * 0.7);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(random.nextDouble() * pi);

    final path = Path();
    const sides = 7;
    for (int p = 0; p < sides; p++) {
      final angle = (p / sides) * 2 * pi;
      final r = radius * (0.8 + random.nextDouble() * 0.35);
      final x = cos(angle) * r;
      final y = sin(angle) * r * 0.85;
      if (p == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, Paint()..color = base.withValues(alpha: 0.9));
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF5F594E).withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );

    canvas.drawCircle(
      Offset(-radius * 0.25, -radius * 0.25),
      radius * 0.28,
      Paint()..color = Colors.white.withValues(alpha: 0.35),
    );

    canvas.restore();
  }
}
