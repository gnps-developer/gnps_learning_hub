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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final dialSize = min(constraints.maxWidth, constraints.maxHeight);
      final center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
      // Bring letters even closer together
      final radius = dialSize * 0.26; 

      return GestureDetector(
        onPanStart: (details) => _handleTouch(details.localPosition, constraints),
        onPanUpdate: (details) => _handleTouch(details.localPosition, constraints),
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
                        Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.9),
                        Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.7),
                      ],
                    ),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                      width: 6,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 25,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: Center(
                    child: Opacity(
                      opacity: 0.15,
                      child: Icon(
                        Icons.park_rounded,
                        size: dialSize * 0.45,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                final angle = (2 * pi / widget.letters.length) * index - pi / 2;
                final pos = center + Offset(cos(angle) * radius, sin(angle) * radius);
                final isSelected = _selectedIndices.contains(index);

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
                            : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ],
                        border: Border.all(
                          color: isSelected 
                            ? Colors.white 
                            : Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                          width: 4,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          widget.letters[index],
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      );
    });
  }

  void _handleTouch(Offset localPosition, BoxConstraints constraints) {
    final center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
    final dialSize = min(constraints.maxWidth, constraints.maxHeight);
    final radius = dialSize * 0.26;

    for (int i = 0; i < widget.letters.length; i++) {
      final angle = (2 * pi / widget.letters.length) * i - pi / 2;
      final letterCenter = center + Offset(cos(angle) * radius, sin(angle) * radius);

      if ((localPosition - letterCenter).distance < 50) {
        if (!_selectedIndices.contains(i)) {
          setState(() {
            _selectedIndices.add(i);
          });
          HapticFeedback.lightImpact();
        }
      }
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
