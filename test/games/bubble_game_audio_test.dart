import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gnps_learning_hub/games/bubble_game_screen.dart';
import 'package:gnps_learning_hub/models/game_config.dart';
import 'package:gnps_learning_hub/providers/audio_providers.dart';
import 'package:gnps_learning_hub/services/audio_service.dart';
import 'package:gnps_learning_hub/providers/progress_providers.dart';
import 'package:gnps_learning_hub/models/progress.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioService extends Mock implements AudioService {}
class MockProgressNotifier extends StateNotifier<AsyncValue<LocalProgress>> with Mock implements ProgressNotifier {
  MockProgressNotifier() : super(AsyncValue.data(LocalProgress()));
}

void main() {
  late MockAudioService mockAudioService;

  setUp(() {
    mockAudioService = MockAudioService();
    when(() => mockAudioService.speak(any())).thenAnswer((_) async {});
  });

  testWidgets('BubbleGameScreen should request correct audio from itemPool', (tester) async {
    final game = GameConfig(
      id: 'test_game',
      title: 'Test Game',
      type: 'bubble_pop',
      unlockAfterLessonId: 'none',
      content: {
        'itemPool': {
          'ੳ': 'audio/lessons/alphabets/ura.mp3',
        },
        'initialDelayMs': 0,
      },
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioServiceProvider.overrideWithValue(mockAudioService),
          progressProvider.overrideWith((ref) => MockProgressNotifier()),
        ],
        child: MaterialApp(
          home: BubbleGameScreen(game: game),
        ),
      ),
    );

    // Start game (Easy mode)
    await tester.tap(find.text('Easy'));
    await tester.pump();

    // The game picks the only item 'ੳ' and should speak its mapped path
    await tester.pump(const Duration(milliseconds: 500));

    verify(() => mockAudioService.speak('audio/lessons/alphabets/ura.mp3')).called(1);
  });
}
