import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gnps_learning_hub/models/task.dart';
import 'package:gnps_learning_hub/widgets/tasks/fill_in_blank_task_widget.dart';

void main() {
  final testTask = Task(
    id: 't3',
    type: TaskType.fillInBlank,
    pointsAwarded: 10,
    content: {
      'sentenceParts': ['ਮੇਰਾ ਨਾਮ', '___', 'ਹੈ।'],
      'correctWord': 'ਅਮਨ',
      'options': ['ਅਮਨ', 'ਰਾਹੁਲ'],
    },
  );

  testWidgets('FillInBlankTaskWidget should render parts and options', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: FillInBlankTaskWidget(
              task: testTask,
              onComplete: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Fill in the blank'), findsOneWidget);
    expect(find.text('ਮੇਰਾ ਨਾਮ'), findsOneWidget);
    expect(find.text('ਅਮਨ'), findsOneWidget);
    expect(find.text('ਰਾਹੁਲ'), findsOneWidget);

    // Let the auto-play timer finish
    await tester.pump(const Duration(milliseconds: 1000));
  });
}
