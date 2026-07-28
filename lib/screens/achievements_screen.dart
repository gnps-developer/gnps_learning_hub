import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/ui_config.dart';
import '../config/ui_strings.dart';
import '../models/games/game_difficulty.dart';
import '../providers/content_providers.dart';
import '../providers/progress_providers.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressProvider);
    final journeyAsync = ref.watch(journeyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(UIStrings.achievementsTitle)),
      body: progressAsync.when(
        data: (progress) => journeyAsync.when(
          data: (journey) {
            final unlockedGameCards = journey.games
                .map((game) {
                  // Only show achievements for games that are unlocked (completed anchor lesson)
                  final isUnlocked = progress.completedLessonIds
                      .contains(game.unlockAfterLessonId);
                  if (!isUnlocked) return const SizedBox.shrink();

                  final trophies =
                      progress.unlockedGameDifficulties[game.id] ?? 0;
                  final scores = progress.gameHighScores[game.id] ?? {};

                  return _GameAchievementCard(
                    title: game.title,
                    trophies: trophies,
                    scores: scores,
                    icon: game.icon ?? Icons.videogame_asset,
                  );
                })
                .where((w) => w is! SizedBox)
                .toList();

            if (unlockedGameCards.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: Text(
                    UIStrings.noTrophiesMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: unlockedGameCards,
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error loading journey: $e')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading profile: $e')),
      ),
    );
  }
}

class _GameAchievementCard extends StatelessWidget {
  final String title;
  final int trophies;
  final Map<String, int> scores;
  final IconData icon;

  const _GameAchievementCard({
    required this.title,
    required this.trophies,
    required this.scores,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TrophyItem(
                  level: GameDifficulty.easy,
                  isEarned: trophies >= 1,
                  score: scores[GameDifficulty.easy.name] ?? 0,
                  color: AppColors.bronze,
                ),
                _TrophyItem(
                  level: GameDifficulty.medium,
                  isEarned: trophies >= 2,
                  score: scores[GameDifficulty.medium.name] ?? 0,
                  color: AppColors.silver,
                ),
                _TrophyItem(
                  level: GameDifficulty.hard,
                  isEarned: trophies >= 3,
                  score: scores[GameDifficulty.hard.name] ?? 0,
                  color: AppColors.gold,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TrophyItem extends StatelessWidget {
  final GameDifficulty level;
  final bool isEarned;
  final int score;
  final Color color;

  const _TrophyItem({
    required this.level,
    required this.isEarned,
    required this.score,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final showBestScore = !isEarned && score > 0;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.emoji_events,
              color: isEarned ? color : Colors.grey.shade300,
              size: 48,
            ),
            if (!isEarned)
              const Icon(
                Icons.lock,
                size: 16,
                color: Colors.grey,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          level.displayName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isEarned ? null : Colors.grey,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        SizedBox(
          height: 16,
          child: showBestScore
              ? Text(
                  UIStrings.bestAttempt(score),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.warning.shade800,
                      ),
                )
              : null,
        ),
      ],
    );
  }
}
