import 'package:flutter/material.dart';

class DashedPathPainter extends CustomPainter {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  DashedPathPainter({
    required this.points,
    this.color = const Color(0xFFE0E0E0),
    this.strokeWidth = 6,
    this.dashLength = 10,
    this.gapLength = 8,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length - 1; i++) {
      _drawDashedSegment(canvas, points[i], points[i + 1], paint);
    }
  }

  void _drawDashedSegment(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint,
  ) {
    final totalDistance = (end - start).distance;
    if (totalDistance == 0) return;

    final direction = (end - start) / totalDistance;
    double covered = 0;
    bool drawing = true;

    while (covered < totalDistance) {
      final segmentLength = drawing ? dashLength : gapLength;
      final next = (covered + segmentLength).clamp(0, totalDistance);
      if (drawing) {
        canvas.drawLine(
          start + direction * covered,
          start + direction * next.toDouble(),
          paint,
        );
      }
      covered = next.toDouble();
      drawing = !drawing;
    }
  }

  @override
  bool shouldRepaint(covariant DashedPathPainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.color != color;
}
