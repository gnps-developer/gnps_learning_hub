import 'package:flutter/material.dart';

class GameConfig {
  final String id;
  final String title;
  final String unlockAfterLessonId;
  final String type; // e.g., 'bubble_pop'
  final Map<String, dynamic> content;
  final double? mapXOffset; // Horizontal offset from the anchor lesson
  final double? mapYOffset; // Vertical offset from the anchor lesson
  final IconData? icon;
  final Color? iconColor;

  const GameConfig({
    required this.id,
    required this.title,
    required this.unlockAfterLessonId,
    required this.type,
    this.content = const {},
    this.mapXOffset,
    this.mapYOffset,
    this.icon,
    this.iconColor,
  });

  factory GameConfig.fromJson(Map<String, dynamic> json) {
    return GameConfig(
      id: json['id'] as String,
      title: json['title'] as String,
      unlockAfterLessonId: json['unlockAfterLessonId'] as String,
      type: json['type'] as String,
      content: Map<String, dynamic>.from(json['content'] as Map? ?? {}),
      mapXOffset: (json['mapXOffset'] as num?)?.toDouble(),
      mapYOffset: (json['mapYOffset'] as num?)?.toDouble(),
      icon: json['icon'] is String
          ? _iconMapping[json['icon'] as String]
          : json['icon'] as IconData?,
      iconColor: json['iconColor'] is int
          ? Color(json['iconColor'] as int)
          : json['iconColor'] as Color?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'unlockAfterLessonId': unlockAfterLessonId,
    'type': type,
    'content': content,
    'mapXOffset': mapXOffset,
    'mapYOffset': mapYOffset,
    'icon': _reverseIconMapping[icon],
    'iconColor': iconColor?.toARGB32(),
  };

  /// Mapping of string keys to IconData constants to allow for icon
  /// tree-shaking while still supporting serialization.
  static const Map<String, IconData> _iconMapping = {
    'videogame_asset': Icons.videogame_asset,
    'menu_book': Icons.menu_book,
  };

  static final Map<IconData?, String?> _reverseIconMapping =
      _iconMapping.map((key, value) => MapEntry(value, key));
}
