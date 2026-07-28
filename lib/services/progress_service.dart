import 'package:gnps_learning_hub/models/shop/default_item_ids.dart';
import 'package:gnps_learning_hub/models/journey.dart';
import 'package:gnps_learning_hub/models/progress.dart';
import 'package:gnps_learning_hub/models/games/game_difficulty.dart';
import 'package:gnps_learning_hub/models/shop/shop_item.dart';
import 'package:gnps_learning_hub/repositories/progress_repository.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

enum PurchaseResult { success, insufficientGems, alreadyOwned }

class ProgressService {
  final ProgressRepository _repository;

  ProgressService(this._repository);

  /// Call once on app launch: bumps the streak if the user is active on
  /// a new calendar day, or resets it to 0 if a day was missed entirely.
  Future<LocalProgress> registerAppOpen(LocalProgress progress) async {
    final updated = progress.clone();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (updated.lastActiveDate == null) {
      updated.currentStreak = 1;
    } else {
      final last = updated.lastActiveDate!;
      final lastDay = DateTime(last.year, last.month, last.day);
      final dayDiff = today.difference(lastDay).inDays;

      if (dayDiff == 0) {
        // Same day, no change.
      } else if (dayDiff == 1) {
        updated.currentStreak += 1;
      } else {
        // Multi-day gap. Check for Streak Freezes.
        final missedDays = dayDiff - 1;
        final availableFreezes = itemQuantity(updated, DefaultItemIds.streakFreeze);

        if (availableFreezes >= missedDays) {
          // Consume freezes to cover the gap
          updated.ownedItemQuantities[DefaultItemIds.streakFreeze] = availableFreezes - missedDays;
          
          // Record frozen dates for visualization
          for (int i = 1; i <= missedDays; i++) {
            final frozenDate = last.add(Duration(days: i));
            final dateStr = "${frozenDate.year}-${frozenDate.month.toString().padLeft(2, '0')}-${frozenDate.day.toString().padLeft(2, '0')}";
            updated.frozenDates.add(dateStr);
          }
          
          // Streak continues: previous streak + missed days (frozen) + 1 (today)
          updated.currentStreak += missedDays + 1;
        } else {
          updated.currentStreak = 1; // Not enough freezes, reset.
        }
      }
    }

    updated.lastActiveDate = today;
    await _repository.save(updated);
    return updated;
  }

  /// Ensures the first lesson is unlocked.
  Future<LocalProgress> ensureFirstLessonUnlocked(
    LocalProgress progress,
    Journey journey,
  ) async {
    final activeLessons = journey.activeLessons;
    if (activeLessons.isEmpty) return progress;

    final firstLessonId = activeLessons.first.id;
    if (progress.unlockedLessonIds.contains(firstLessonId)) return progress;

    final updated = progress.clone();
    updated.unlockedLessonIds.add(firstLessonId);
    await _repository.save(updated);
    return updated;
  }

  bool isLessonUnlocked(LocalProgress progress, String lessonId) =>
      progress.unlockedLessonIds.contains(lessonId);

  bool isLessonCompleted(LocalProgress progress, String lessonId) =>
      progress.completedLessonIds.contains(lessonId);

  bool isSectionCompleted(LocalProgress progress, String sectionId) =>
      progress.completedSectionIds.contains(sectionId);

  /// Marks a section (chapter) complete, awards points, and if all sections
  /// in the lesson are done, unlocks the next lesson.
  Future<LocalProgress> completeSection({
    required LocalProgress progress,
    required Journey journey,
    required String lessonId,
    required String sectionId,
    required int pointsEarned,
  }) async {
    final updated = progress.clone();
    updated.completedSectionIds.add(sectionId);
    updated.totalPoints += pointsEarned;

    // Check if the whole lesson is now complete
    final lesson = journey.lessons.firstWhere((l) => l.id == lessonId);
    final allSectionsCompleted = lesson.sections.every(
      (s) => updated.completedSectionIds.contains(s.id),
    );

    if (allSectionsCompleted) {
      updated.completedLessonIds.add(lessonId);

      final activeLessons = journey.activeLessons;
      final index = activeLessons.indexWhere((l) => l.id == lessonId);
      if (index != -1 && index + 1 < activeLessons.length) {
        updated.unlockedLessonIds.add(activeLessons[index + 1].id);
      }
    }

    await _repository.save(updated);
    return updated;
  }

  /// DEBUG ONLY. Marks every section and lesson in [journey.activeLessons]
  /// as complete, unlocks them all, and awards the same points a real
  /// completion would (sum of `pointsAwarded` across each section's tasks).
  /// Testing shortcut to jump straight to "journey finished" state.
  /// No-op outside debug builds.
  Future<LocalProgress> debugCompleteAllLessons({
    required LocalProgress progress,
    required Journey journey,
  }) async {
    if (!kDebugMode) return progress;

    final updated = progress.clone();
    for (final lesson in journey.activeLessons) {
      for (final section in lesson.sections) {
        if (updated.completedSectionIds.add(section.id)) {
          final sectionPoints = section.tasks.fold<int>(
            0,
            (sum, task) => sum + task.pointsAwarded,
          );
          updated.totalPoints += sectionPoints;
        }
      }
      updated.completedLessonIds.add(lesson.id);
      updated.unlockedLessonIds.add(lesson.id);
    }

    await _repository.save(updated);
    return updated;
  }

  /// DEBUG ONLY. Manually updates progress for a specific lesson to help test
  /// UI states (Reset, Partial, Complete).
  Future<LocalProgress> debugUpdateLessonProgress({
    required LocalProgress progress,
    required Journey journey,
    required String lessonId,
    required double percent, // 0.0 to 1.0
  }) async {
    if (!kDebugMode) return progress;

    final updated = progress.clone();
    final lesson = journey.lessons.firstWhere((l) => l.id == lessonId);

    // 1. Clear existing completion for this lesson and its sections
    updated.completedLessonIds.remove(lessonId);
    for (final section in lesson.sections) {
      updated.completedSectionIds.remove(section.id);
    }

    // 2. Add sections based on percent
    final sectionsToMark = (lesson.sections.length * percent).round();
    for (int i = 0; i < sectionsToMark; i++) {
      updated.completedSectionIds.add(lesson.sections[i].id);
    }

    // 3. Mark lesson complete if 100%
    if (percent >= 1.0) {
      updated.completedLessonIds.add(lessonId);

      // Unlock next lesson
      final activeLessons = journey.activeLessons;
      final index = activeLessons.indexWhere((l) => l.id == lessonId);
      if (index != -1 && index + 1 < activeLessons.length) {
        updated.unlockedLessonIds.add(activeLessons[index + 1].id);
      }
    }

    await _repository.save(updated);
    return updated;
  }

  Future<LocalProgress> updateUserName(
    LocalProgress progress,
    String name,
  ) async {
    final updated = progress.clone()..userName = name.trim();
    await _repository.save(updated);
    return updated;
  }

  Future<LocalProgress> updateSoundEnabled(
    LocalProgress progress,
    bool enabled,
  ) async {
    final updated = progress.clone()..soundEnabled = enabled;
    await _repository.save(updated);
    return updated;
  }

  Future<LocalProgress> updateHapticsEnabled(
    LocalProgress progress,
    bool enabled,
  ) async {
    final updated = progress.clone()..hapticsEnabled = enabled;
    await _repository.save(updated);
    return updated;
  }

  Future<LocalProgress> updateThemeSeedColor(
    LocalProgress progress,
    int colorValue,
  ) async {
    final updated = progress.clone()..themeSeedColor = colorValue;
    await _repository.save(updated);
    return updated;
  }

  Future<LocalProgress> updateDailyGoal(
    LocalProgress progress,
    int minutes,
  ) async {
    final updated = progress.clone()..dailyGoalMinutes = minutes;
    await _repository.save(updated);
    return updated;
  }

  Future<LocalProgress> addPoints(LocalProgress progress, int points) async {
    final updated = progress.clone()..totalPoints += points;
    await _repository.save(updated);
    return updated;
  }

  Future<LocalProgress> completeOnboarding(LocalProgress progress) async {
    final updated = progress.clone()..hasCompletedOnboarding = true;
    await _repository.save(updated);
    return updated;
  }

  Future<LocalProgress> updateDeveloperMode(
    LocalProgress progress,
    bool enabled,
  ) async {
    final updated = progress.clone()..isDeveloperModeEnabled = enabled;
    await _repository.save(updated);
    return updated;
  }

  /// Records the score for a game and unlocks the next difficulty if won.
  Future<LocalProgress> recordGameScore({
    required LocalProgress progress,
    required String gameId,
    required int score,
    required GameDifficulty difficulty,
    required bool won,
  }) async {
    final updated = progress.clone();

    // 1. Update high score
    final gameScores = updated.gameHighScores[gameId] ?? {};
    final currentHigh = gameScores[difficulty.name] ?? 0;
    if (score > currentHigh) {
      gameScores[difficulty.name] = score;
      updated.gameHighScores[gameId] = gameScores;
    }

    // 2. Unlock next difficulty if won
    if (won) {
      final currentMaxUnlocked = updated.unlockedGameDifficulties[gameId] ?? 0;
      if (difficulty.index == currentMaxUnlocked && difficulty.index <= 2) {
        updated.unlockedGameDifficulties[gameId] = difficulty.index + 1;
      }
    }

    await _repository.save(updated);
    return updated;
  }

  /// How many of [itemId] the user currently owns (0 if none).
  int itemQuantity(LocalProgress progress, String itemId) =>
      progress.ownedItemQuantities[itemId] ?? 0;

  /// Whether the user owns at least one of [itemId].
  bool isItemOwned(LocalProgress progress, String itemId) =>
      itemQuantity(progress, itemId) > 0;

  Future<LocalProgress> consumeItem(
    LocalProgress progress,
    String itemId,
  ) async {
    final count = itemQuantity(progress, itemId);
    if (count <= 0) return progress;

    final updated = progress.clone();
    updated.ownedItemQuantities[itemId] = count - 1;
    await _repository.save(updated);
    return updated;
  }

  /// Equips [item] into its avatar slot. [item] must already be owned
  /// (or free/default) — callers should only offer owned items in the
  /// customization UI. No-ops if the item has no avatarSlot or isn't owned.
  Future<LocalProgress> equipItem(LocalProgress progress, ShopItem item) async {
    if (item.avatarSlot == null) return progress;

    final owned = item.price == 0 || isItemOwned(progress, item.id);
    if (!owned) return progress;

    final updated = progress.clone();
    updated.equippedItemIds[item.avatarSlot!.name] = item.id;
    await _repository.save(updated);
    return updated;
  }

  /// Attempts to buy [item] with gems from [progress.totalPoints].
  ///
  /// Non-stackable items (e.g. cosmetic avatars) can only be bought once;
  /// stackable items (e.g. streak freezes) can be bought repeatedly to
  /// build up a quantity. Does not mutate [progress] on failure.
  ///
  /// NOTE: this only records ownership/quantity — it doesn't yet wire the
  /// streak freeze into registerAppOpen's streak-reset logic, so owning
  /// one doesn't actually protect a missed day yet. That's a separate
  /// change to registerAppOpen if/when you want it to consume one.
  Future<(LocalProgress, PurchaseResult)> purchaseItem({
    required LocalProgress progress,
    required ShopItem item,
  }) async {
    if (!item.stackable && isItemOwned(progress, item.id)) {
      return (progress, PurchaseResult.alreadyOwned);
    }
    if (progress.totalPoints < item.price) {
      return (progress, PurchaseResult.insufficientGems);
    }

    final updated = progress.clone();
    updated.totalPoints -= item.price;
    updated.ownedItemQuantities[item.id] = itemQuantity(updated, item.id) + 1;

    await _repository.save(updated);
    return (updated, PurchaseResult.success);
  }
}
