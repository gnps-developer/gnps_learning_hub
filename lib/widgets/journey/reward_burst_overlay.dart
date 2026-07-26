import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

/// Spawns a burst of reward icons that scatter outward from [origin] and
/// then arc into [targetKey]'s on-screen position — used to make a lesson
/// completion feel like the earned points/gems physically fly into the
/// banner's counter.
///
/// Icon and color are passed in explicitly (see RewardConfig) rather than
/// hardcoded, so this animation works unchanged whether the reward is
/// stars, gems, or anything else later.
///
/// Returns a Future that completes once every particle has landed, so
/// callers can sequence "burst, then commit points, then show dialog".
Future<void> showRewardBurst({
  required BuildContext context,
  required Offset origin,
  required GlobalKey targetKey,
  required IconData icon,
  required Color color,
  int count = 8,
}) {
  final completer = Completer<void>();
  late OverlayEntry entry;

  final targetBox = targetKey.currentContext?.findRenderObject() as RenderBox?;
  final targetOffset = targetBox != null
      ? targetBox.localToGlobal(targetBox.size.center(Offset.zero))
      : origin;

  entry = OverlayEntry(
    builder: (context) => _RewardBurst(
      origin: origin,
      target: targetOffset,
      icon: icon,
      color: color,
      count: count,
      onComplete: () {
        entry.remove();
        completer.complete();
      },
    ),
  );

  Overlay.of(context, rootOverlay: true).insert(entry);
  return completer.future;
}

class _RewardBurst extends StatefulWidget {
  final Offset origin;
  final Offset target;
  final IconData icon;
  final Color color;
  final int count;
  final VoidCallback onComplete;

  const _RewardBurst({
    required this.origin,
    required this.target,
    required this.icon,
    required this.color,
    required this.count,
    required this.onComplete,
  });

  @override
  State<_RewardBurst> createState() => _RewardBurstState();
}

class _RewardBurstState extends State<_RewardBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;

  static const _totalDuration = Duration(milliseconds: 1700);
  static const _staggerFraction = 0.45;
  static const _popInEnd = 0.18;
  static const _holdEnd = 0.82;

  @override
  void initState() {
    super.initState();
    final random = Random();

    _particles = List.generate(widget.count, (i) {
      final angle = random.nextDouble() * 2 * pi;
      final scatterDistance = 50 + random.nextDouble() * 70;
      final control =
          widget.origin + Offset(cos(angle), sin(angle)) * scatterDistance;
      final startDelay = (i / widget.count) * _staggerFraction;
      return _Particle(
        control: control,
        startDelay: startDelay,
        size: 26 + random.nextDouble() * 18,
      );
    });

    _controller = AnimationController(vsync: this, duration: _totalDuration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) widget.onComplete();
      })
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Offset _quadraticBezier(Offset p0, Offset p1, Offset p2, double t) {
    final u = 1 - t;
    return p0 * (u * u) + p1 * (2 * u * t) + p2 * (t * t);
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          for (final particle in _particles)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final localT =
                ((_controller.value - particle.startDelay) /
                    (1 - particle.startDelay))
                    .clamp(0.0, 1.0);
                final eased = Curves.easeInOutCubic.transform(localT);
                final position = _quadraticBezier(
                  widget.origin,
                  particle.control,
                  widget.target,
                  eased,
                );

                double scale;
                if (localT < _popInEnd) {
                  final popT = localT / _popInEnd;
                  scale = Curves.easeOutBack.transform(popT);
                } else if (localT < _holdEnd) {
                  scale = 1.0;
                } else {
                  final shrinkT = (localT - _holdEnd) / (1 - _holdEnd);
                  scale = 1.0 - shrinkT;
                }

                final opacity = localT > 0.9 ? (1 - (localT - 0.9) / 0.1) : 1.0;

                return Positioned(
                  left: position.dx - particle.size / 2,
                  top: position.dy - particle.size / 2,
                  child: Opacity(
                    opacity: opacity.clamp(0.0, 1.0),
                    child: Transform.scale(
                      scale: scale.clamp(0.0, 1.3),
                      child: Icon(
                        widget.icon,
                        color: widget.color,
                        size: particle.size,
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _Particle {
  final Offset control;
  final double startDelay;
  final double size;

  _Particle({
    required this.control,
    required this.startDelay,
    required this.size,
  });
}