class UIStrings {
  UIStrings._();

  // Common Actions
  static const backToJourney = 'Back to Journey';
  static const continueLabel = 'Continue';
  static const startLabel = 'START';
  static const continueCapsLabel = 'CONTINUE';
  static const cancel = 'Cancel';
  static const confirm = 'Confirm';
  static const discard = 'Discard';
  static const ok = 'OK';
  static const close = 'Close';
  static const copy = 'Copy';

  // Common Labels
  static const taskLabel = 'Task';
  static const ofLabel = 'of';
  static const scoreLabel = 'Score';
  static const bestLabel = 'Best';
  static const loading = 'Loading...';

  // Support
  static const supportEmail = 'support@gnps.nsw.edu.au';
  static const contactSupport = 'Contact Support';

  // Profile
  static const profileTitle = 'Profile';
  static const addNameHint = 'Add your name';
  static const yourNameLabel = 'Your name';
  // Streak
  static const streakTitle = 'Streak';
  static String streakDays(int n) => '$n day${n == 1 ? '' : 's'}';
  static String lessonsCompleted(int n) => 'Lessons completed: $n';
  static String greeting(String? name) =>
      'Hi${name != null && name.isNotEmpty ? ', $name' : ' there'}! 👋';

  // Achievements
  static const achievementsTitle = 'Achievements';
  static const trophyBronze = 'Bronze';
  static const trophySilver = 'Silver';
  static const trophyGold = 'Gold';
  static const gameHighScores = 'Game High Scores';
  static String trophyUnlocked(String tier) => '$tier Trophy Unlocked!';
  static String forGame(String title) => 'for $title';
  static String bestAttempt(int score) => 'Best: $score ⭐';
  static const noTrophiesMessage =
      'No games unlocked yet! Finish your first few lessons on the map to see your achievements here.';

  // Settings
  static const settingsTitle = 'Settings';
  static const soundLabel = 'Sound';
  static const hapticsLabel = 'Haptic feedback';
  static const themeColorLabel = 'Theme color';
  static const aboutLabel = 'About';
  static const appVersionLabel = 'App version';
  static const contentVersionLabel = 'Lesson content version';
  static const totalLessonsLabel = 'Total lessons';
  static const totalTasksLabel = 'Total interactive tasks';
  static const totalGamesLabel = 'Total games';
  static const artworkAttributionsLabel = 'Artwork Attributions';
  static const accountManagementLabel = 'Account management';
  static const factoryResetLabel = 'Factory Reset';
  static const debugToolsLabel = 'Debug Tools';
  static const markAllCompleteLabel = 'Mark All Lessons Complete';
  static const contentDebugLabel = 'Content Progress Debug';
  static const tracingRecorderLabel = 'Tracing Checkpoint Recorder';
  static const testCelebrationLabel = 'Test Achievement Celebration';
  static const disableDevModeLabel = 'Disable Developer Mode';

  // Dialogs & Snackbars
  static const factoryResetTitle = 'Factory Reset?';
  static const factoryResetWarning =
      "This clears all points, streaks, and lesson progress, and reloads lesson content fresh. This can't be undone.";
  static const resetEverything = 'Reset Everything';
  static const discardChangesTitle = 'Discard changes?';
  static const discardChangesContent = "You haven't saved your new look yet.";
  static const keepEditing = 'Keep editing';
  static const noHeartsTitle = 'No Hearts! ❤️';
  static const noHeartsContent =
      'You need at least one heart to play this game. Visit the shop to get more!';
  static const goToShop = 'Go to Shop';
  static const unlockDevModeTitle = 'Unlock Developer Mode';
  static const enterSecretCode = 'Enter secret code';
  static const unlock = 'Unlock';
  static const devModeUnlocked = 'Developer mode unlocked!';
  static const incorrectCode = 'Incorrect code.';
  static const copiedToClipboard = 'Copied to clipboard';
  static String devModeSteps(int n) =>
      'You are $n step${n == 1 ? '' : 's'} away from developer mode.';

  // Games
  static const selectDifficulty = 'Select difficulty:';
  static const listenToLetter = 'Listen to the letter:';
  static const listenToWord = 'Listen to the word:';
  static const victoryTitle = 'VICTORY!';
  static const gameOverTitle = 'GAME OVER';
  static String finalScore(int n) => 'Final Score: $n';
}
