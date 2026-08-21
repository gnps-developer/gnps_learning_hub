import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gnps_learning_hub/models/task.dart';
import 'package:gnps_learning_hub/widgets/tasks/trace_task_widget.dart';
import 'package:gnps_learning_hub/widgets/tasks/spelling_task_widget.dart';
import 'package:gnps_learning_hub/providers/audio_providers.dart';
import 'package:gnps_learning_hub/services/audio_service.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioService extends Mock implements AudioService {}

void main() {
  late MockAudioService mockAudioService;

  setUp(() {
    mockAudioService = MockAudioService();
    when(() => mockAudioService.speak(any())).thenAnswer((_) async {});
  });

  group('Task Audio Integration', () {
    testWidgets('TraceTaskWidget should request correct audio path on init', (tester) async {
      final task = Task(
        id: 'trace_test',
        type: TaskType.trace,
        pointsAwarded: 10,
        content: {
          'letter': 'ੳ',
          'audioFile': 'audio/lessons/alphabets/ura.mp3',
        },
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            audioServiceProvider.overrideWithValue(mockAudioService),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: TraceTaskWidget(task: task, onComplete: () {}),
            ),
          ),
        ),
      );

      // Tracing tasks have an auto-play delay
      await tester.pump(const Duration(milliseconds: 1500));

      verify(() => mockAudioService.speak('audio/lessons/alphabets/ura.mp3')).called(1);
    });

    testWidgets('SpellingTaskWidget should request correct audio path on init', (tester) async {
      final task = Task(
        id: 'spelling_test',
        type: TaskType.spelling,
        pointsAwarded: 15,
        content: {
          'emoji': '🐱',
          'targetWord': 'ਬਿੱਲੀ',
          'audioFile': 'audio/lessons/words/cat.mp3',
          'letterBank': ['ਬਿ', 'ੱ', 'ਲੀ'],
        },
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            audioServiceProvider.overrideWithValue(mockAudioService),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SpellingTaskWidget(task: task, onComplete: () {}),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 1500));

      verify(() => mockAudioService.speak('audio/lessons/words/cat.mp3')).called(1);
    });
  });
}
