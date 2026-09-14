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
                  final trophies =
                      progress.unlockedGameDifficulties[game.id] ?? 0;
                  final scores = progress.gameHighScores[game.id] ?? {};

                  // Show if unlocked via lesson OR if some trophies were already earned (e.g. debug/saved)
                  final isUnlocked = progress.completedLessonIds.contains(game.unlockAfterLessonId);
                  if (!isUnlocked && trophies == 0 && scores.isEmpty) return const SizedBox.shrink();

                  final totalLevels = game.type == 'crossword' 
                      ? (game.content['levels'] as List?)?.length ?? 0
                      : 0;

                  return _GameAchievementCard(
                    title: game.title,
                    trophies: trophies,
                    scores: scores,
                    icon: game.icon ?? Icons.videogame_asset,
                    isCrossword: game.type == 'crossword',
                    totalLevels: totalLevels,
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

            final achievementCount = ref.read(progressServiceProvider).calculateAchievementCount(
                  journey: journey,
                  unlockedGameDifficulties: progress.unlockedGameDifficulties,
                );

            return ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                _AchievementSummaryHeader(
                  count: achievementCount,
                ),
                const SizedBox(height: AppSpacing.lg),
                ...unlockedGameCards,
              ],
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

class _AchievementSummaryHeader extends StatelessWidget {
  final int count;

  const _AchievementSummaryHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.stars, color: Colors.white, size: 48),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TOTAL ACHIEVEMENTS',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                '$count Earned',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GameAchievementCard extends StatelessWidget {
  final String title;
  final int trophies;
  final Map<String, int> scores;
  final IconData icon;
  final bool isCrossword;
  final int totalLevels;

  const _GameAchievementCard({
    required this.title,
    required this.trophies,
    required this.scores,
    required this.icon,
    this.isCrossword = false,
    this.totalLevels = 0,
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (isCrossword)
                        Text(
                          'Progress: ${trophies.clamp(0, totalLevels)} / $totalLevels Levels',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            if (isCrossword)
              Center(
                child: _MasterBadgeItem(
                  isEarned: trophies >= totalLevels && totalLevels > 0,
                  label: UIStrings.trophyMaster,
                  color: AppColors.master,
                ),
              )
            else
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

class _MasterBadgeItem extends StatelessWidget {
  final bool isEarned;
  final String label;
  final Color color;

  const _MasterBadgeItem({
    required this.isEarned,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.military_tech,
              color: isEarned ? color : Colors.grey.shade300,
              size: 64,
            ),
            if (!isEarned)
              const Icon(
                Icons.lock,
                size: 20,
                color: Colors.grey,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isEarned ? color : Colors.grey,
          ),
        ),
      ],
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
