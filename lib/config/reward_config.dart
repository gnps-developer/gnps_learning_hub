import 'package:flutter/material.dart';

/// Single source of truth for the app's reward currency (currently stars).
/// CurrentLessonBanner's points chip and the reward burst animation both
/// read icon/color from here instead of hardcoding it — so switching to
/// gems (or anything else) later is a three-line edit here, not a hunt
/// through every widget that displays points.
class RewardConfig {
  static const IconData icon = Icons.diamond_rounded;
  static const Color color = Color(0xFF4FC3F7);
  static const String labelSingular = 'gem';
  static const String labelPlural = 'gems';
}
