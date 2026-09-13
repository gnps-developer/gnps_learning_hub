import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final projectRoot = _findProjectRoot();
  final lessonsDir = Directory('$projectRoot/assets/data/lessons');

  /**
   * SOURCE OF TRUTH FOR ANY VISUALS USED IN THE APP (emojis).
   * NOW LOADED FROM THE MASTER FLAT JSON ASSET FILE.
   */
  final referenceFile = File('$projectRoot/assets/data/emoji_reference.json');
  if (!referenceFile.existsSync()) {
    throw Exception('Missing emoji master reference file at ${referenceFile.path}');
  }
  
  final Map<String, dynamic> rawJson = jsonDecode(referenceFile.readAsStringSync());
  final Map<String, String> referenceEmojiMap = rawJson.map((key, value) => MapEntry(key, value as String));
  final Set<String> allowedEmojis = referenceEmojiMap.values.toSet();

  group('Emoji Accuracy Audit', () {
    if (lessonsDir.existsSync()) {
      final lessonFiles = lessonsDir.listSync().whereType<File>().where(
        (f) => f.path.endsWith('.json'),
      );

      for (final file in lessonFiles) {
        final content = file.readAsStringSync();
        final json = jsonDecode(content);
        final fileName = file.path.split('/').last;

        group('File: $fileName', () {
          final sections = json['sections'] as List;
          for (final section in sections) {
            final tasks = section['tasks'] as List;
            for (final taskData in tasks) {
              final taskId = taskData['id'] as String;
              final type = taskData['type'] as String;
              final taskContent = taskData['content'] as Map<String, dynamic>;

              if (type == 'matchingPictures') {
                final word = taskContent['word'] as String;
                final emoji = taskContent['correctEmoji'] as String;
                final distractorEmojis = List<String>.from(
                  taskContent['distractorEmojis'] as List,
                );

                test('Task $taskId: All emojis must be in reference list', () {
                  // 1. Verify correct emoji mapping
                  if (referenceEmojiMap.containsKey(word)) {
                    expect(
                      emoji,
                      equals(referenceEmojiMap[word]),
                      reason:
                          'Incorrect correctEmoji for "$word" in task $taskId',
                    );
                  } else {
                    fail(
                      'Word "$word" in task $taskId is not defined in referenceEmojiMap.',
                    );
                  }

                  // 2. Verify that the correct emoji itself is in the allowed set
                  expect(
                    allowedEmojis.contains(emoji),
                    isTrue,
                    reason:
                        'correctEmoji "$emoji" in task $taskId is not in the master list.',
                  );

                  // 3. Verify all distractors
                  for (final distractor in distractorEmojis) {
                    expect(
                      allowedEmojis.contains(distractor),
                      isTrue,
                      reason:
                          'Distractor emoji "$distractor" in task $taskId is not in the master reference list.',
                    );
                  }
                });
              } else if (type == 'spelling') {
                final word = taskContent['targetWord'] as String;
                final emoji = taskContent['emoji'] as String?;

                if (emoji != null) {
                  test('Task $taskId: Emoji must be in reference list', () {
                    if (referenceEmojiMap.containsKey(word)) {
                      expect(
                        emoji,
                        equals(referenceEmojiMap[word]),
                        reason: 'Incorrect emoji for "$word" in task $taskId',
                      );
                    } else {
                      fail(
                        'Word "$word" in task $taskId is not defined in referenceEmojiMap.',
                      );
                    }

                    expect(
                      allowedEmojis.contains(emoji),
                      isTrue,
                      reason:
                          'Emoji "$emoji" in task $taskId is not in the master reference list.',
                    );
                  });
                }
              }
            }
          }
        });
      }
    }
  });
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
