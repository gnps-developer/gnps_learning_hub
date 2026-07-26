import 'dart:math';
import 'package:flutter/material.dart';
import 'forest_grass_tuft.dart';
import 'forest_leaf_litter.dart';

class ForestTrailEdgeDecor {
  static void paint(
    Canvas canvas,
    Offset start,
    Offset end,
    double baseWidth,
    Random random,
  ) {
    // Edge grass and dirt patches
    for (int j = 0; j < 10; j++) {
      final t = random.nextDouble();
      final onLine = Offset.lerp(start, end, t)!;
      final edgeSide = random.nextBool() ? -1 : 1;
      final edgeDist = baseWidth * 0.5 + (random.nextDouble() - 0.4) * 10;
      final point = onLine + Offset(edgeSide * edgeDist, 0);

      if (random.nextDouble() < 0.6) {
        ForestGrassTuft.paint(canvas, point, random);
      } else {
        final dirtPaint = Paint()
          ..color = const Color(0xFFC9AF7C).withValues(alpha: 0.5);
        canvas.drawOval(
          Rect.fromCenter(
            center: point,
            width: 6 + random.nextDouble() * 8,
            height: 3 + random.nextDouble() * 4,
          ),
          dirtPaint,
        );
      }
    }

    // Pebbles and leaf litter
    for (int j = 0; j < 4; j++) {
      final t = random.nextDouble();
      final base = Offset.lerp(start, end, t)!;
      final jitter = Offset(
        (random.nextDouble() - 0.5) * 30,
        (random.nextDouble() - 0.5) * 10,
      );
      final point = base + jitter;

      if (random.nextBool()) {
        final pebblePaint = Paint()
          ..color = const Color(0xFFAFA089).withValues(alpha: 0.8);
        canvas.drawCircle(point, 2.5 + random.nextDouble() * 2, pebblePaint);
      } else {
        ForestLeafLitter.paint(canvas, point, random);
      }
    }

    // Outer grass border
    for (int j = 0; j < 7; j++) {
      final t = random.nextDouble();
      final base = Offset.lerp(start, end, t)!;
      final side = random.nextBool() ? -1 : 1;
      final edgeOffset = Offset(side * (24 + random.nextDouble() * 14), 0);
      ForestGrassTuft.paint(canvas, base + edgeOffset, random);
    }
  }
}
