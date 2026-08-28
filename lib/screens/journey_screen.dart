import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/ui_config.dart';
import '../config/ui_strings.dart';
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
import 'achievements_screen.dart';

import '../models/game_config.dart';
import '../models/shop/default_item_ids.dart';
import '../providers/navigation_providers.dart';
import '../games/bubble_game_screen.dart';
import '../games/crossword_game_screen.dart';
import '../widgets/celebration/achievement_celebration_overlay.dart';

class JourneyScreen extends ConsumerStatefulWidget {
  const JourneyScreen({super.key});

  @override
  ConsumerState<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends ConsumerState<JourneyScreen> {
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
              title: const Text(UIStrings.noHeartsTitle),
              content: const Text(UIStrings.noHeartsContent),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(UIStrings.cancel),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ref.read(mainNavigationProvider.notifier).state =
                        1; // Switch to Shop tab
                  },
                  child: const Text(UIStrings.goToShop),
                ),
              ],
            ),
      );
      return;
    }

    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => game.type == 'crossword'
            ? CrosswordGameScreen(game: game)
            : BubbleGameScreen(game: game),
      ),
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
      barrierColor: AppColors.overlayDark,
      transitionDuration: AppDurations.medium,
      pageBuilder: (context, _, _) => AchievementCelebrationOverlay(
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
    final catalogAsync = ref.watch(shopCatalogProvider);
    final tabIndex = ref.watch(mainNavigationProvider);

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: tabIndex,
          children: [
            journeyAsync.when(
              data: (journey) => progressAsync.when(
                data: (progress) => catalogAsync.when(
                  data: (catalog) => _JourneyContent(
                    journey: journey,
                    progress: progress,
                    catalog: catalog,
                    onTapLesson: (lesson) => _openLesson(lesson, journey),
                    onTapGame: (game) => _openGame(game, journey),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error loading catalog: $e')),
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
        selectedIndex: tabIndex,
        onDestinationSelected: (i) =>
            ref.read(mainNavigationProvider.notifier).state = i,
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

class _JourneyContent extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        JourneyBanner(
          progress: progress,
          catalog: catalog,
          onTapGems: () =>
              ref.read(mainNavigationProvider.notifier).state = 1,
          onTapAchievements: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AchievementsScreen()),
          ),
          onTapProfile: () =>
              ref.read(mainNavigationProvider.notifier).state = 2,
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
