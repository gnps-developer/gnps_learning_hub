import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LetterDialWidget extends StatefulWidget {
  final List<String> letters;
  final Function(String) onWordCompleted;

  const LetterDialWidget({
    super.key,
    required this.letters,
    required this.onWordCompleted,
  });

  @override
  State<LetterDialWidget> createState() => _LetterDialWidgetState();
}

class _LetterDialWidgetState extends State<LetterDialWidget> {
  final List<int> _selectedIndices = [];
  Offset? _currentTouchPosition;

  // Tracks the tile the finger is currently resting on (or null if it's
  // over no tile right now). A letter is only appended when the finger
  // *arrives* at a tile it wasn't already resting on - not on every
  // touch-move callback while lingering there. Resetting this to null
  // whenever the finger leaves all tiles is what lets the player trace
  // back onto an already-used tile to spell a repeated letter (e.g. ਚਮਚ
  // needs the ਚ tile twice, ਸਰਕਸ needs the ਸ tile twice) - previously
  // `_selectedIndices.contains(i)` blocked a tile from ever being reused
  // within the same drag, making such words impossible to trace at all.
  int? _lastIndex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dialSize = min(constraints.maxWidth, constraints.maxHeight);
        final center = Offset(
          constraints.maxWidth / 2,
          constraints.maxHeight / 2,
        );
        // Bring letters even closer together
        final radius = dialSize * 0.26;

        return GestureDetector(
          onPanStart: (details) =>
              _handleTouch(details.localPosition, constraints),
          onPanUpdate: (details) =>
              _handleTouch(details.localPosition, constraints),
          onPanEnd: _onPanEnd,
          child: Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            color: Colors.transparent,
            child: Stack(
              children: [
                // Vibrant Theme Background Circle
                Center(
                  child: Container(
                    width: dialSize * 0.88,
                    height: dialSize * 0.88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Theme.of(context).colorScheme.secondaryContainer
                              .withValues(alpha: 0.9),
                          Theme.of(
                            context,
                          ).colorScheme.primaryContainer.withValues(alpha: 0.7),
                        ],
                      ),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.4),
                        width: 6,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.shadow.withValues(alpha: 0.2),
                          blurRadius: 25,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Opacity(
                        opacity: 0.15,
                        child: Icon(
                          Icons.park_rounded,
                          size: dialSize * 0.45,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                ),
                // Connection Lines
                CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: _LinePainter(
                    selectedIndices: _selectedIndices,
                    currentTouchPosition: _currentTouchPosition,
                    lettersCount: widget.letters.length,
                    radius: radius,
                    center: center,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                // Letters
                ...List.generate(widget.letters.length, (index) {
                  final angle =
                      (2 * pi / widget.letters.length) * index - pi / 2;
                  final pos =
                      center + Offset(cos(angle) * radius, sin(angle) * radius);
                  final isSelected = _selectedIndices.contains(index);
                  // How many times this tile has been used so far in the
                  // current trace - shown as a small badge so the player
                  // can see a repeat has registered (e.g. "x2").
                  final useCount = _selectedIndices
                      .where((i) => i == index)
                      .length;

                  return Positioned(
                    left: pos.dx - 45,
                    top: pos.dy - 45,
                    child: AnimatedScale(
                      scale: isSelected ? 1.2 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).colorScheme.shadow.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(
                                    context,
                                  ).colorScheme.onPrimary.withValues(alpha: 0.5)
                                : Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.3),
                            width: 4,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                widget.letters[index],
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                            if (useCount > 1)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'x$useCount',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleTouch(Offset localPosition, BoxConstraints constraints) {
    final center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
    final dialSize = min(constraints.maxWidth, constraints.maxHeight);
    final radius = dialSize * 0.26;

    int? hitIndex;
    for (int i = 0; i < widget.letters.length; i++) {
      final angle = (2 * pi / widget.letters.length) * i - pi / 2;
      final letterCenter =
          center + Offset(cos(angle) * radius, sin(angle) * radius);

      if ((localPosition - letterCenter).distance < 50) {
        hitIndex = i;
        break;
      }
    }

    if (hitIndex != null && hitIndex != _lastIndex) {
      // Arrived at a tile that's different from wherever the finger was
      // last (which may be "nowhere", or may even be this same tile if
      // the finger left and came back - either way, it's a fresh visit).
      setState(() {
        _selectedIndices.add(hitIndex!);
        _lastIndex = hitIndex;
      });
      HapticFeedback.lightImpact();
    } else if (hitIndex == null) {
      // Finger is over empty space between tiles - clear _lastIndex so
      // that landing back on ANY tile next, including the one just left,
      // is treated as a new visit rather than being ignored.
      _lastIndex = null;
    }

    setState(() {
      _currentTouchPosition = localPosition;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_selectedIndices.isNotEmpty) {
      final word = _selectedIndices.map((i) => widget.letters[i]).join();
      widget.onWordCompleted(word);
    }
    setState(() {
      _selectedIndices.clear();
      _currentTouchPosition = null;
      _lastIndex = null;
    });
  }
}

class _LinePainter extends CustomPainter {
  final List<int> selectedIndices;
  final Offset? currentTouchPosition;
  final int lettersCount;
  final double radius;
  final Offset center;
  final Color color;

  _LinePainter({
    required this.selectedIndices,
    required this.currentTouchPosition,
    required this.lettersCount,
    required this.radius,
    required this.center,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (selectedIndices.isEmpty) return;

    final paint = Paint()
      ..color = color.withValues(alpha: 0.7)
      ..strokeWidth = 14.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final List<Offset> points = [];
    for (final index in selectedIndices) {
      final angle = (2 * pi / lettersCount) * index - pi / 2;
      points.add(center + Offset(cos(angle) * radius, sin(angle) * radius));
    }

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    if (currentTouchPosition != null) {
      path.lineTo(currentTouchPosition!.dx, currentTouchPosition!.dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LinePainter oldDelegate) => true;
}
