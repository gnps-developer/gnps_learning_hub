import 'dart:math';
import 'package:flutter/material.dart';
import 'forest_utils.dart';
import 'forest_moss_patch.dart';

class ForestLog {
  static void paint(Canvas canvas, Offset base, double length, Random random) {
    ForestUtils.paintShadow(canvas, base, length * 0.6, length * 0.22);

    canvas.save();
    canvas.translate(base.dx, base.dy);
    canvas.rotate((random.nextDouble() - 0.5) * 0.6);

    final logRect = Rect.fromCenter(
      center: Offset.zero,
      width: length,
      height: length * 0.32,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(logRect, Radius.circular(length * 0.16)),
      Paint()..color = const Color(0xFF8B6A4A),
    );

    final grainPaint = Paint()
      ..color = const Color(0xFF6E5236).withValues(alpha: 0.6)
      ..strokeWidth = 1.2;
    for (int g = -1; g <= 1; g++) {
      canvas.drawLine(
        Offset(-length * 0.45, g * length * 0.08),
        Offset(length * 0.45, g * length * 0.08),
        grainPaint,
      );
    }

    final endCenter = Offset(length * 0.48, 0);
    canvas.drawOval(
      Rect.fromCenter(
        center: endCenter,
        width: length * 0.12,
        height: length * 0.3,
      ),
      Paint()..color = const Color(0xFFD8B992),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: endCenter,
        width: length * 0.07,
        height: length * 0.17,
      ),
      Paint()
        ..color = const Color(0xFF9C7B52)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    if (random.nextDouble() < 0.7) {
      ForestMossPatch.paint(
        canvas,
        Offset(-length * 0.1, -length * 0.1),
        length * 0.22,
        random,
      );
    }

    canvas.restore();
  }
}
