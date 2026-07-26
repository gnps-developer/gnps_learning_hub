import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/task.dart';
import '../../providers/audio_providers.dart';
import '../../config/task_config.dart';
import '../common/task_speaker_button.dart';
import '../common/task_done_button.dart';
import '../common/task_clear_button.dart';
import '../common/task_header.dart';

/// Lets the child trace a letter over a guide.
///
/// NOTE: this used to be deliberately non-validating (muscle-memory practice
/// only, always advances on "Done" — see prior product spec). Per updated
/// requirements this now *does* fail the attempt: strokes drawn too far off
/// the letter's shape are rejected in real time, and "Done" only unlocks
/// once enough of the letter has actually been traced.
///
/// Optionally supports checkpoints: normalized (0.0-1.0) waypoints along the
/// letter, supplied via task.content['checkpoints'] as a List of
/// {'x': double, 'y': double} maps, ordered in the direction the letter
/// should be traced. Coordinates are normalized relative to the letter's
/// tight ink bounding box (derived from the alpha mask, not font layout
/// metrics), so they land on the actual visible glyph regardless of font
/// padding — see lib/utils/letter_ink_mask.dart / the checkpoint recorder
/// tool in lib/tools/ for how these are captured.
///
/// Checkpoints must be reached IN ORDER (enforces stroke direction, not just
/// "somewhere near a checkpoint"), are rendered as small open arrows
/// (pointing toward the next checkpoint in the sequence) rather than plain
/// dots, and all of them must be reached before "Done" unlocks (in addition
/// to the ink-coverage requirement). The very first checkpoint is shown
/// highlighted in green, pulsing more strongly than a regular "next" arrow,
/// and with a soft pulsing halo behind it — a distinct "start here" cue,
/// separate from the plain orange pulse used for later required
/// checkpoints. A pulsing hint line also connects the last-reached
/// checkpoint to the next required one.
///
/// The traced stroke itself renders thin while tracing is in progress, and
/// only thickens once the attempt is fully complete (coverage + all
/// checkpoints reached) — a visual reward rather than a static line width.
///
/// Whenever a checkpoint is reached, the drawn stroke since the previous
/// checkpoint is auto-corrected to a straight line between the two
/// checkpoints — so the child's wobbly path visually snaps onto the ideal
/// trace rather than showing their raw hand-drawn line. This is display
/// correction only; it doesn't affect coverage/validation, which is based
/// on the actual points the child drew as they drew them.
///
/// Letters without checkpoint data skip all checkpoint-related behavior.
class TraceTaskWidget extends ConsumerStatefulWidget {
  final Task task;
  final VoidCallback onComplete;
  final VoidCallback? onIncorrect;

  const TraceTaskWidget({
    super.key,
    required this.task,
    required this.onComplete,
    this.onIncorrect,
  });

  @override
  ConsumerState<TraceTaskWidget> createState() => _TraceTaskWidgetState();
}

/// A single snap-point along the letter. Mutable `reached` flag so we can
/// update it in place as the child's stroke passes near it. Checkpoints are
/// reached strictly in list order — see _tryReachCheckpoint.
///
/// [direction] (radians) points toward the next checkpoint in the sequence,
/// so it can be rendered as a small arrow rather than a plain dot. The last
/// checkpoint has no "next" to point at, so it keeps the heading it arrived
/// on; a lone checkpoint (no others) has no meaningful direction and is 0.
class _Checkpoint {
  final Offset position; // resolved to widget-local pixel coords
  final double direction;
  final int strokeIndex;
  final bool isLastInStroke;
  bool reached = false;

  _Checkpoint({
    required this.position,
    required this.direction,
    required this.strokeIndex,
    required this.isLastInStroke,
  });
}

class _TraceTaskWidgetState extends ConsumerState<TraceTaskWidget>
    with TickerProviderStateMixin {
  // --- Tunable "feel" constants ---
  // Keep these roughly in step with each other: if you fatten the visual
  // stroke a lot, nudge tolerance/hit-radius up too, or the rendered stroke
  // can visually look like it's covering ink that validation is rejecting.
  static const double _onTrackTolerance =
      16; // px a stroke point may sit off the letter's ink and still count
  static const double _coverageSampleStep =
      6; // grid spacing when scanning the letter for ink pixels
  static const double _coverageHitRadius =
      12; // how close a stroke point must get to "cover" a sample
  static const double _requiredCoverage =
      0.55; // fraction of the letter that must be traced to pass
  static const int _alphaThreshold = 40; // min alpha to count a pixel as "ink"
  static const double _strokeWidthTracing =
      4; // thin rendered stroke while still tracing
  static const double _strokeWidthComplete =
      14; // thick rendered stroke once fully traced
  static const double _checkpointSnapRadius =
      22; // px within which a drawn point snaps onto a checkpoint
  static const double _checkpointArrowSize =
      9; // shaft+head length of a rendered checkpoint arrow

  final List<Offset> _points = [];

  // Index into _points marking the start of the segment since the last
  // checkpoint was reached. When the next checkpoint is reached, everything
  // from this index onward gets replaced with a straight line between the
  // two checkpoints — see _straightenSinceCheckpoint.
  int _correctionStartIndex = 0;

  Size? _maskSize;
  String? _maskLetter;
  ByteData? _letterMask;
  List<Offset> _inkSamples = [];
  final Set<int> _coveredSampleIndices = {};
  List<_Checkpoint> _checkpoints = [];

  bool _failed = false;
  bool _isBuildingMask = false;

  // Tracks the last size we scheduled a mask build for, so LayoutBuilder's
  // per-build callback doesn't re-enter _ensureMask on every setState
  // (e.g. every pan-update point) — only when the layout size actually changes.
  Size? _lastScheduledSize;

  // If a new size/letter arrives while a mask build is already in flight, we
  // stash it here rather than dropping it — otherwise the in-flight build's
  // result (for a now-stale size) would silently "win" and never get
  // superseded, since LayoutBuilder won't re-schedule a size it already saw.
  Size? _queuedSize;
  String? _queuedLetter;

  late final AnimationController _shakeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  // Drives the pulsing direction-hint arrow / "start here" indicator.
  late final AnimationController _hintPulseController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  double get _coverageRatio => _inkSamples.isEmpty
      ? 0
      : _coveredSampleIndices.length / _inkSamples.length;

  bool get _allCheckpointsReached =>
      _checkpoints.isEmpty || _checkpoints.every((c) => c.reached);

  bool get _canComplete =>
      !_failed && _coverageRatio >= _requiredCoverage && _allCheckpointsReached;

  /// Index of the next checkpoint the child must reach, in order.
  /// -1 if there are no checkpoints, or all have been reached.
  int get _nextCheckpointIndex {
    if (_checkpoints.isEmpty) return -1;
    final index = _checkpoints.indexWhere((c) => !c.reached);
    return index; // -1 if all reached (List.indexWhere's own not-found value)
  }

  @override
  void initState() {
    super.initState();
    // Auto-play the letter sound after a short delay
    final letter = widget.task.content['letter'] as String;
    Future.delayed(TaskConfig.autoPlayDelay, () {
      if (mounted) {
        ref.read(audioServiceProvider).speak(letter);
      }
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _hintPulseController.dispose();
    super.dispose();
  }

  /// Scans the rendered alpha mask for the tight bounding box of actual ink
  /// pixels (alpha > threshold). This is deliberately NOT the same as the
  /// TextPainter's layout size — font metrics (ascent/descent/line-height)
  /// typically pad the layout box well beyond the visible glyph, especially
  /// for Gurmukhi script. Checkpoints need to be normalized against the real
  /// ink extent or they land in that padding, outside the visible letter.
  Rect _computeInkBounds(ByteData data, int width, int height) {
    int minX = width, maxX = 0, minY = height, maxY = 0;
    bool found = false;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        if (_alphaAt(data, width, height, x.toDouble(), y.toDouble()) >
            _alphaThreshold) {
          found = true;
          if (x < minX) minX = x;
          if (x > maxX) maxX = x;
          if (y < minY) minY = y;
          if (y > maxY) maxY = y;
        }
      }
    }

    if (!found) return Rect.zero;
    return Rect.fromLTRB(
      minX.toDouble(),
      minY.toDouble(),
      maxX.toDouble(),
      maxY.toDouble(),
    );
  }

  /// Reads task.content['checkpoints'] (normalized 0.0-1.0 x/y maps,
  /// relative to the letter's tight ink bounding box, in trace order),
  /// resolves them to widget-local pixel coordinates using [inkBounds], and
  /// derives each checkpoint's arrow direction from its position relative to
  /// the next checkpoint in the sequence (the last checkpoint keeps the
  /// heading it arrived on). Returns an empty list if no checkpoint data is
  /// present, so letters without it are unaffected.
  List<_Checkpoint> _buildCheckpoints(Rect inkBounds) {
    final raw = widget.task.content['checkpoints'] as List<dynamic>?;
    if (raw == null || raw.isEmpty) return [];
    if (inkBounds == Rect.zero) return [];

    final List<_Checkpoint> checkpoints = [];

    // Check if the data is in the new nested format: List<List<Map>>
    final isNested = raw.first is List;

    if (isNested) {
      for (int s = 0; s < raw.length; s++) {
        final strokePoints = raw[s] as List<dynamic>;
        final List<Offset> positions = [];

        for (final entry in strokePoints) {
          final map = entry as Map<String, dynamic>;
          final nx = (map['x'] as num).toDouble();
          final ny = (map['y'] as num).toDouble();
          positions.add(
            Offset(
              inkBounds.left + nx * inkBounds.width,
              inkBounds.top + ny * inkBounds.height,
            ),
          );
        }

        for (int i = 0; i < positions.length; i++) {
          Offset delta;
          if (i < positions.length - 1) {
            delta = positions[i + 1] - positions[i];
          } else if (i > 0) {
            delta = positions[i] - positions[i - 1];
          } else {
            delta = Offset.zero;
          }
          final direction = delta.distance > 0 ? math.atan2(delta.dy, delta.dx) : 0.0;
          
          checkpoints.add(_Checkpoint(
            position: positions[i],
            direction: direction,
            strokeIndex: s,
            isLastInStroke: i == positions.length - 1,
          ));
        }
      }
    } else {
      // Legacy flat list format: List<Map>
      final List<Offset> positions = raw.map((entry) {
        final map = entry as Map<String, dynamic>;
        final nx = (map['x'] as num).toDouble();
        final ny = (map['y'] as num).toDouble();
        return Offset(
          inkBounds.left + nx * inkBounds.width,
          inkBounds.top + ny * inkBounds.height,
        );
      }).toList();

      for (int i = 0; i < positions.length; i++) {
        Offset delta;
        if (i < positions.length - 1) {
          delta = positions[i + 1] - positions[i];
        } else if (i > 0) {
          delta = positions[i] - positions[i - 1];
        } else {
          delta = Offset.zero;
        }
        final direction = delta.distance > 0 ? math.atan2(delta.dy, delta.dx) : 0.0;

        checkpoints.add(_Checkpoint(
          position: positions[i],
          direction: direction,
          strokeIndex: 0,
          isLastInStroke: i == positions.length - 1,
        ));
      }
    }

    return checkpoints;
  }

  Future<void> _ensureMask(Size size, String letter) async {
    if (_isBuildingMask) {
      // Don't drop this request — a build is already running for a
      // possibly-stale size/letter. Remember the latest one and process it
      // as soon as the in-flight build finishes.
      _queuedSize = size;
      _queuedLetter = letter;
      return;
    }
    if (_maskSize == size && _maskLetter == letter && _letterMask != null) {
      return;
    }
    _isBuildingMask = true;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, size.width, size.height),
    );
    final textPainter = TextPainter(
      text: TextSpan(
        text: letter,
        style: TextStyle(
          fontSize: size.height * 0.7,
          color: Colors.black,
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

    final picture = recorder.endRecording();
    final width = size.width.round().clamp(1, 4000);
    final height = size.height.round().clamp(1, 4000);
    final image = await picture.toImage(width, height);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    image.dispose();

    if (!mounted || byteData == null) {
      _isBuildingMask = false;
      await _processQueuedMaskRequest();
      return;
    }

    final samples = <Offset>[];
    for (double y = 0; y < height; y += _coverageSampleStep) {
      for (double x = 0; x < width; x += _coverageSampleStep) {
        if (_alphaAt(byteData, width, height, x, y) > _alphaThreshold) {
          samples.add(Offset(x, y));
        }
      }
    }

    final inkBounds = _computeInkBounds(byteData, width, height);

    setState(() {
      _maskSize = size;
      _maskLetter = letter;
      _letterMask = byteData;
      _inkSamples = samples;
      _coveredSampleIndices.clear();
      _checkpoints = _buildCheckpoints(inkBounds);
      _isBuildingMask = false;
    });

    await _processQueuedMaskRequest();
  }

  /// If a size/letter arrived while we were mid-build, run the mask build
  /// again for the latest one now that we're free. This is what prevents
  /// the mask (and checkpoints derived from it) from getting stuck on a
  /// stale size if a resize happens mid-build.
  Future<void> _processQueuedMaskRequest() async {
    if (_queuedSize == null || _queuedLetter == null) return;
    final size = _queuedSize!;
    final letter = _queuedLetter!;
    _queuedSize = null;
    _queuedLetter = null;
    await _ensureMask(size, letter);
  }

  int _alphaAt(ByteData data, int width, int height, double x, double y) {
    final ix = x.round().clamp(0, width - 1);
    final iy = y.round().clamp(0, height - 1);
    final index = (iy * width + ix) * 4;
    if (index + 3 >= data.lengthInBytes) return 0;
    return data.getUint8(index + 3); // alpha channel
  }

  /// Whether [point] sits on (or within tolerance of) the letter's ink.
  /// Checks a small ring around the point rather than just the exact pixel,
  /// so strokes near a thick edge of the letter aren't unfairly rejected.
  bool _isOnLetter(Offset point) {
    final mask = _letterMask;
    final size = _maskSize;
    if (mask == null || size == null) {
      return true; // mask not ready yet — don't block the user
    }
    final width = size.width.round();
    final height = size.height.round();

    if (_alphaAt(mask, width, height, point.dx, point.dy) > _alphaThreshold) {
      return true;
    }

    const ringSteps = 8;
    for (int i = 0; i < ringSteps; i++) {
      final angle = (i / ringSteps) * 2 * math.pi;
      final dx = point.dx + _onTrackTolerance * math.cos(angle);
      final dy = point.dy + _onTrackTolerance * math.sin(angle);
      if (_alphaAt(mask, width, height, dx, dy) > _alphaThreshold) return true;
    }
    return false;
  }

  void _updateCoverage(Offset point) {
    final hitRadiusSq = _coverageHitRadius * _coverageHitRadius;
    for (int i = 0; i < _inkSamples.length; i++) {
      if (_coveredSampleIndices.contains(i)) continue;
      final sample = _inkSamples[i];
      final dx = sample.dx - point.dx;
      final dy = sample.dy - point.dy;
      if (dx * dx + dy * dy <= hitRadiusSq) {
        _coveredSampleIndices.add(i);
      }
    }
  }

  /// If [point] lands within snap radius of the NEXT required checkpoint
  /// (strictly in order — earlier unreached checkpoints are not skippable
  /// and later ones aren't eligible yet), marks it reached and returns its
  /// index. Otherwise returns null.
  ///
  /// This is what actually enforces tracing direction: a child can't
  /// "complete" checkpoint 3 by swiping near it before reaching 1 and 2.
  /// Callers should only invoke this for points already confirmed on-letter
  /// — see _onPanUpdate — so an off-letter stroke can't advance a checkpoint.
  int? _tryReachCheckpoint(Offset point) {
    final nextIndex = _nextCheckpointIndex;
    if (nextIndex == -1) return null; // no checkpoints, or all reached

    final next = _checkpoints[nextIndex];
    if ((next.position - point).distance <= _checkpointSnapRadius) {
      next.reached = true;
      return nextIndex;
    }
    return null;
  }

  /// Replaces the drawn stroke since the previous checkpoint with a
  /// straight line from that checkpoint's position to [reachedIndex]'s
  /// position. If [reachedIndex] is the start of a NEW stroke, we do NOT
  /// bridge the gap to the previous stroke's end.
  void _straightenSinceCheckpoint(int reachedIndex) {
    if (reachedIndex <= 0) {
      _correctionStartIndex = _points.length;
      return;
    }

    final current = _checkpoints[reachedIndex];
    final prev = _checkpoints[reachedIndex - 1];

    // If we just jumped across a pen-lift boundary, don't bridge them.
    if (current.strokeIndex != prev.strokeIndex) {
      _correctionStartIndex = _points.length;
      return;
    }

    final anchor = prev.position;
    final target = current.position;
    final start = _correctionStartIndex.clamp(0, _points.length);
    _points
      ..removeRange(start, _points.length)
      ..addAll([anchor, target]);
    _correctionStartIndex = _points.length;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_failed) {
      return; // ignore further input until the child clears and retries
    }
    final rawPoint = details.localPosition;
    final onLetter = _isOnLetter(rawPoint);

    setState(() {
      if (!onLetter) {
        _points.add(rawPoint);
        _failed = true;
        _shakeController.forward(from: 0.0);
        widget.onIncorrect?.call();
        return;
      }

      final reachedIndex = _tryReachCheckpoint(rawPoint);
      if (reachedIndex != null) {
        final checkpointPosition = _checkpoints[reachedIndex].position;
        _points.add(checkpointPosition);
        _updateCoverage(checkpointPosition);
        _straightenSinceCheckpoint(reachedIndex);
      } else {
        _points.add(rawPoint);
        _updateCoverage(rawPoint);
      }
    });
  }

  void _clear() {
    setState(() {
      _points.clear();
      _failed = false;
      _coveredSampleIndices.clear();
      _correctionStartIndex = 0;
      for (final checkpoint in _checkpoints) {
        checkpoint.reached = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final letter = widget.task.content['letter'] as String;
    final transliteration =
        widget.task.content['transliteration'] as String? ?? '';

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const TaskHeader(title: 'Trace the letter'),
          const SizedBox(height: 8),
          Column(
            children: [
              TaskSpeakerButton(textToSpeak: letter),
              const SizedBox(height: 8),
              Text(
                transliteration,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.biggest;
                if (size.isFinite && size != _lastScheduledSize) {
                  _lastScheduledSize = size;
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _ensureMask(size, letter),
                  );
                }
                return GestureDetector(
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: (_) => setState(() => _points.add(Offset.infinite)),
                  // pen lift marker
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      _shakeController,
                      _hintPulseController,
                    ]),
                    builder: (context, child) {
                      final sineValue = math.sin(
                        _shakeController.value * 4 * math.pi,
                      );
                      return Transform.translate(
                        offset: Offset(sineValue * 8, 0),
                        child: child,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _failed ? Colors.red : Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CustomPaint(
                        painter: _TracePainter(
                          letter: letter,
                          points: _points,
                          failed: _failed,
                          strokeWidth: _canComplete
                              ? _strokeWidthComplete
                              : _strokeWidthTracing,
                          checkpoints: _checkpoints,
                          checkpointArrowSize: _checkpointArrowSize,
                          nextCheckpointIndex: _nextCheckpointIndex,
                          hintPulse: _hintPulseController.value,
                        ),
                        size: size,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _failed
                ? 'Off the letter — tap Clear and try again'
                : _canComplete
                ? 'Nicely traced! Tap Done.'
                : 'Keep tracing the whole letter (${(_coverageRatio * 100).round()}%)',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: _failed
                  ? Colors.red
                  : _canComplete
                  ? Colors.green.shade700
                  : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              TaskClearButton(onPressed: _clear),
              const Spacer(),
              TaskDoneButton(
                onPressed: _canComplete ? widget.onComplete : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TracePainter extends CustomPainter {
  final String letter;
  final List<Offset> points;
  final bool failed;
  final double strokeWidth;
  final List<_Checkpoint> checkpoints;
  final double checkpointArrowSize;
  final int nextCheckpointIndex; // -1 = none pending (no checkpoints, or done)
  final double hintPulse; // 0.0-1.0, drives the pulsing hint animation

  _TracePainter({
    required this.letter,
    required this.points,
    required this.failed,
    required this.strokeWidth,
    required this.checkpoints,
    required this.checkpointArrowSize,
    required this.nextCheckpointIndex,
    required this.hintPulse,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Faint guide letter in the background.
    final textPainter = TextPainter(
      text: TextSpan(
        text: letter,
        style: TextStyle(
          fontSize: size.height * 0.7,
          color: Colors.grey.withValues(alpha: 0.25),
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

    // Checkpoint arrows, each pointing toward the next checkpoint in the
    // sequence:
    //  - Reached: solid green.
    //  - The very first checkpoint, before it's reached: green, pulsing
    //    more strongly than a regular "next" arrow, with a soft pulsing
    //    halo drawn behind it — a distinct "start here" cue, separate from
    //    the plain orange pulse used further along the sequence.
    //  - Any other next-required checkpoint: pulsing orange.
    //  - Anything further down the line (not yet eligible): gray, so the
    //    full path is visible without competing for attention with the
    //    current target.
    for (int i = 0; i < checkpoints.length; i++) {
      final checkpoint = checkpoints[i];
      final isNext = i == nextCheckpointIndex;
      final isFirstInStroke = i == 0 || checkpoints[i - 1].isLastInStroke;

      Color color;
      double scale;

      if (checkpoint.reached) {
        color = Colors.green;
        scale = 1.0;
      } else if (isFirstInStroke && isNext) {
        color = Colors.green;
        scale = 1.0 + hintPulse * 0.5; // bigger pulse than a regular "next"
        _drawStartHalo(canvas, checkpoint.position, hintPulse);
      } else if (isNext) {
        color = Colors.orange;
        scale = 1.0 + hintPulse * 0.3;
      } else {
        color = Colors.grey.shade400;
        scale = 1.0;
      }

      _drawCheckpointArrow(canvas, checkpoint, color: color, scale: scale);
    }

    // Direction hint: a pulsing line from the last-reached checkpoint to
    // the next required one, but ONLY if they belong to the same stroke.
    if (nextCheckpointIndex > 0 && nextCheckpointIndex < checkpoints.length) {
      final prev = checkpoints[nextCheckpointIndex - 1];
      final current = checkpoints[nextCheckpointIndex];

      if (prev.strokeIndex == current.strokeIndex) {
        _drawDirectionHintLine(canvas, prev.position, current.position, hintPulse);
      }
    }

    // User's traced strokes — red once the attempt has failed, thin while
    // still in progress, and thick once the full attempt is complete (see
    // strokeWidth passed in from state: _strokeWidthTracing vs
    // _strokeWidthComplete). Segments already passed through a reached
    // checkpoint have been straightened onto the ideal line by the state
    // class before we ever see them here — see _straightenSinceCheckpoint.
    // Drawn as a smoothed path (quadratic Bezier through midpoints) rather
    // than straight segments between raw points, so jittery finger input
    // renders as a clean curve.
    final strokePaint = Paint()
      ..color = failed ? Colors.red : Colors.blue
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // Split into segments at Offset.infinite (pen-lift) markers, then draw
    // each segment as one smoothed path.
    List<Offset> segment = [];
    void flushSegment() {
      if (segment.length >= 2) {
        canvas.drawPath(_smoothedPath(segment), strokePaint);
      } else if (segment.length == 1) {
        // A single tap/dot — draw a small dot so it's still visible.
        strokePaint.style = PaintingStyle.fill;
        canvas.drawCircle(segment.first, strokeWidth / 2, strokePaint);
        strokePaint.style = PaintingStyle.stroke;
      }
      segment = [];
    }

    for (final point in points) {
      if (point == Offset.infinite) {
        flushSegment();
      } else {
        segment.add(point);
      }
    }
    flushSegment();
  }

  /// Soft pulsing ring drawn behind the starting checkpoint, so it reads as
  /// a distinct "begin here" cue rather than just another next-target arrow.
  void _drawStartHalo(Canvas canvas, Offset center, double pulse) {
    final radius = checkpointArrowSize * (1.4 + pulse * 0.6);
    final paint = Paint()
      ..color = Colors.green.withValues(alpha: 0.18 + pulse * 0.12)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, paint);
  }

  /// Draws a small open arrow ("->" style — a shaft with an open V head, no
  /// closed back edge) at [checkpoint]'s position, rotated to its stored
  /// direction. [scale] lets "next required" checkpoints pulse slightly
  /// larger without changing shape.
  void _drawCheckpointArrow(
    Canvas canvas,
    _Checkpoint checkpoint, {
    required Color color,
    required double scale,
  }) {
    final length = checkpointArrowSize * scale;
    final center = checkpoint.position;
    final unit = Offset(
      math.cos(checkpoint.direction),
      math.sin(checkpoint.direction),
    );
    final normal = Offset(-unit.dy, unit.dx);

    final tail = center - unit * length * 0.5;
    final tip = center + unit * length * 0.5;
    final headLength = length * 0.5;
    final headBackLeft = tip - unit * headLength + normal * headLength * 0.6;
    final headBackRight = tip - unit * headLength - normal * headLength * 0.6;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(tail, tip, paint);
    canvas.drawLine(tip, headBackLeft, paint);
    canvas.drawLine(tip, headBackRight, paint);
  }

  /// Draws a pulsing line from [from] to [to], shortened at both ends so it
  /// doesn't overlap the checkpoint arrows it connects. [pulse] (0.0-1.0)
  /// drives a gentle opacity breathe so the hint reads as "alive" without
  /// being distracting.
  void _drawDirectionHintLine(
    Canvas canvas,
    Offset from,
    Offset to,
    double pulse,
  ) {
    final direction = to - from;
    final distance = direction.distance;
    if (distance < 1) return; // coincident points — nothing to draw

    final unit = direction / distance;
    const startInset = 16.0; // clear of the "from" checkpoint arrow
    const endInset = 18.0; // clear of the "to" checkpoint arrow
    if (distance <= startInset + endInset) {
      return; // checkpoints too close together to draw a meaningful line
    }

    final lineStart = from + unit * startInset;
    final lineEnd = to - unit * endInset;

    final opacity = 0.45 + (pulse * 0.4); // breathes between ~0.45 and ~0.85
    final linePaint = Paint()
      ..color = Colors.orange.withValues(alpha: opacity)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(lineStart, lineEnd, linePaint);
  }

  /// Builds a smooth path through [pts] using quadratic Bezier curves
  /// between successive midpoints — the classic "smooth freehand stroke"
  /// technique. Each curve's control point is the actual data point, and
  /// its endpoint is the midpoint to the next data point, which avoids the
  /// sharp direction changes you get from straight drawLine segments.
  Path _smoothedPath(List<Offset> pts) {
    final path = Path()..moveTo(pts[0].dx, pts[0].dy);

    for (int i = 1; i < pts.length - 1; i++) {
      final current = pts[i];
      final next = pts[i + 1];
      final midpoint = Offset(
        (current.dx + next.dx) / 2,
        (current.dy + next.dy) / 2,
      );
      path.quadraticBezierTo(current.dx, current.dy, midpoint.dx, midpoint.dy);
    }

    // Final segment: curve into the last real point.
    path.lineTo(pts.last.dx, pts.last.dy);
    return path;
  }

  @override
  bool shouldRepaint(covariant _TracePainter oldDelegate) => true;
}
