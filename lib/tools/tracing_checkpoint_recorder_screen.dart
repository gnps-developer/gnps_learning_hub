import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/letter_ink_mask.dart';

/// DEBUG-ONLY TOOL: lets you tap directly on a rendered letter to record
/// checkpoint waypoints in the order a child should trace them. Coordinates
/// are normalized against the letter's tight ink bounding box (via
/// LetterInkMask), the exact same reference frame TraceTaskWidget uses — so
/// exported checkpoints line up correctly with zero further adjustment.
///
/// Do not route to this screen from production UI. Gate any entry point
/// (e.g. a dev-menu button) behind `kDebugMode` from `flutter/foundation.dart`.
class CheckpointRecorderScreen extends StatefulWidget {
  const CheckpointRecorderScreen({super.key});

  @override
  State<CheckpointRecorderScreen> createState() =>
      _CheckpointRecorderScreenState();
}

class _CheckpointRecorderScreenState extends State<CheckpointRecorderScreen> {
  final TextEditingController _letterController = TextEditingController();
  final TextEditingController _translitController = TextEditingController();

  String _letter = '';
  final List<List<Offset>> _strokes = [[]]; // each sub-list is one pen stroke

  LetterInkMask? _mask;
  Size? _maskSize;
  bool _isBuildingMask = false;

  @override
  void dispose() {
    _letterController.dispose();
    _translitController.dispose();
    super.dispose();
  }

  Future<void> _ensureMask(Size size) async {
    if (_letter.isEmpty) return;
    if (_isBuildingMask) return;
    if (_maskSize == size && _mask?.letter == _letter) return;

    _isBuildingMask = true;
    final mask = await LetterInkMask.build(size, _letter);
    if (!mounted) return;
    setState(() {
      _mask = mask;
      _maskSize = size;
      _isBuildingMask = false;
    });
  }

  void _onLetterChanged(String value) {
    setState(() {
      _letter = value;
      _strokes.clear();
      _strokes.add([]);
      _mask = null; // force rebuild on next layout pass
      _maskSize = null;
    });
  }

  void _onCanvasTap(TapUpDetails details) {
    if (_mask == null) return; // wait for mask so taps map correctly
    setState(() {
      _strokes.last.add(details.localPosition);
    });
  }

  void _newStroke() {
    if (_strokes.last.isEmpty) return;
    setState(() {
      _strokes.add([]);
    });
  }

  void _undoLast() {
    setState(() {
      if (_strokes.last.isNotEmpty) {
        _strokes.last.removeLast();
      } else if (_strokes.length > 1) {
        _strokes.removeLast();
      }
    });
  }

  void _clearAll() {
    setState(() {
      _strokes.clear();
      _strokes.add([]);
    });
  }

  String _buildExportSnippet() {
    final mask = _mask;
    final hasPoints = _strokes.any((s) => s.isNotEmpty);
    if (mask == null || !hasPoints) return '';

    final bounds = mask.computeInkBounds();
    if (bounds == Rect.zero) return '// No ink detected for this letter.';

    final buffer = StringBuffer();
    buffer.writeln("'checkpoints': [");

    for (final stroke in _strokes) {
      if (stroke.isEmpty) continue;
      buffer.writeln('  [');
      for (final point in stroke) {
        final nx = ((point.dx - bounds.left) / bounds.width).clamp(0.0, 1.0);
        final ny = ((point.dy - bounds.top) / bounds.height).clamp(0.0, 1.0);
        buffer.writeln(
          "    {'x': ${nx.toStringAsFixed(3)}, 'y': ${ny.toStringAsFixed(3)}},",
        );
      }
      buffer.writeln('  ],');
    }

    buffer.writeln('],');
    return buffer.toString();
  }

  void _showExportDialog() {
    final snippet = _buildExportSnippet();
    if (snippet.isEmpty) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Tap some checkpoints on the letter first.'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Checkpoints for "$_letter"'),
        content: SingleChildScrollView(
          child: SelectableText(
            snippet,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: snippet));
              final messenger = ScaffoldMessenger.of(context);
              messenger.clearSnackBars();
              messenger.showSnackBar(
                const SnackBar(content: Text('Copied to clipboard')),
              );
            },
            child: const Text('Copy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasPoints = _strokes.any((s) => s.isNotEmpty);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracing Checkpoint Recorder (Debug)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.gesture),
            tooltip: 'New Stroke',
            onPressed: _strokes.last.isEmpty ? null : _newStroke,
          ),
          IconButton(
            icon: const Icon(Icons.undo),
            tooltip: 'Undo last point',
            onPressed: !hasPoints && _strokes.length == 1 ? null : _undoLast,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear all points',
            onPressed: !hasPoints ? null : _clearAll,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _letterController,
                    decoration: const InputDecoration(
                      labelText: 'Letter (Gurmukhi)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _onLetterChanged,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _translitController,
                    decoration: const InputDecoration(
                      labelText: 'Transliteration (optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Tap the letter in the order the child should trace it. '
              'Each tap adds a numbered checkpoint.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _letter.isEmpty
                  ? const Center(child: Text('Enter a letter to begin'))
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final size = constraints.biggest;
                        if (size.isFinite) {
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) => _ensureMask(size),
                          );
                        }
                        return GestureDetector(
                          onTapUp: _onCanvasTap,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CustomPaint(
                              painter: _RecorderPainter(
                                letter: _letter,
                                strokes: _strokes,
                                inkBounds: _mask?.computeInkBounds(),
                              ),
                              size: size,
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _showExportDialog,
                icon: const Icon(Icons.code),
                label: const Text('Generate checkpoint data'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecorderPainter extends CustomPainter {
  final String letter;
  final List<List<Offset>> strokes;
  final Rect? inkBounds;

  _RecorderPainter({
    required this.letter,
    required this.strokes,
    required this.inkBounds,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Guide letter.
    final textPainter = TextPainter(
      text: TextSpan(
        text: letter,
        style: TextStyle(
          fontSize: size.height * 0.7,
          color: Colors.black.withValues(alpha: 0.6),
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );

    // Debug: outline the detected tight ink bounds.
    if (inkBounds != null && inkBounds != Rect.zero) {
      final boundsPaint = Paint()
        ..color = Colors.blue.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawRect(inkBounds!, boundsPaint);
    }

    final linePaint = Paint()
      ..color = Colors.orange.withValues(alpha: 0.7)
      ..strokeWidth = 2;

    int pointCounter = 1;
    for (int s = 0; s < strokes.length; s++) {
      final points = strokes[s];
      // Connecting lines showing tap order WITHIN this stroke.
      for (int i = 0; i < points.length - 1; i++) {
        canvas.drawLine(points[i], points[i + 1], linePaint);
      }

      // Numbered checkpoint dots.
      for (int i = 0; i < points.length; i++) {
        final dotPaint = Paint()..color = Colors.orange;
        canvas.drawCircle(points[i], 14, dotPaint);

        final labelPainter = TextPainter(
          text: TextSpan(
            text: '$pointCounter',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        labelPainter.paint(
          canvas,
          points[i] - Offset(labelPainter.width / 2, labelPainter.height / 2),
        );
        pointCounter++;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RecorderPainter oldDelegate) => true;
}
