class TaskConfig {
  TaskConfig._();

  /// Delay before automatically playing a task's target sound (e.g. word or letter).
  static const autoPlayDelay = Duration(milliseconds: 800);

  /// The highest difficulty level for arcade games (0=Easy, 1=Medium, 2=Hard).
  static const maxGameDifficultyIndex = 2;
}
