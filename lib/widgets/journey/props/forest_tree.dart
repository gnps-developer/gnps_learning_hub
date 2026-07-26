import 'dart:math';
import 'package:flutter/material.dart';
import 'forest_utils.dart';
import 'forest_bush.dart';

class ForestTree {
  /// Entry point that decides whether to paint a bush, a pine tree, or a deciduous tree.
  static void paintTreeOrBush(Canvas canvas, Offset base, Random random) {
    final isBush = random.nextDouble() < 0.3;
    if (isBush) {
      ForestBush.paint(canvas, base, 18 + random.nextDouble() * 10);
      return;
    }
    final foliageRadius = 24 + random.nextDouble() * 18;
    final isPine = random.nextDouble() < 0.4;
    if (isPine) {
      _paintPineTree(canvas, base, foliageRadius * 1.9, random);
    } else {
      _paintDeciduousTree(canvas, base, foliageRadius, random);
    }
  }

  static void _paintDeciduousTree(
    Canvas canvas,
    Offset base,
    double foliageRadius,
    Random random,
  ) {
    ForestUtils.paintShadow(canvas, base, foliageRadius * 0.95, foliageRadius * 0.42);

    final trunkTop = Offset(base.dx, base.dy - foliageRadius * 0.15);
    final trunkBase = Offset(base.dx, base.dy + foliageRadius * 0.55);
    final trunkTopWidth = foliageRadius * 0.16;
    final trunkBaseWidth = foliageRadius * 0.32;
    final trunkLean = (random.nextDouble() - 0.5) * foliageRadius * 0.08;

    final trunkPath = Path()
      ..moveTo(trunkTop.dx - trunkTopWidth / 2, trunkTop.dy)
      ..lineTo(trunkTop.dx + trunkTopWidth / 2, trunkTop.dy)
      ..lineTo(trunkBase.dx + trunkBaseWidth / 2 + trunkLean, trunkBase.dy)
      ..lineTo(trunkBase.dx - trunkBaseWidth / 2 + trunkLean, trunkBase.dy)
      ..close();

    final trunkRect = trunkPath.getBounds();
    canvas.drawPath(
      trunkPath,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF725640), Color(0xFF95744F), Color(0xFF7A5C3E)],
          stops: [0.0, 0.55, 1.0],
        ).createShader(trunkRect),
    );

    final barkPaint = Paint()
      ..color = const Color(0xFF5E4630).withValues(alpha: 0.5)
      ..strokeWidth = 1;
    for (int i = -1; i <= 1; i++) {
      canvas.drawLine(
        Offset(trunkTop.dx + i * trunkTopWidth * 0.28, trunkTop.dy + 2),
        Offset(
          trunkBase.dx + i * trunkBaseWidth * 0.28 + trunkLean,
          trunkBase.dy - 2,
        ),
        barkPaint,
      );
    }
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(trunkBase.dx + trunkLean, trunkBase.dy),
        width: trunkBaseWidth * 1.6,
        height: trunkBaseWidth * 0.5,
      ),
      Paint()..color = const Color(0xFF6E5236).withValues(alpha: 0.35),
    );

    final hueShift = random.nextDouble();
    final darkGreen = Color.lerp(
      const Color(0xFF365E30),
      const Color(0xFF3F7238),
      hueShift,
    )!;
    final midGreen = Color.lerp(
      const Color(0xFF54924A),
      const Color(0xFF6FA85C),
      hueShift,
    )!;
    final lightGreen = Color.lerp(
      const Color(0xFF80B86A),
      const Color(0xFF9BCB82),
      hueShift,
    )!;

    final canopyCenter = Offset(base.dx, base.dy - foliageRadius * 0.35);
    final clusterOffsets = [
      Offset(-foliageRadius * 0.34, foliageRadius * 0.06),
      Offset(foliageRadius * 0.32, foliageRadius * 0.02),
      Offset(0, -foliageRadius * 0.4),
      Offset(-foliageRadius * 0.12, -foliageRadius * 0.15),
      Offset(foliageRadius * 0.14, -foliageRadius * 0.28),
    ];

    for (final off in clusterOffsets) {
      final center =
          canopyCenter +
          off +
          Offset(foliageRadius * 0.06, foliageRadius * 0.1);
      final r = foliageRadius * (0.5 + random.nextDouble() * 0.16);
      canvas.drawPath(
        ForestUtils.organicBlobPath(center, r, random),
        Paint()..color = darkGreen.withValues(alpha: 0.85),
      );
    }

    for (final off in clusterOffsets) {
      final center = canopyCenter + off;
      final r = foliageRadius * (0.46 + random.nextDouble() * 0.16);
      canvas.drawPath(
        ForestUtils.organicBlobPath(center, r, random),
        Paint()..color = midGreen.withValues(alpha: 0.95),
      );
    }

    final dabPaint = Paint()..color = darkGreen.withValues(alpha: 0.3);
    for (int i = 0; i < 7; i++) {
      final angle = random.nextDouble() * 2 * pi;
      final dist = random.nextDouble() * foliageRadius * 0.55;
      final center =
          canopyCenter + Offset(cos(angle), sin(angle) * 0.85) * dist;
      canvas.drawCircle(
        center,
        foliageRadius * (0.07 + random.nextDouble() * 0.05),
        dabPaint,
      );
    }

    final highlightCenter =
        canopyCenter + Offset(-foliageRadius * 0.22, -foliageRadius * 0.42);
    canvas.drawPath(
      ForestUtils.organicBlobPath(
        highlightCenter,
        foliageRadius * 0.42,
        random,
        irregularity: 0.3,
      ),
      Paint()..color = lightGreen.withValues(alpha: 0.55),
    );

    final sparklePaint = Paint()..color = lightGreen.withValues(alpha: 0.55);
    for (int i = 0; i < 5; i++) {
      final angle = pi * 1.1 + random.nextDouble() * pi * 0.6;
      final dist = random.nextDouble() * foliageRadius * 0.38;
      final center = highlightCenter + Offset(cos(angle), sin(angle)) * dist;
      canvas.drawCircle(
        center,
        foliageRadius * (0.04 + random.nextDouble() * 0.03),
        sparklePaint,
      );
    }
  }

  static void _paintPineTree(
    Canvas canvas,
    Offset base,
    double height,
    Random random,
  ) {
    ForestUtils.paintShadow(canvas, base, height * 0.32, height * 0.16);

    final trunkPaint = Paint()..color = const Color(0xFF6E5236);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(base.dx, base.dy - height * 0.04),
          width: height * 0.09,
          height: height * 0.22,
        ),
        const Radius.circular(2),
      ),
      trunkPaint,
    );

    const tiers = 4;
    final tierColors = [
      const Color(0xFF2F5B2A),
      const Color(0xFF3D6B36),
      const Color(0xFF4B7F42),
      const Color(0xFF5C9650),
    ];

    for (int t = 0; t < tiers; t++) {
      final progress = t / (tiers - 1);
      final tierY = base.dy - height * 0.1 - t * height * 0.19;
      final tierWidth = height * (0.62 - t * 0.12);
      final tierDepth = height * 0.22;

      final top = Offset(
        base.dx + (random.nextDouble() - 0.5) * height * 0.03,
        tierY - tierDepth,
      );
      final leftBase = Offset(
        base.dx - tierWidth / 2,
        tierY + tierDepth * 0.25,
      );
      final rightBase = Offset(
        base.dx + tierWidth / 2,
        tierY + tierDepth * 0.25,
      );

      final tierPath = Path()..moveTo(top.dx, top.dy);
      const notches = 5;
      for (int n = 1; n <= notches; n++) {
        final tt = n / notches;
        final edgeX = top.dx + (rightBase.dx - top.dx) * tt;
        final edgeY = top.dy + (rightBase.dy - top.dy) * tt;
        final jitter = (random.nextDouble() - 0.3) * tierWidth * 0.1;
        final dipY = (n.isOdd ? -1 : 1) * tierDepth * 0.05;
        tierPath.lineTo(edgeX + jitter, edgeY + dipY);
      }
      for (int n = notches - 1; n >= 0; n--) {
        final tt = n / notches;
        final edgeX = top.dx + (leftBase.dx - top.dx) * tt;
        final edgeY = top.dy + (leftBase.dy - top.dy) * tt;
        final jitter = (random.nextDouble() - 0.3) * tierWidth * 0.1;
        final dipY = (n.isOdd ? -1 : 1) * tierDepth * 0.05;
        tierPath.lineTo(edgeX - jitter, edgeY + dipY);
      }
      tierPath.close();

      canvas.drawPath(
        tierPath,
        Paint()..color = tierColors[t].withValues(alpha: 0.95),
      );
      canvas.drawPath(
        tierPath,
        Paint()
          ..color = const Color(0xFF24401F).withValues(alpha: 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.7,
      );

      final highlightPaint = Paint()
        ..color = const Color(
          0xFF8FCB78,
        ).withValues(alpha: 0.35 * (0.4 + progress * 0.6));
      final hlPath = Path()
        ..moveTo(top.dx, top.dy + tierDepth * 0.1)
        ..lineTo(leftBase.dx + tierWidth * 0.18, leftBase.dy - tierDepth * 0.05)
        ..lineTo(top.dx - tierWidth * 0.06, top.dy + tierDepth * 0.35)
        ..close();
      canvas.drawPath(hlPath, highlightPaint);
    }
  }
}
