import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/journey.dart';
import '../models/lesson.dart';
import '../models/progress.dart';
import '../providers/content_providers.dart';
import '../providers/progress_providers.dart';
import '../providers/shop_providers.dart';
import '../models/shop/shop_item.dart';
import '../widgets/journey/lesson_path.dart';
import '../widgets/journey/journey_banner.dart';
import 'lesson_screen.dart';
import 'profile_screen.dart';
import 'shop_screen.dart';

import '../models/game_config.dart';
import '../models/shop/default_item_ids.dart';
import '../games/bubble_game_screen.dart';
import '../widgets/celebration/achievement_celebration_overlay.dart';

class JourneyScreen extends ConsumerStatefulWidget {
  const JourneyScreen({super.key});

  @override
  ConsumerState<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends ConsumerState<JourneyScreen> {
  int _tabIndex = 0;

  Future<void> _openLesson(Lesson lesson, Journey journey) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LessonScreen(lesson: lesson, journey: journey),
      ),
    );
  }

  void _openGame(GameConfig game, Journey journey) async {
    final progress = ref.read(progressProvider).value;
    final hearts = progress?.ownedItemQuantities[DefaultItemIds.extraLife] ?? 0;

    if (hearts <= 0) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('No Hearts! ❤️'),
              content: const Text(
                'You need at least one heart to play this game. Visit the shop to get more!',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() => _tabIndex = 1); // Switch to Shop tab
                  },
                  child: const Text('Go to Shop'),
                ),
              ],
            ),
      );
      return;
    }

    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => BubbleGameScreen(game: game)),
    );

    if (result != null && mounted) {
      _showAchievementCelebration(
        result['gameTitle'] as String,
        result['difficultyIndex'] as int,
      );
    }
  }

  void _showAchievementCelebration(String title, int index) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Celebration',
      barrierColor: Colors.black.withValues(alpha: 0.85),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, __, ___) => AchievementCelebrationOverlay(
        gameTitle: title,
        difficultyIndex: index,
        onDismiss: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final journeyAsync = ref.watch(journeyProvider);
    final progressAsync = ref.watch(progressProvider);
    final catalog = ref.watch(shopCatalogProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false, // NavigationBar handles the bottom inset itself
        child: IndexedStack(
          index: _tabIndex,
          children: [
            journeyAsync.when(
              data: (journey) => progressAsync.when(
                data: (progress) => _JourneyContent(
                  journey: journey,
                  progress: progress,
                  catalog: catalog,
                  onTapLesson: (lesson) => _openLesson(lesson, journey),
                  onTapGame: (game) => _openGame(game, journey),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) =>
                    Center(child: Text('Error loading progress: $e')),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error loading lessons: $e')),
            ),
            const ShopScreen(),
            const ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (i) => setState(() => _tabIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            label: 'Journey',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            label: 'Shop',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _JourneyContent extends StatelessWidget {
  final Journey journey;
  final LocalProgress progress;
  final List<ShopItem> catalog;
  final void Function(Lesson lesson) onTapLesson;
  final void Function(GameConfig game) onTapGame;

  const _JourneyContent({
    required this.journey,
    required this.progress,
    required this.catalog,
    required this.onTapLesson,
    required this.onTapGame,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        JourneyBanner(
          progress: progress,
          catalog: catalog,
        ),
        Expanded(
          child: LessonPath(
            lessons: journey.activeLessons,
            games: journey.games,
            unlockedIds: progress.unlockedLessonIds,
            completedIds: progress.completedLessonIds,
            completedSectionIds: progress.completedSectionIds,
            onTapLesson: onTapLesson,
            onTapGame: onTapGame,
          ),
        ),
      ],
    );
  }
}
