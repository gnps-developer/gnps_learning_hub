import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gnps_learning_hub/models/task.dart';
import 'package:gnps_learning_hub/widgets/tasks/arrange_sentence_task_widget.dart';

void main() {
  final testTask = Task(
    id: 't2',
    type: TaskType.arrangeSentence,
    pointsAwarded: 10,
    content: {
      'words': ['ਮੈਂ', 'ਸਕੂਲ', 'ਜਾਂਦਾ', 'ਹਾਂ'],
      'correctOrder': [0, 1, 2, 3],
    },
  );

  testWidgets('ArrangeSentenceTaskWidget should render words', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ArrangeSentenceTaskWidget(
              task: testTask,
              onComplete: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Arrange the sentence'), findsOneWidget);
    expect(find.text('ਮੈਂ'), findsOneWidget);
    expect(find.text('ਸਕੂਲ'), findsOneWidget);

    // Let the auto-play timer finish
    await tester.pump(const Duration(milliseconds: 1000));
  });
}
