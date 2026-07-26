import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gnps_learning_hub/models/task.dart';
import 'package:gnps_learning_hub/widgets/tasks/matching_pictures_task_widget.dart';

void main() {
  final testTask = Task(
    id: 'mp_test',
    type: TaskType.matchingPictures,
    pointsAwarded: 10,
    content: {
      'word': 'ਕ',
      'correctEmoji': '🎨',
      'distractorEmojis': ['🍎', '🐶', '🚗'],
    },
  );

  testWidgets('MatchingPicturesTaskWidget should render emoji options', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: MatchingPicturesTaskWidget(
              task: testTask,
              onComplete: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Select the correct picture'), findsOneWidget);
    expect(find.text('ਕ'), findsOneWidget);
    expect(find.text('🎨'), findsOneWidget);
    expect(find.text('🍎'), findsOneWidget);
    expect(find.text('🐶'), findsOneWidget);
    expect(find.text('🚗'), findsOneWidget);

    // Let the auto-play timer finish
    await tester.pump(const Duration(milliseconds: 1000));
  });
}
