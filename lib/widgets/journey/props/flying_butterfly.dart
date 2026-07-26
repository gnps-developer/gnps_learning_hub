import 'dart:math';
import 'package:flutter/material.dart';

/// A small butterfly drawn directly with CustomPainter, built the same way
/// as the reference FlyingBird: a single wing shape is defined once and
/// mirrored with a sign flip, and the flap itself is a horizontal squash
/// (scaleX = cos(angle)) rather than a stack of independent 3D rotations.
/// This guarantees the left and right wings always move as exact mirror
/// images of each other -- there's no separate "isLeft" branch that can
/// fall out of sync.
class FlyingButterfly extends StatefulWidget {
  final double travelWidth;
  final Duration period;
  final double size;
  final bool flyLeft;
  final Color primaryColor;
  final Color secondaryColor;

  const FlyingButterfly({
    super.key,
    required this.travelWidth,
    this.period = const Duration(seconds: 9),
    this.size = 4,
    this.flyLeft = false,
    this.primaryColor = const Color(0xFFFF9F00),
    this.secondaryColor = const Color(0xFFCC3300),
  });

  @override
  State<FlyingButterfly> createState() => _FlyingButterflyState();
}

class _FlyingButterflyState extends State<FlyingButterfly>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.period,
  )..repeat();

  final Random _rng = Random();
  double _lastProgress = 0;

  // Per-loop randomized spawn variation so consecutive passes don't all
  // trace the exact same path.
  late double _yBaseOffset = _randomYOffset();
  late double _xStartJitter = _randomXJitter();
  late double _ampJitter = _randomAmpJitter();

  double _randomYOffset() => (_rng.nextDouble() - 0.5) * widget.size * 6;

  double _randomXJitter() =>
      (_rng.nextDouble() - 0.5) * widget.travelWidth * 0.3;

  double _randomAmpJitter() => 0.7 + _rng.nextDouble() * 0.6;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleTick);
  }

  void _handleTick() {
    // Detect the wrap-around from ~1.0 back to 0.0 and roll new randoms
    // for the next pass before it becomes visible again.
    if (_controller.value < _lastProgress) {
      _yBaseOffset = _randomYOffset();
      _xStartJitter = _randomXJitter();
      _ampJitter = _randomAmpJitter();
    }
    _lastProgress = _controller.value;
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTick);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;
        final t = progress * 2 * pi;

        // Flight travel path (same idea as the bird: horizontal travel +
        // a couple of stacked sine waves for a gentle bob), with a random
        // per-loop x jitter and y baseline so repeats don't overlap.
        final travel = widget.flyLeft
            ? -progress * widget.travelWidth
            : progress * widget.travelWidth;
        final dx = travel + _xStartJitter;
        final dy =
            _yBaseOffset +
            _ampJitter * (12 * sin(t * 1.5) + 4 * sin(t * 3.2 + 0.8));

        // Wing flap cycle: -1 (wings folded up) .. 1 (wings folded up the
        // other way), with 0 = wings fully open/flat. Flapping ~8x per
        // period, same order of magnitude as the bird's wingPhase.
        final wingPhase = sin(t * 8);

        // Fade in/out over the first and last 8% of each loop so the
        // butterfly never just pops into or out of existence.
        const fadeFraction = 0.08;
        double opacity = 1.0;
        if (progress < fadeFraction) {
          opacity = progress / fadeFraction;
        } else if (progress > 1 - fadeFraction) {
          opacity = (1 - progress) / fadeFraction;
        }

        return Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(dx, dy),
            child: Transform.scale(
              scaleX: widget.flyLeft ? -1.0 : 1.0,
              child: CustomPaint(
                size: Size(widget.size * 1.6, widget.size),
                painter: _ButterflyPainter(
                  wingPhase: wingPhase,
                  primaryColor: widget.primaryColor,
                  secondaryColor: widget.secondaryColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ButterflyPainter extends CustomPainter {
  final double wingPhase; // -1 .. 1
  final Color primaryColor;
  final Color secondaryColor;

  _ButterflyPainter({
    required this.wingPhase,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final centerX = w * 0.5;
    final hingeY = h * 0.45;

    // Foreshortening amount: 1 = wings fully open/flat toward viewer,
    // shrinking toward 0 as they fold up. Same wingPhase drives both
    // wings, so they are always exact mirror images of one another.
    final maxFlapAngle = pi / 2.4;
    final flapScale = cos(wingPhase * maxFlapAngle).clamp(0.12, 1.0);

    _drawBody(canvas, w, h, centerX);

    // Right wing: sign = +1 (path drawn extending to +x).
    _drawWingPair(canvas, centerX, hingeY, w, h, 1.0, flapScale);
    // Left wing: sign = -1, exact mirror of the same path.
    _drawWingPair(canvas, centerX, hingeY, w, h, -1.0, flapScale);
  }

  void _drawWingPair(
    Canvas canvas,
    double centerX,
    double hingeY,
    double w,
    double h,
    double sign,
    double flapScale,
  ) {
    final wingW = w * 0.42;
    final wingH = h * 0.85;

    // Upper wing lobe (larger, forward)
    final upperPath = Path()
      ..moveTo(0, 0)
      ..cubicTo(
        wingW * 0.3,
        -wingH * 0.4,
        wingW * 0.95,
        -wingH * 0.55,
        wingW * 0.9,
        wingH * 0.02,
      )
      ..cubicTo(wingW * 0.8, wingH * 0.35, wingW * 0.4, wingH * 0.2, 0, 0);

    // Lower wing lobe (smaller, trailing)
    final lowerPath = Path()
      ..moveTo(0, 0)
      ..cubicTo(
        wingW * 0.28,
        wingH * 0.18,
        wingW * 0.7,
        wingH * 0.32,
        wingW * 0.6,
        wingH * 0.7,
      )
      ..cubicTo(wingW * 0.42, wingH * 0.8, wingW * 0.14, wingH * 0.52, 0, 0);

    canvas.save();
    canvas.translate(centerX, hingeY);
    // sign flips the wing to the other side; flapScale squashes it toward
    // the hinge as it "folds" -- same transform, same math, both sides.
    canvas.scale(sign * flapScale, 1.0);

    final upperShader = LinearGradient(
      colors: [primaryColor, secondaryColor],
    ).createShader(upperPath.getBounds());
    _drawWingLayer(canvas, upperPath, upperShader);

    final lowerShader = LinearGradient(
      colors: [secondaryColor, primaryColor],
    ).createShader(lowerPath.getBounds());
    _drawWingLayer(canvas, lowerPath, lowerShader);

    canvas.restore();
  }

  void _drawWingLayer(Canvas canvas, Path path, Shader shader) {
    canvas.drawPath(path, Paint()..shader = shader);
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF1A1A1A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void _drawBody(Canvas canvas, double w, double h, double centerX) {
    final bodyPaint = Paint()..color = const Color(0xFF242424);

    // Abdomen
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, h * 0.55),
        width: w * 0.12,
        height: h * 0.5,
      ),
      bodyPaint,
    );
    // Head
    canvas.drawCircle(Offset(centerX, h * 0.26), w * 0.07, bodyPaint);

    // Antennae
    final antennaPaint = Paint()
      ..color = const Color(0xFF1F1F1F)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawPath(
      Path()
        ..moveTo(centerX - 1, h * 0.24)
        ..quadraticBezierTo(
          centerX - w * 0.18,
          h * 0.14,
          centerX - w * 0.28,
          h * 0.08,
        ),
      antennaPaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(centerX + 1, h * 0.24)
        ..quadraticBezierTo(
          centerX + w * 0.18,
          h * 0.14,
          centerX + w * 0.28,
          h * 0.08,
        ),
      antennaPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ButterflyPainter oldDelegate) =>
      oldDelegate.wingPhase != wingPhase;
}
