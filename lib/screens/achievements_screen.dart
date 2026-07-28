import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      appBar: AppBar(title: const Text('Achievements')),
      body: progressAsync.when(
        data: (progress) => journeyAsync.when(
          data: (journey) => ListView(
            padding: const EdgeInsets.all(24),
            children: journey.games.map((game) {
              // Only show achievements for games that are unlocked on the map
              final isUnlocked = progress.unlockedLessonIds
                  .contains(game.unlockAfterLessonId);
              if (!isUnlocked) return const SizedBox.shrink();

              final trophies = progress.unlockedGameDifficulties[game.id] ?? 0;
              final scores = progress.gameHighScores[game.id] ?? {};

              return _GameAchievementCard(
                title: game.title,
                trophies: trophies,
                scores: scores,
                icon: game.icon ?? Icons.videogame_asset,
              );
            }).toList(),
          ),
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
      margin: const EdgeInsets.only(bottom: 24),
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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _TrophyItem(
                  level: GameDifficulty.easy,
                  isEarned: trophies >= 1,
                  score: scores[GameDifficulty.easy.name] ?? 0,
                  color: const Color(0xFFCD7F32), // Bronze
                ),
                _TrophyItem(
                  level: GameDifficulty.medium,
                  isEarned: trophies >= 2,
                  score: scores[GameDifficulty.medium.name] ?? 0,
                  color: const Color(0xFFC0C0C0), // Silver
                ),
                _TrophyItem(
                  level: GameDifficulty.hard,
                  isEarned: trophies >= 3,
                  score: scores[GameDifficulty.hard.name] ?? 0,
                  color: const Color(0xFFFFD700), // Gold
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
        const SizedBox(height: 8),
        Text(
          level.displayName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isEarned ? null : Colors.grey,
          ),
        ),
        if (isEarned)
          Text(
            '$score ⭐',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
          ),
      ],
    );
  }
}
