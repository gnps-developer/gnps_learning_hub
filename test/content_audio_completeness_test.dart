// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gnps_learning_hub/models/task.dart';
import 'package:gnps_learning_hub/widgets/tasks/trace_task_widget.dart';
import 'package:gnps_learning_hub/widgets/tasks/spelling_task_widget.dart';
import 'package:gnps_learning_hub/widgets/tasks/letter_selection_task_widget.dart';
import 'package:gnps_learning_hub/widgets/tasks/matching_pictures_task_widget.dart';
import 'package:gnps_learning_hub/widgets/tasks/matching_words_task_widget.dart';
import 'package:gnps_learning_hub/widgets/tasks/fill_in_blank_task_widget.dart';
import 'package:gnps_learning_hub/widgets/tasks/arrange_sentence_task_widget.dart';
import 'package:gnps_learning_hub/providers/audio_providers.dart';
import 'package:gnps_learning_hub/services/audio_service.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioService extends Mock implements AudioService {}

void main() {
  final projectRoot = _findProjectRoot();
  final lessonsDir = Directory('$projectRoot/assets/data/lessons');
  late MockAudioService mockAudioService;

  setUp(() {
    mockAudioService = MockAudioService();
    when(() => mockAudioService.speak(any())).thenAnswer((_) async {});
  });

  if (!lessonsDir.existsSync()) {
    print('⚠️  Skipping completeness test: Lessons directory not found.');
    return;
  }

  final files = lessonsDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'));

  group('Curriculum Audio Completeness Audit', () {
    for (final file in files) {
      final json = jsonDecode(file.readAsStringSync());
      final lessonId = json['id'] as String;
      final sections = json['sections'] as List;

      group('Lesson: $lessonId', () {
        for (final section in sections) {
          final tasks = section['tasks'] as List;
          for (final taskData in tasks) {
            final taskId = taskData['id'] as String;
            final taskType = taskData['type'] as String;

            testWidgets('Task $taskId ($taskType) should play its defined audio',
                (tester) async {
              final task = Task.fromJson(taskData);
              final expectedPath = task.content['audioFile'] as String?;

              // Build the task widget
              await tester.pumpWidget(
                ProviderScope(
                  overrides: [
                    audioServiceProvider.overrideWithValue(mockAudioService),
                  ],
                  child: MaterialApp(
                    home: Scaffold(
                      body: _buildTaskWidget(task),
                    ),
                  ),
                ),
              );

              // Wait for auto-play delay
              await tester.pump(const Duration(milliseconds: 1500));

              if (expectedPath != null) {
                verify(() => mockAudioService.speak(expectedPath)).called(1);
              } else if (task.type == TaskType.matchingWords) {
                // Matching words uses a pool, we check if clicking a tile works
                final pool = task.content['itemPool'] as Map;
                final firstKey = pool.keys.first as String;
                final firstPath = pool.values.first as String;

                await tester.tap(find.text(firstKey));
                verify(() => mockAudioService.speak(firstPath)).called(1);
              } else if (task.type == TaskType.arrangeSentence) {
                 final path = task.content['audioFile'] as String?;
                 if (path != null) {
                   await tester.tap(find.byIcon(Icons.campaign));
                   verify(() => mockAudioService.speak(path)).called(1);
                 }
              }
            });
          }
        }
      });
    }
  });
}

Widget _buildTaskWidget(Task task) {
  switch (task.type) {
    case TaskType.trace:
      return TraceTaskWidget(task: task, onComplete: () {});
    case TaskType.spelling:
      return SpellingTaskWidget(task: task, onComplete: () {});
    case TaskType.matchingPictures:
      return MatchingPicturesTaskWidget(task: task, onComplete: () {});
    case TaskType.arrangeSentence:
      return ArrangeSentenceTaskWidget(task: task, onComplete: () {});
    case TaskType.fillInBlank:
      return FillInBlankTaskWidget(task: task, onComplete: () {});
    case TaskType.letterSelection:
      return LetterSelectionTaskWidget(task: task, onComplete: () {});
    case TaskType.matchingWords:
      return MatchingWordsTaskWidget(task: task, onComplete: () {});
  }
}

String _findProjectRoot() {
  var dir = Directory.current;
  while (true) {
    if (File('${dir.path}/pubspec.yaml').existsSync()) return dir.path;
    final parent = dir.parent;
    if (parent.path == dir.path) return Directory.current.path;
    dir = parent;
  }
}
