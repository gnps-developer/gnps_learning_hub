import 'lesson.dart';
import 'game_config.dart';

class Journey {
  final int version;
  final List<Lesson> lessons;
  final List<GameConfig> games;

  const Journey({
    required this.version,
    required this.lessons,
    required this.games,
  });

  /// Lessons with `visible == true`, already in `order`. Use this instead
  /// of `lessons` anywhere the journey map is built, so a hidden lesson is
  /// fully invisible rather than shown greyed-out or locked.
  List<Lesson> get activeLessons => lessons.where((l) => l.visible).toList();

  factory Journey.fromJson(Map<String, dynamic> json) {
    final rawLessons = (json['lessons'] as List?) ?? [];
    final lessons =
        rawLessons
            .map((l) => Lesson.fromJson(Map<String, dynamic>.from(l as Map)))
            .toList()
          ..sort((a, b) => a.order.compareTo(b.order));

    final rawGames = (json['games'] as List?) ?? [];
    final games =
        rawGames
            .map((g) => GameConfig.fromJson(Map<String, dynamic>.from(g as Map)))
            .toList();

    return Journey(
      version: (json['version'] as num? ?? 0).toInt(),
      lessons: lessons,
      games: games,
    );
  }

  Map<String, dynamic> toJson() => {
    'version': version,
    'lessons': lessons.map((l) => l.toJson()).toList(),
    'games': games.map((g) => g.toJson()).toList(),
  };
}
