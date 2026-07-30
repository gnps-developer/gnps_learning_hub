import 'package:flutter/material.dart';

class AvatarTransform {
  final Offset offset;
  final double scale;

  const AvatarTransform({
    this.offset = Offset.zero,
    this.scale = 1.0,
  });

  factory AvatarTransform.fromJson(Map<String, dynamic> json) {
    return AvatarTransform(
      offset: Offset(
        (json['offsetX'] as num? ?? 0).toDouble(),
        (json['offsetY'] as num? ?? 0).toDouble(),
      ),
      scale: (json['scale'] as num? ?? 1.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'offsetX': offset.dx,
    'offsetY': offset.dy,
    'scale': scale,
  };
}
