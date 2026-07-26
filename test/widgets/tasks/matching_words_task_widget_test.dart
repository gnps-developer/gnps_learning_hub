import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gnps_learning_hub/models/task.dart';
import 'package:gnps_learning_hub/widgets/tasks/matching_words_task_widget.dart';
import 'package:gnps_learning_hub/providers/audio_providers.dart';
import 'package:gnps_learning_hub/services/audio_service.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioService extends Mock implements AudioService {}

void main() {
  late MockAudioService mockAudioService;

  setUp(() {
    mockAudioService = MockAudioService();
    when(() => mockAudioService.playSuccess()).thenAnswer((_) async {});
    when(() => mockAudioService.playFailure()).thenAnswer((_) async {});
    when(() => mockAudioService.speak(any())).thenAnswer((_) async {});
  });

  final testTask = Task(
    id: 'mw_test',
    type: TaskType.matchingWords,
    pointsAwarded: 10,
    content: {
      'pairs': {
        'ਲਾਲ': 'Red',
        'ਨੀਲਾ': 'Blue',
      },
    },
  );

  testWidgets('MatchingWordsTaskWidget should render pairs', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioServiceProvider.overrideWithValue(mockAudioService),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: MatchingWordsTaskWidget(
              task: testTask,
              onComplete: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Match Gurmukhi words to English'), findsOneWidget);
    expect(find.text('ਲਾਲ'), findsOneWidget);
    expect(find.text('ਨੀਲਾ'), findsOneWidget);
    expect(find.text('Red'), findsOneWidget);
    expect(find.text('Blue'), findsOneWidget);
  });
}
