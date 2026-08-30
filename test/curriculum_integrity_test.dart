import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final projectRoot = _findProjectRoot();
  final lessonsDir = Directory('$projectRoot/assets/data/lessons');
  final gamesDir = Directory('$projectRoot/assets/data/games');

  /**
   * CURRICULUM DATA INTEGRITY AUDIT
   * THIS TEST ENSURES THE LOGICAL VALIDITY AND QUALITY OF ALL LESSON AND GAME DATA.
   * IT VERIFIES THAT:
   * 1. ALL SPELLING TASKS ARE SOLVABLE (TARGET WORD CAN BE BUILT FROM THE LETTER BANK).
   * 2. NO DUPLICATE ANSWERS EXIST (CORRECT ANSWER IS NOT PRESENT IN DISTRACTORS).
   * 3. DATA IS CLEAN (NO NULLS, NO EMPTY STRINGS, AND NO HIDDEN TRAILING WHITESPACE).
   * 4. LOGICAL CONSISTENCY (FILL-IN-BLANK OPTIONS CONTAIN THE ANSWER, SENTENCE LENGTHS MATCH).
   * 5. AUDIO COMPLETENESS (EVERY TASK MUST HAVE A VALID AUDIOFILE OR ITEMPOOL DEFINED).
   * THIS PREVENTS "BROKEN" CONTENT OR IMPOSSIBLE PUZZLES FROM REACHING THE USER.
   */

  group('Curriculum Data Integrity Audit', () {
    if (lessonsDir.existsSync()) {
      final lessonFiles = lessonsDir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'));

      for (final file in lessonFiles) {
        final json = jsonDecode(file.readAsStringSync());
        final lessonId = json['id'] as String;

        group('Lesson: $lessonId', () {
          final sections = json['sections'] as List;
          for (final section in sections) {
            final tasks = section['tasks'] as List;
            for (final taskData in tasks) {
              final taskId = taskData['id'] as String;
              final type = taskData['type'] as String;
              final content = taskData['content'] as Map<String, dynamic>;

              test('Task $taskId ($type) should have valid content structure', () {
                _validateTaskContent(taskId, type, content);
              });
            }
          }
        });
      }
    }

    if (gamesDir.existsSync()) {
      final gameFiles = gamesDir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'));

      for (final file in gameFiles) {
        final json = jsonDecode(file.readAsStringSync());
        final gameId = json['id'] as String;
        final type = json['type'] as String;
        final content = json['content'] as Map<String, dynamic>;

        test('Game $gameId ($type) should have valid content structure', () {
          expect(content.containsKey('itemPool'), isTrue,
              reason: 'Game $gameId must define an itemPool');
          final itemPool = content['itemPool'] as Map;
          expect(itemPool.isNotEmpty, isTrue,
              reason: 'Game $gameId itemPool cannot be empty');
        });
      }
    }
  });
}

void _validateTaskContent(String id, String type, Map<String, dynamic> content) {
  // Helper to check for normalization/whitespace issues
  void checkString(String? s, String label) {
    expect(s, isNotNull, reason: 'Task $id: $label is null');
    expect(s!.isNotEmpty, isTrue, reason: 'Task $id: $label is empty');
    expect(s.trim(), equals(s), reason: 'Task $id: $label "$s" has hidden whitespace');
  }

  // 1. Mandatory Audio Verification
  if (type == 'matchingWords') {
    expect(content.containsKey('itemPool'), isTrue,
        reason: 'Task $id: matchingWords must define an itemPool for audio.');
    final pool = content['itemPool'] as Map;
    expect(pool.isNotEmpty, isTrue, reason: 'Task $id: itemPool cannot be empty');
  } else {
    expect(content.containsKey('audioFile'), isTrue,
        reason: 'Task $id: $type must define an audioFile.');
    checkString(content['audioFile'] as String?, 'audioFile');
  }

  switch (type) {
    case 'trace':
      checkString(content['letter'], 'letter');
      checkString(content['transliteration'], 'transliteration');
      break;

    case 'spelling':
      final target = content['targetWord'] as String?;
      final bank = content['letterBank'] as List?;
      checkString(target, 'targetWord');
      expect(bank, isNotNull);

      String remaining = target!;
      List<String> sortedBank = bank!.map((e) => e.toString()).toList()
        ..sort((a, b) => b.length.compareTo(a.length));

      for (var tile in sortedBank) {
        remaining = remaining.replaceAll(tile, "");
      }
      expect(remaining.isEmpty, isTrue,
          reason:
              'Task $id: targetWord "$target" cannot be built from bank $bank. Missing parts: "$remaining"');
      break;

    case 'letterSelection':
      final correct = content['correctLetter'] as String?;
      final distractors = content['distractorLetters'] as List?;
      checkString(correct, 'correctLetter');
      expect(distractors!.contains(correct), isFalse,
          reason: 'Task $id: duplicate answer in distractors');
      break;

    case 'matchingPictures':
      final word = content['word'] as String?;
      final correct = content['correctEmoji'] as String?;
      final distractors = content['distractorEmojis'] as List?;
      checkString(word, 'word');
      checkString(correct, 'correctEmoji');
      expect(distractors!.contains(correct), isFalse,
          reason: 'Task $id: correct emoji in distractors');
      break;

    case 'matchingWords':
      final pairs = content['pairs'] as Map?;
      final englishWords = <String>{};
      for (var entry in pairs!.entries) {
        checkString(entry.key, 'Gurmukhi word');
        checkString(entry.value, 'English word');
        expect(englishWords.contains(entry.value), isFalse,
            reason: 'Task $id: Duplicate English answer "${entry.value}"');
        englishWords.add(entry.value);
      }
      break;

    case 'fillInBlank':
      final correct = content['correctWord'] as String?;
      final options = content['options'] as List?;
      checkString(correct, 'correctWord');
      expect(options!.contains(correct), isTrue,
          reason: 'Task $id: options missing the correct word');
      for (var opt in options) {
        checkString(opt, 'option');
      }
      break;

    case 'arrangeSentence':
      final words = content['words'] as List?;
      final order = content['correctOrder'] as List?;
      expect(words!.length, equals(order!.length));
      break;
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
