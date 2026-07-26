import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Shared helper for rendering a letter glyph to an offscreen alpha mask and
/// computing derived data from it (ink coverage samples, tight bounding box).
///
/// Used by both TraceTaskWidget (stroke validation) and the debug
/// CheckpointRecorderScreen, so recorded checkpoints are guaranteed to line
/// up with what the trace widget computes at runtime — both consume the
/// exact same rendering/bounds logic instead of two copies that can drift.
class LetterInkMask {
  final Size size;
  final String letter;
  final ByteData data;
  final int width;
  final int height;

  LetterInkMask._({
    required this.size,
    required this.letter,
    required this.data,
    required this.width,
    required this.height,
  });

  static const int alphaThreshold = 40;

  static Future<LetterInkMask?> build(Size size, String letter) async {
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
    if (byteData == null) return null;

    return LetterInkMask._(
      size: size,
      letter: letter,
      data: byteData,
      width: width,
      height: height,
    );
  }

  int alphaAt(double x, double y) {
    final ix = x.round().clamp(0, width - 1);
    final iy = y.round().clamp(0, height - 1);
    final index = (iy * width + ix) * 4;
    if (index + 3 >= data.lengthInBytes) return 0;
    return data.getUint8(index + 3); // alpha channel
  }

  bool isInk(double x, double y) => alphaAt(x, y) > alphaThreshold;

  /// Tight bounding box of actual ink pixels (alpha > threshold). This is
  /// deliberately NOT the font's layout box — font metrics (ascent/descent)
  /// typically pad the layout box beyond the visible glyph, especially for
  /// Gurmukhi script. Checkpoints must be normalized against this, not the
  /// raw canvas or TextPainter.size, or they land outside the visible ink.
  Rect computeInkBounds() {
    int minX = width, maxX = 0, minY = height, maxY = 0;
    bool found = false;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        if (isInk(x.toDouble(), y.toDouble())) {
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
}
