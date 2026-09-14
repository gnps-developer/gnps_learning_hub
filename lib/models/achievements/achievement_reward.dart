import 'package:flutter/material.dart';
import '../../config/ui_config.dart';
import '../../config/ui_strings.dart';
import '../games/game_difficulty.dart';

/// Represents a visual reward earned by a user.
/// Sealed class allows for exhaustive matching and easy extension in the future.
sealed class AchievementReward {
  final String gameTitle;
  const AchievementReward(this.gameTitle);

  String get label;
  IconData get icon;
  Color get color;
}

/// A standard trophy (Bronze, Silver, Gold) earned in difficulty-based games.
class BubbleGameTrophy extends AchievementReward {
  final GameDifficulty difficulty;

  const BubbleGameTrophy(super.gameTitle, this.difficulty);

  @override
  String get label {
    final name = switch (difficulty) {
      GameDifficulty.easy => UIStrings.trophyBronze,
      GameDifficulty.medium => UIStrings.trophySilver,
      GameDifficulty.hard => UIStrings.trophyGold,
    };
    return UIStrings.trophyUnlocked(name);
  }

  @override
  IconData get icon => Icons.emoji_events;

  @override
  Color get color => switch (difficulty) {
    GameDifficulty.easy => AppColors.bronze,
    GameDifficulty.medium => AppColors.silver,
    GameDifficulty.hard => AppColors.gold,
  };
}

/// A master medal earned by completing a multi-level game module (e.g., Crossword).
class CrosswordMasterMedal extends AchievementReward {
  const CrosswordMasterMedal(super.gameTitle);

  @override
  String get label => UIStrings.masterEarned(UIStrings.trophyMaster);

  @override
  IconData get icon => Icons.military_tech;

  @override
  Color get color => AppColors.master;
}
