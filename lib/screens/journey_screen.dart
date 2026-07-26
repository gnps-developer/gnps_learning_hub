import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/journey.dart';
import '../models/lesson.dart';
import '../models/progress.dart';
import '../providers/content_providers.dart';
import '../providers/progress_providers.dart';
import '../widgets/journey/lesson_path.dart';
import '../widgets/journey/journey_banner.dart';
import 'lesson_screen.dart';
import 'profile_screen.dart';
import 'shop_screen.dart';

import '../models/game_config.dart';
import '../games/bubble_game_screen.dart';

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

  void _openGame(GameConfig game, Journey journey) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => BubbleGameScreen(game: game)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final journeyAsync = ref.watch(journeyProvider);
    final progressAsync = ref.watch(progressProvider);

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
  final void Function(Lesson lesson) onTapLesson;
  final void Function(GameConfig game) onTapGame;

  const _JourneyContent({
    required this.journey,
    required this.progress,
    required this.onTapLesson,
    required this.onTapGame,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        JourneyBanner(
          streak: progress.currentStreak,
          points: progress.totalPoints,
          hearts: progress.ownedItemQuantities['powerup_extra_life'] ?? 0,
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
