import 'dart:math';
import 'package:flutter/material.dart';

/// A small bird drawn directly with CustomPainter (not an emoji, which
/// faces the wrong way in most fonts and can't have its wing genuinely
/// animated). Explicitly drawn facing right/forward — matches its
/// left-to-right travel direction — with a wing that rotates through an
/// open/closed flap cycle rather than just scaling.
class FlyingBird extends StatefulWidget {
  final double travelWidth;
  final Duration period;
  final double size;
  final Color color;

  const FlyingBird({
    super.key,
    required this.travelWidth,
    this.period = const Duration(seconds: 8),
    this.size = 32,
    this.color = const Color(0xFF5B6B7A),
  });

  @override
  State<FlyingBird> createState() => _FlyingBirdState();
}

class _FlyingBirdState extends State<FlyingBird>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.period,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;
        final dx = progress * widget.travelWidth;
        final dy = 14 * sin(progress * 2 * pi * 2);
        final wingPhase = sin(progress * 2 * pi * 10);

        return Transform.translate(
          offset: Offset(dx, dy),
          child: CustomPaint(
            size: Size(widget.size, widget.size * 0.7),
            painter: _BirdPainter(wingPhase: wingPhase, color: widget.color),
          ),
        );
      },
    );
  }
}

class _BirdPainter extends CustomPainter {
  final double wingPhase; // -1 (down-stroke) .. 1 (up-stroke)
  final Color color;

  _BirdPainter({required this.wingPhase, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final bodyPaint = Paint()..color = color;
    final w = size.width;
    final h = size.height;

    final bodyRect = Rect.fromCenter(
      center: Offset(w * 0.5, h * 0.55),
      width: w * 0.55,
      height: h * 0.5,
    );
    canvas.drawOval(bodyRect, bodyPaint);

    final headCenter = Offset(w * 0.82, h * 0.4);
    canvas.drawCircle(headCenter, h * 0.2, bodyPaint);

    final beakPaint = Paint()..color = Colors.orange.shade700;
    final beakPath = Path()
      ..moveTo(headCenter.dx + h * 0.16, headCenter.dy)
      ..lineTo(headCenter.dx + h * 0.36, headCenter.dy - h * 0.04)
      ..lineTo(headCenter.dx + h * 0.16, headCenter.dy + h * 0.1)
      ..close();
    canvas.drawPath(beakPath, beakPaint);

    final tailPaint = Paint()..color = color.withValues(alpha: 0.85);
    final tailBase = Offset(w * 0.22, h * 0.55);
    final tailPath = Path()
      ..moveTo(tailBase.dx, tailBase.dy - h * 0.08)
      ..lineTo(tailBase.dx - w * 0.22, tailBase.dy - h * 0.12)
      ..lineTo(tailBase.dx, tailBase.dy + h * 0.05)
      ..close();
    canvas.drawPath(tailPath, tailPaint);

    final shoulder = Offset(w * 0.48, h * 0.42);
    final wingSpan = w * 0.55;
    final wingPaint = Paint()..color = color.withValues(alpha: 0.95);

    final wingPath = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(-wingSpan * 0.55, -h * 0.18, -wingSpan, -h * 0.02)
      ..quadraticBezierTo(-wingSpan * 0.5, h * 0.22, 0, 0)
      ..close();

    canvas.save();
    canvas.translate(shoulder.dx, shoulder.dy);
    canvas.rotate(-wingPhase * 0.85);
    canvas.drawPath(wingPath, wingPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BirdPainter oldDelegate) =>
      oldDelegate.wingPhase != wingPhase;
}
