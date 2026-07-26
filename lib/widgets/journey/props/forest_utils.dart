import 'dart:math';
import 'package:flutter/material.dart';

/// Shared drawing utilities for forest scenery.
class ForestUtils {
  /// Soft, blurred ellipse used as a drop shadow under scenery objects.
  static void paintShadow(
    Canvas canvas,
    Offset base,
    double radiusX,
    double radiusY,
  ) {
    final paint = Paint()
      ..color = const Color(0xFF2B3A1E).withValues(alpha: 0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(base.dx + radiusX * 0.18, base.dy + radiusY * 0.35),
        width: radiusX * 2,
        height: radiusY,
      ),
      paint,
    );
  }

  /// Generates a wobbly, organic path for foliage blobs.
  static Path organicBlobPath(
    Offset center,
    double radius,
    Random random, {
    int points = 10,
    double irregularity = 0.24,
    double flatten = 0.92,
  }) {
    final angles = List.generate(points, (i) => (i / points) * 2 * pi);
    final pts = List.generate(points, (i) {
      final a = angles[i];
      final r =
          radius * (1 - irregularity / 2 + random.nextDouble() * irregularity);
      return center + Offset(cos(a) * r, sin(a) * r * flatten);
    });

    final path = Path();
    final startMid = Offset(
      (pts[0].dx + pts.last.dx) / 2,
      (pts[0].dy + pts.last.dy) / 2,
    );
    path.moveTo(startMid.dx, startMid.dy);
    for (int i = 0; i < points; i++) {
      final curr = pts[i];
      final next = pts[(i + 1) % points];
      final mid = Offset((curr.dx + next.dx) / 2, (curr.dy + next.dy) / 2);
      path.quadraticBezierTo(curr.dx, curr.dy, mid.dx, mid.dy);
    }
    path.close();
    return path;
  }
}
