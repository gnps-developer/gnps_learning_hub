import 'dart:math';
import 'package:flutter/material.dart';
import 'forest_stone.dart';
import 'forest_trail_segment.dart';
import 'forest_trail_rut.dart';
import 'forest_trail_edge_decor.dart';

/// Static drawing utilities for the forest trail and its immediate surroundings.
/// Orchestrates the different trail components into a cohesive path.
class ForestTrailProps {
  static void paintTrail(Canvas canvas, List<Offset> pathPoints) {
    if (pathPoints.length < 2) return;
    final random = Random(11);

    for (int i = 0; i < pathPoints.length - 1; i++) {
      final start = pathPoints[i];
      final end = pathPoints[i + 1];
      final baseWidth = 42 + random.nextDouble() * 16;

      // 1. Draw the base dirt path
      ForestTrailSegment.paint(canvas, start, end, baseWidth, random);

      // 2. Draw the path ruts/tracks
      ForestTrailRut.paint(canvas, start, end, baseWidth, random);

      // 3. Draw edge decorations (pebbles, grass, leaf litter)
      ForestTrailEdgeDecor.paint(canvas, start, end, baseWidth, random);
    }
  }

  static void paintCornerStones(Canvas canvas, List<Offset> pathPoints) {
    if (pathPoints.length < 2) return;
    final random = Random(29);

    for (int i = 0; i < pathPoints.length; i++) {
      final point = pathPoints[i];

      double bendDir;
      if (i > 0 && i < pathPoints.length - 1) {
        final prev = pathPoints[i - 1];
        final next = pathPoints[i + 1];
        bendDir = (point.dx - prev.dx) - (next.dx - point.dx);
      } else if (i == 0) {
        bendDir = point.dx - pathPoints[1].dx;
      } else {
        bendDir = point.dx - pathPoints[i - 1].dx;
      }
      final side = bendDir >= 0 ? 1 : -1;

      final stoneCount = 5 + random.nextInt(4);
      for (int s = 0; s < stoneCount; s++) {
        final along = (random.nextDouble() - 0.5) * 60;
        final across = side * (28 + random.nextDouble() * 42);
        final stonePoint = point + Offset(across, along);
        final radius = 3 + random.nextDouble() * 5.5;
        ForestStone.paint(canvas, stonePoint, radius, random);
      }

      for (int s = 0; s < 2; s++) {
        final along = (random.nextDouble() - 0.5) * 40;
        final across = -side * (10 + random.nextDouble() * 20);
        final pebblePoint = point + Offset(across, along);
        canvas.drawCircle(
          pebblePoint,
          2 + random.nextDouble() * 2,
          Paint()..color = const Color(0xFFAFA089).withValues(alpha: 0.8),
        );
      }
    }
  }
}
