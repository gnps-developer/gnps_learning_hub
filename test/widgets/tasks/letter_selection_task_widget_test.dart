import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gnps_learning_hub/models/task.dart';
import 'package:gnps_learning_hub/widgets/tasks/letter_selection_task_widget.dart';
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

  final testTask = Task(
    id: 'ls_test',
    type: TaskType.letterSelection,
    pointsAwarded: 10,
    content: {
      'correctLetter': 'ਕ',
      'distractorLetters': ['ਖ', 'ਗ', 'ਘ'],
    },
  );

  testWidgets('LetterSelectionTaskWidget should render letter options', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioServiceProvider.overrideWithValue(mockAudioService),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: LetterSelectionTaskWidget(
              task: testTask,
              onComplete: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Listen and select the correct letter'), findsOneWidget);
    expect(find.text('ਕ'), findsOneWidget);
    expect(find.text('ਖ'), findsOneWidget);
    expect(find.text('ਗ'), findsOneWidget);
    expect(find.text('ਘ'), findsOneWidget);

    // Let the auto-play timer finish
    await tester.pump(const Duration(milliseconds: 1000));
  });

  testWidgets('LetterSelectionTaskWidget should enforce 4 options limit', (tester) async {
    final extraTask = Task(
      id: 'ls_extra',
      type: TaskType.letterSelection,
      pointsAwarded: 10,
      content: {
        'correctLetter': 'A',
        'distractorLetters': ['B', 'C', 'D', 'E', 'F'],
      },
    );
    
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioServiceProvider.overrideWithValue(mockAudioService),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: LetterSelectionTaskWidget(
              task: extraTask,
              onComplete: () {},
            ),
          ),
        ),
      ),
    );
    
    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);
    expect(find.text('D'), findsOneWidget);
    expect(find.text('E'), findsNothing);

    // Let the auto-play timer finish
    await tester.pump(const Duration(milliseconds: 1000));
  });
}
