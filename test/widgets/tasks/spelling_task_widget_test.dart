import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gnps_learning_hub/models/task.dart';
import 'package:gnps_learning_hub/widgets/tasks/spelling_task_widget.dart';
import 'package:gnps_learning_hub/widgets/common/task_check_button.dart';

void main() {
  final testTask = Task(
    id: 't1',
    type: TaskType.spelling,
    pointsAwarded: 10,
    content: {
      'emoji': '🍎',
      'targetWord': 'ਸੇਬ',
      'letterBank': ['ਸੇ', 'ਬ', 'ਕ'],
    },
  );

  testWidgets('SpellingTaskWidget should render correctly and handle taps', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SpellingTaskWidget(
              task: testTask,
              onComplete: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Spell the word'), findsOneWidget);
    expect(find.text('🍎'), findsOneWidget);
    
    // Letters from bank
    expect(find.text('ਸੇ'), findsOneWidget);
    expect(find.text('ਬ'), findsOneWidget);
    expect(find.text('ਕ'), findsOneWidget);

    // Tap a letter to build
    await tester.tap(find.text('ਸੇ'));
    await tester.pump();
    
    // Check button should now be enabled (or at least present)
    expect(find.byType(TaskCheckButton), findsOneWidget);

    // Let the auto-play timer finish
    await tester.pump(const Duration(milliseconds: 1000));
  });
}
