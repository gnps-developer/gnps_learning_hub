import 'package:flutter/material.dart';

enum GameDifficulty {
  easy,
  medium,
  hard;

  String get displayName {
    switch (this) {
      case GameDifficulty.easy:
        return 'Easy';
      case GameDifficulty.medium:
        return 'Medium';
      case GameDifficulty.hard:
        return 'Hard';
    }
  }

  IconData get icon {
    switch (this) {
      case GameDifficulty.easy:
        return Icons.child_care;
      case GameDifficulty.medium:
        return Icons.directions_run;
      case GameDifficulty.hard:
        return Icons.fireplace;
    }
  }
}
