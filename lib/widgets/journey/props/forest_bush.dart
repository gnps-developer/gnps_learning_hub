import 'package:flutter/material.dart';
import 'forest_utils.dart';

class ForestBush {
  static void paint(Canvas canvas, Offset base, double radius) {
    ForestUtils.paintShadow(canvas, base, radius * 1.3, radius * 0.5);

    final colors = [const Color(0xFF7BB566), const Color(0xFF669C55)];
    for (int i = 0; i < 3; i++) {
      final paint = Paint()..color = colors[i % colors.length];
      final offset = Offset(base.dx + (i - 1) * radius * 0.6, base.dy);
      canvas.drawCircle(offset, radius * 0.7, paint);
    }
  }
}
