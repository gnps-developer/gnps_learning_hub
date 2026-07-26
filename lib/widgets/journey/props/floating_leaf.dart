import 'dart:math';
import 'package:flutter/material.dart';

/// A small leaf that sways side to side and rotates gently, as if caught
/// in a light breeze. Purely decorative, positioned absolutely by the
/// parent (see LessonPath).
class FloatingLeaf extends StatefulWidget {
  final double size;
  final Duration period;

  const FloatingLeaf({
    super.key,
    this.size = 22,
    this.period = const Duration(seconds: 3),
  });

  @override
  State<FloatingLeaf> createState() => _FloatingLeafState();
}

class _FloatingLeafState extends State<FloatingLeaf>
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
        final swayX = 6 * sin(t);
        final rotation = 0.15 * sin(t * 0.8);
        return Transform.translate(
          offset: Offset(swayX, 0),
          child: Transform.rotate(angle: rotation, child: child),
        );
      },
      child: Icon(Icons.eco, color: Colors.green.shade400, size: widget.size),
    );
  }
}
