import 'dart:math';
import 'package:flutter/material.dart';
import 'props/forest_trail_props.dart';
import 'props/forest_tree.dart';
import 'props/forest_bush.dart';
import 'props/forest_grass_tuft.dart';
import 'props/forest_leaf_litter.dart';
import 'props/forest_log.dart';
import 'props/forest_mushroom.dart';
import 'props/forest_moss_patch.dart';

/// Draws an illustrated forest scene behind the lesson path.
///
/// This painter orchestrates the background gradient, the trail, and the
/// scattered forest scenery (trees, bushes, logs, etc.). The actual drawing
/// logic for individual elements is modularized into independent classes
/// in the props directory.
class ForestBackgroundPainter extends CustomPainter {
  final List<Offset> pathPoints;
  final double centerX;
  final double pathClearance;

  ForestBackgroundPainter({
    required this.pathPoints,
    required this.centerX,
    this.pathClearance = 65,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _paintBackground(canvas, size);
    ForestTrailProps.paintTrail(canvas, pathPoints);
    ForestTrailProps.paintCornerStones(canvas, pathPoints);
    _paintScenery(canvas, size);
  }

  void _paintBackground(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradientPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFEBF7E4), Color(0xFFD5EEC2)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);
    canvas.drawRect(rect, gradientPaint);
  }

  /// The path's x position at a given y, linearly interpolated between
  /// the two surrounding pathPoints.
  double _pathXAt(double y) {
    if (pathPoints.isEmpty) return centerX;
    if (pathPoints.length == 1) return pathPoints.first.dx;
    if (y <= pathPoints.first.dy) return pathPoints.first.dx;
    if (y >= pathPoints.last.dy) return pathPoints.last.dx;

    for (int i = 0; i < pathPoints.length - 1; i++) {
      final a = pathPoints[i];
      final b = pathPoints[i + 1];
      if (y >= a.dy && y <= b.dy) {
        final t = (y - a.dy) / (b.dy - a.dy);
        return a.dx + (b.dx - a.dx) * t;
      }
    }
    return centerX;
  }

  void _paintScenery(Canvas canvas, Size size) {
    final random = Random(7);
    const verticalStep = 38.0;

    for (double y = 6; y < size.height; y += verticalStep) {
      final localX = _pathXAt(y);
      final leftBandMax = (localX - pathClearance).clamp(20.0, size.width);
      final rightBandMin = (localX + pathClearance).clamp(0.0, size.width - 20);

      if (random.nextDouble() < 0.95 && leftBandMax > 30) {
        final x = random.nextDouble() * (leftBandMax - 30) + 10;
        ForestTree.paintTreeOrBush(
          canvas,
          Offset(x, y + random.nextDouble() * 25),
          random,
        );
      }
      if (random.nextDouble() < 0.95 && rightBandMin < size.width - 30) {
        final x =
            rightBandMin +
            random.nextDouble() * (size.width - rightBandMin - 30);
        ForestTree.paintTreeOrBush(
          canvas,
          Offset(x, y + random.nextDouble() * 25),
          random,
        );
      }

      if (random.nextDouble() < 0.5 && leftBandMax > 30) {
        final x = random.nextDouble() * (leftBandMax - 30) + 10;
        ForestBush.paint(
          canvas,
          Offset(x, y + 20 + random.nextDouble() * 15),
          14 + random.nextDouble() * 6,
        );
      }
      if (random.nextDouble() < 0.5 && rightBandMin < size.width - 30) {
        final x =
            rightBandMin +
            random.nextDouble() * (size.width - rightBandMin - 30);
        ForestBush.paint(
          canvas,
          Offset(x, y + 20 + random.nextDouble() * 15),
          14 + random.nextDouble() * 6,
        );
      }

      for (int g = 0; g < 3; g++) {
        if (random.nextDouble() < 0.7 && leftBandMax > 30) {
          final x = random.nextDouble() * (leftBandMax - 20) + 10;
          ForestGrassTuft.paint(
            canvas,
            Offset(x, y + random.nextDouble() * verticalStep),
            random,
          );
        }
        if (random.nextDouble() < 0.7 && rightBandMin < size.width - 30) {
          final x =
              rightBandMin +
              random.nextDouble() * (size.width - rightBandMin - 20);
          ForestGrassTuft.paint(
            canvas,
            Offset(x, y + random.nextDouble() * verticalStep),
            random,
          );
        }
      }

      if (random.nextDouble() < 0.6) {
        final onLeft = random.nextBool();
        final x = onLeft
            ? random.nextDouble() * (leftBandMax - 20) + 10
            : rightBandMin +
                  random.nextDouble() * (size.width - rightBandMin - 20);
        for (int l = 0; l < 3; l++) {
          ForestLeafLitter.paint(
            canvas,
            Offset(
              x + (random.nextDouble() - 0.5) * 18,
              y + (random.nextDouble() - 0.5) * 18,
            ),
            random,
          );
        }
      }

      if (random.nextDouble() < 0.12) {
        final onLeft = random.nextBool();
        if (onLeft && leftBandMax > 50) {
          final x = random.nextDouble() * (leftBandMax - 50) + 20;
          ForestLog.paint(
            canvas,
            Offset(x, y + 10),
            34 + random.nextDouble() * 20,
            random,
          );
        } else if (!onLeft && rightBandMin < size.width - 50) {
          final x =
              rightBandMin +
              random.nextDouble() * (size.width - rightBandMin - 50);
          ForestLog.paint(
            canvas,
            Offset(x, y + 10),
            34 + random.nextDouble() * 20,
            random,
          );
        }
      }

      if (random.nextDouble() < 0.18) {
        final onLeft = random.nextBool();
        if (onLeft && leftBandMax > 30) {
          final x = random.nextDouble() * (leftBandMax - 30) + 10;
          ForestMushroom.paint(
            canvas,
            Offset(x, y + 22 + random.nextDouble() * 10),
            6 + random.nextDouble() * 4,
            random,
          );
        } else if (!onLeft && rightBandMin < size.width - 30) {
          final x =
              rightBandMin +
              random.nextDouble() * (size.width - rightBandMin - 30);
          ForestMushroom.paint(
            canvas,
            Offset(x, y + 22 + random.nextDouble() * 10),
            6 + random.nextDouble() * 4,
            random,
          );
        }
      }

      if (random.nextDouble() < 0.25) {
        final onLeft = random.nextBool();
        if (onLeft && leftBandMax > 30) {
          final x = random.nextDouble() * (leftBandMax - 30) + 10;
          ForestMossPatch.paint(
            canvas,
            Offset(x, y + random.nextDouble() * 20),
            10 + random.nextDouble() * 8,
            random,
          );
        } else if (!onLeft && rightBandMin < size.width - 30) {
          final x =
              rightBandMin +
              random.nextDouble() * (size.width - rightBandMin - 30);
          ForestMossPatch.paint(
            canvas,
            Offset(x, y + random.nextDouble() * 20),
            10 + random.nextDouble() * 8,
            random,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant ForestBackgroundPainter oldDelegate) =>
      oldDelegate.pathPoints != pathPoints || oldDelegate.centerX != centerX;
}
