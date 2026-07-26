import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnps_learning_hub/games/bubble_game_screen.dart';
import 'package:gnps_learning_hub/models/game_config.dart';
import 'package:gnps_learning_hub/models/progress.dart';
import 'package:gnps_learning_hub/providers/progress_providers.dart';
import 'package:gnps_learning_hub/providers/audio_providers.dart';
import 'package:gnps_learning_hub/repositories/progress_repository.dart';
import 'package:gnps_learning_hub/services/progress_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gnps_learning_hub/services/audio_service.dart';

class MockAudioService extends Mock implements AudioService {}

void main() {
  const testGame = GameConfig(
    id: 'bubble_pop_letters',
    title: 'Letter Bubbles',
    unlockAfterLessonId: 'l1',
    type: 'bubble_pop',
    content: {
      'letters': ['ੳ', 'ਅ'],
      'spawnRateMs': 1000,
    },
  );

  late MockAudioService mockAudioService;
  late MockProgressRepository mockProgressRepository;

  setUp(() {
    mockAudioService = MockAudioService();
    mockProgressRepository = MockProgressRepository();
    
    when(() => mockAudioService.speak(any())).thenAnswer((_) async {});
    when(() => mockProgressRepository.load()).thenAnswer((_) async => LocalProgress());
  });

  testWidgets('BubbleGameScreen should render and show initial score', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          progressProvider.overrideWith((ref) => ProgressNotifier(
                mockProgressRepository,
                ProgressService(mockProgressRepository),
                mockAudioService,
              )),
          audioServiceProvider.overrideWithValue(mockAudioService),
        ],
        child: const MaterialApp(
          home: BubbleGameScreen(game: testGame),
        ),
      ),
    );

    // Initial state check
    expect(find.text('Score: 0'), findsOneWidget);
    expect(find.text('Listen to the letter:'), findsOneWidget);

    // To handle pending timers from _initGame
    await tester.pump(const Duration(seconds: 3));

    // Dispose the widget to stop timers
    await tester.pumpWidget(Container());
  });
}

class MockProgressRepository extends Mock implements ProgressRepository {}
