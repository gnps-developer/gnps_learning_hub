import 'dart:math';
import 'package:flutter/material.dart';

/// A small pulsing spark of light that drifts lazily.
class FireflySparkle extends StatefulWidget {
  final Duration period;
  final double size;

  const FireflySparkle({
    super.key,
    this.period = const Duration(seconds: 2),
    this.size = 10,
  });

  @override
  State<FireflySparkle> createState() => _FireflySparkleState();
}

class _FireflySparkleState extends State<FireflySparkle>
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
        final t = _controller.value * 2 * pi;
        final glow = 0.4 + 0.6 * (0.5 + 0.5 * sin(t));
        final dx = 5 * sin(t * 0.6);
        final dy = 5 * cos(t * 0.9);

        return Transform.translate(
          offset: Offset(dx, dy),
          child: Opacity(opacity: glow, child: child),
        );
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.yellowAccent,
          boxShadow: [
            BoxShadow(
              color: Colors.yellowAccent.withValues(alpha: 0.8),
              blurRadius: widget.size,
              spreadRadius: widget.size * 0.3,
            ),
          ],
        ),
      ),
    );
  }
}
