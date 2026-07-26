import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../config/ui_strings.dart';

enum LessonNodeState { locked, unlocked, current, completed }

/// Wraps the node with a bright circular progress ring showing how much
/// of the lesson's chapters/sections are complete.
///
/// Two modes:
///  - Continuous: pass [progress] (0.0–1.0), leave [chapterCount] null.
///  - Segmented: pass [chapterCount] + [completedChapters] to draw one
///    arc per chapter with small gaps between them.
class LessonNode extends StatelessWidget {
  final String title;
  final LessonNodeState state;
  final bool isStarted;
  final VoidCallback? onTap;
  final double size;

  /// 0.0–1.0 overall progress. Ignored if [chapterCount] is set.
  final double progress;

  /// If provided, draws a segmented ring instead of a continuous one.
  final int? chapterCount;
  final int completedChapters;

  /// Color of the filled portion of the progress ring. Defaults to a
  /// lighter shade of the node's own state color, so it matches but
  /// still stands out against the node fill.
  final Color? ringColor;

  /// Stroke width of the ring itself.
  final double ringStrokeWidth;

  const LessonNode({
    super.key,
    required this.title,
    required this.state,
    this.isStarted = false,
    required this.onTap,
    this.size = 76,
    this.progress = 0.0,
    this.chapterCount,
    this.completedChapters = 0,
    this.ringColor,
    this.ringStrokeWidth = 5,
  });

  Color _baseColor(BuildContext context) {
    switch (state) {
      case LessonNodeState.locked:
        return Colors.grey.shade400;
      case LessonNodeState.unlocked:
      case LessonNodeState.current:
        return Theme.of(context).colorScheme.primary;
      case LessonNodeState.completed:
        return Colors.amber.shade600;
    }
  }

  IconData _icon() {
    switch (state) {
      case LessonNodeState.locked:
        return Icons.lock_outline;
      case LessonNodeState.unlocked:
      case LessonNodeState.current:
        return Icons.star_rounded;
      case LessonNodeState.completed:
        return Icons.check_rounded;
    }
  }

  bool get _showsProgress =>
      state != LessonNodeState.locked &&
      state != LessonNodeState.completed &&
      (chapterCount != null ? completedChapters > 0 : progress > 0);

  /// Darkens [color] so the ring reads as "the node's color, but deeper"
  /// instead of blending flat into the node fill.
  Color _ringAccent(Color color) {
    final hsl = HSLColor.fromColor(color);
    final darker = hsl.withLightness((hsl.lightness - 0.05).clamp(0.0, 0.90));
    return darker.toColor();
  }

  @override
  Widget build(BuildContext context) {
    final color = _baseColor(context);
    final isTappable = onTap != null;
    final accent = ringColor ?? _ringAccent(color);

    final innerNode = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 0,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(color: Colors.white, width: 4),
      ),
      child: Icon(_icon(), color: Colors.white, size: size * 0.45),
    );

    // Ring sits flush against the node's outer edge — the box is only
    // as big as the node itself plus exactly the ring's own stroke width,
    // so it scales automatically with `size` and never leaves a gap.
    final ringBoxSize = size + ringStrokeWidth * 2;
    final node = _showsProgress
        ? SizedBox(
            width: ringBoxSize,
            height: ringBoxSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(
                    begin: 0,
                    end: chapterCount != null
                        ? completedChapters / chapterCount!
                        : progress.clamp(0.0, 1.0),
                  ),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) => CustomPaint(
                    size: Size(ringBoxSize, ringBoxSize),
                    painter: _ProgressRingPainter(
                      progress: value,
                      segments: chapterCount,
                      color: accent,
                      trackColor: Colors.grey.shade300,
                      strokeWidth: ringStrokeWidth,
                    ),
                  ),
                ),
                innerNode,
              ],
            ),
          )
        : innerNode;

    final labeled = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (state == LessonNodeState.current)
          _StartBubble(color: color, isStarted: isStarted),
        node,
        const SizedBox(height: 6),
        SizedBox(
          width: size + 24,
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: state == LessonNodeState.current ? 14 : 12,
              color: state == LessonNodeState.locked ? Colors.grey : null,
            ),
          ),
        ),
      ],
    );

    return GestureDetector(
      onTap: onTap,
      child: Opacity(opacity: isTappable ? 1.0 : 0.7, child: labeled),
    );
  }
}

/// Draws either a smooth continuous arc or a segmented ring (one arc per
/// chapter with a small gap between each) around the node.
class _ProgressRingPainter extends CustomPainter {
  /// 0.0–1.0
  final double progress;

  /// Null = continuous ring. Non-null = number of chapter segments.
  final int? segments;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  _ProgressRingPainter({
    required this.progress,
    required this.segments,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const start = -math.pi / 2; // 12 o'clock

    if (segments == null || segments! <= 1) {
      // Continuous mode.
      canvas.drawCircle(center, radius, trackPaint);
      if (progress > 0) {
        canvas.drawArc(
          rect,
          start,
          2 * math.pi * progress,
          false,
          progressPaint,
        );
      }
      return;
    }

    // Segmented mode: one arc per chapter with a fixed gap between them.
    final n = segments!;
    const gapRadians = 0.10; // visual gap between segments
    final sweepPerSegment = (2 * math.pi - gapRadians * n) / n;
    final filledCount = (progress * n).round().clamp(0, n);

    for (var i = 0; i < n; i++) {
      final segStart = start + i * (sweepPerSegment + gapRadians);
      canvas.drawArc(
        rect,
        segStart,
        sweepPerSegment,
        false,
        i < filledCount ? progressPaint : trackPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.segments != segments ||
        oldDelegate.color != color;
  }
}

class _StartBubble extends StatefulWidget {
  final Color color;
  final bool isStarted;

  const _StartBubble({required this.color, required this.isStarted});

  @override
  State<_StartBubble> createState() => _StartBubbleState();
}

class _StartBubbleState extends State<_StartBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(
        begin: 0.95,
        end: 1.05,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: Text(
          widget.isStarted ? UIStrings.continueCapsLabel : UIStrings.startLabel,
          softWrap: false,
          overflow: TextOverflow.visible,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
