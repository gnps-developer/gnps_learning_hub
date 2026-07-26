import 'dart:math';
import 'package:flutter/material.dart';

class ForestLeafLitter {
  static const _colors = [
    Color(0xFFB5883D),
    Color(0xFFD99A3E),
    Color(0xFFC96A3D),
    Color(0xFF8FAE5C),
  ];

  static void paint(Canvas canvas, Offset point, Random random) {
    final paint = Paint()
      ..color = _colors[random.nextInt(_colors.length)]
          .withValues(alpha: 0.75);
    canvas.save();
    canvas.translate(point.dx, point.dy);
    canvas.rotate(random.nextDouble() * pi);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 7, height: 4),
      paint,
    );
    canvas.restore();
  }
}
