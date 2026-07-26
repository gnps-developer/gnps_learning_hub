import 'dart:math';
import 'package:flutter/material.dart';

/// A squirrel that hops gently in place, as if perched near a tree.
class HoppingSquirrel extends StatefulWidget {
  final Duration period;
  final double size;

  const HoppingSquirrel({
    super.key,
    this.period = const Duration(milliseconds: 1400),
    this.size = 26,
  });

  @override
  State<HoppingSquirrel> createState() => _HoppingSquirrelState();
}

class _HoppingSquirrelState extends State<HoppingSquirrel>
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
        final hop = pow(sin(_controller.value * pi), 3).toDouble();
        final dy = -10 * hop;
        final squash = 1 - 0.15 * hop;

        return Transform.translate(
          offset: Offset(0, dy),
          child: Transform.scale(scaleY: squash, child: child),
        );
      },
      child: Text('🐿️', style: TextStyle(fontSize: widget.size)),
    );
  }
}
