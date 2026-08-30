import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final projectRoot = _findProjectRoot();
  final lessonsDir = Directory('$projectRoot/assets/data/lessons');

  /**
   * SOURCE OF TRUTH FOR ANY VISUALS USED IN THE APP (emojis).
   * WE NEED TO MAKE SURE THESE ARE ACCURATE
   * THIS IS THE MASTER LIST OF EMOJIS THAT SHOULD BE USED.
   * IF THERE ARE ANY EMOJIS NOT IN THIS LIST THEY SHOULD NOT BE USED.
   * BECAUSE WE WANT TO MAINTAIN HIGH ACCURACY OF ALL IMAGERY.
   * AND ALSO ENSURE THEY ALIGN WITH SIKH TRADITION.
   * TESTS SHOULD FAIL IF THE LESSONS USE ANY OTHER EMOJIS APART FROM THESE.
   */

  final Map<String, String> referenceEmojiMap = {
    // Animals
    'ਬਿੱਲੀ': '🐱',
    'ਕੁੱਤਾ': '🦮',
    'ਮੱਛੀ': '🐟',
    'ਘੋੜਾ': '🐴',
    'ਹਾਥੀ': '🐘',
    'ਸ਼ੇਰ': '🦁',
    'ਬਾਂਦਰ': '🐒',
    'ਬੱਤਖ': '🦆',
    'ਭਾਲੂ': '🐻',
    'ਊਠ': '🐫',

    // Everyday Objects
    'ਕਿਤਾਬ': '📖',
    'ਸੂਰਜ': '☀️',
    'ਗੇਂਦ': '⚽',
    'ਤਾਰਾ': '⭐',
    'ਚੰਦ': '🌙',
    'ਕੁਰਸੀ': '🪑',
    'ਦਰਵਾਜ਼ਾ': '🚪',
    'ਖਿੜਕੀ': '🪟',
    'ਮੰਜਾ': '🛏️',
    'ਸੋਫ਼ਾ': '🛋️',

    // Fruits
    'ਸੇਬ': '🍎',
    'ਕੇਲਾ': '🍌',
    'ਅੰਬ': '🥭',
    'ਸੰਤਰਾ': '🍊',
    'ਅੰਗੂਰ': '🍇',
    'ਤਰਬੂਜ਼': '🍉',
    'ਅਨਾਨਾਸ': '🍍',
    'ਆੜੂ': '🍑',
    'ਨਾਸ਼ਪਾਤੀ': '🍐',
    'ਨਿੰਬੂ': '🍋',

    // Colors
    'ਲਾਲ': '🔴',
    'ਹਰਾ': '🟢',
    'ਨੀਲਾ': '🔵',
    'ਪੀਲਾ': '🟡',
    'ਕਾਲਾ': '⚫',
    'ਚਿੱਟਾ': '⚪',
    'ਸੰਤਰੀ': '🟠',
    'ਗੁਲਾਬੀ': '🩷',
    'ਭੂਰਾ': '🟤',
    'ਜਾਮਨੀ': '🟣',

    // Travel
    'ਕਾਰ': '🚗',
    'ਬੱਸ': '🚌',
    'ਰੇਲਗੱਡੀ': '🚆',
    'ਜਹਾਜ਼': '✈️',
    'ਸਾਈਕਲ': '🚲',
    'ਕਿਸ਼ਤੀ': '🚤',
    'ਟੈਕਸੀ': '🚕',
    'ਟਰੱਕ': '🚚',
    'ਮੋਟਰਸਾਈਕਲ': '🏍️',
    'ਹੈਲੀਕਾਪਟਰ': '🚁',

    // School
    'ਪੈਨਸਿਲ': '✏️',
    'ਕਲਮ': '🖊️',
    'ਬਸਤਾ': '🎒',
    'ਤਖਤੀ': '📝',
    'ਜਮਾਤ': '🏫',
    'ਸਕੂਲ': '🏫',
    'ਮੇਜ਼': '┳━┳',

    // Weather
    'ਮੀਂਹ': '🌧️',
    'ਬੱਦਲ': '☁️',
    'ਹਵਾ': '💨',
    'ਬਰਫ਼': '❄️',
    'ਧੁੰਦ': '🌫️',
    'ਧੁੱਪ': '☀️',
    'ਗਰਮੀ': '🥵',
    'ਸਰਦੀ': '🥶',
    'ਬਿਜਲੀ': '⚡',
    'ਤੂਫ਼ਾਨ': '🌪️',

    // Clothes
    'ਕਮੀਜ਼': '👕',
    'ਪੈਂਟ': '👖',
    'ਜੁੱਤੀ': '👟',
    'ਟੋਪੀ': '🧢',
    'ਜੁਰਾਬ': '🧦',
    'ਸਵੈਟਰ': '👚',
    'ਦਸਤਾਨੇ': '🧤',
    'ਕੋਟ': '🧥',
    'ਰੁਮਾਲ': '🥠',
    'ਪਜਾਮਾ': '👖',

    // Kitchen
    'ਚਮਚ': '🥄',
    'ਕਾਂਟਾ': '🍴',
    'ਛੁਰੀ': '🔪',
    'ਭਾਂਡਾ': '🍶',
    'ਗਲਾਸ': '🥛',
    'ਪਲੇਟ': '🍽️',
    'ਫਰਿੱਜ': '🧊',
    'ਕੜਾਹੀ': '🥣',
    'ਥਾਲੀ': '🔘',

    // Nature
    'ਰੁੱਖ': '🌳',
    'ਫੁੱਲ': '🌸',
    'ਪਹਾੜ': '⛰️',
    'ਦਰਿਆ': '🏞️',
    'ਸਮੁੰਦਰ': '🌊',
    'ਜੰਗਲ': '🌲',
    'ਪੱਤਾ': '🍃',
    'ਘਾਹ': '🌿',
    'ਅਸਮਾਨ': '🌌',
    'ਰੇਤ': '🏖️',

    // Birds
    'ਤੋਤਾ': '🦜',
    'ਕਾਂ': '🐦‍⬛',
    'ਕਬੂਤਰ': '🕊️',
    'ਮੋਰ': '🦚',
    'ਬਾਜ਼': '🦅',
    'ਉੱਲੂ': '🦉',
    'ਚਿੜੀ': '🐦',
    'ਮੁਰਗੀ': '🐔',
    'ਹੰਸ': '🦢',
    'ਚਮਗਿੱਦੜ': '🦇',

    // Shopping
    'ਪੈਸਾ': '💰',
    'ਦੁਕਾਨ': '🏪',
    'ਬਾਜ਼ਾਰ': '🏬',
    'ਕੀਮਤ': '🏷️',
    'ਥੈਲਾ': '👜',
    'ਗਾਹਕ': '🙋',
    'ਦੁਕਾਨਦਾਰ': '🧑‍💼',
    'ਨੋਟ': '💵',
    'ਸਿੱਕਾ': '🪙',
    'ਰਸੀਦ': '🧾',

    // Eating
    'ਖਾਣਾ': '🥗️',
    'ਰੋਟੀ': '🫓',
    'ਦਾਲ': '🍲',
    'ਚਾਵਲ': '🍚',
    'ਦੁੱਧ': '🥛',
    'ਪਾਣੀ': '💧',
    'ਚਾਹ': '☕',
    'ਸਬਜ਼ੀ': '🥦',
    'ਮਿੱਠਾ': '🍨',
    'ਨਾਸ਼ਤਾ': '🥣',

    //Directions
    'ਅੱਗੇ': '🔼',
    'ਪਿੱਛੇ': '🔽',
    'ਸੱਜੇ': '➡️',
    'ਖੱਬੇ': '⬅️',

    //Office
    'ਦਫ਼ਤਰ': '🏢',
    'ਕੰਪਿਊਟਰ': '💻',
    'ਫ਼ਾਈਲ': '📁',
    'ਪ੍ਰਿੰਟਰ': '🖨️',
    'ਫੋਨ': '📞',
    'ਘੜੀ': '⏰',
    'ਲਿਫ਼ਾਫ਼ਾ': '✉️',
    'ਡਾਇਰੀ': '📔',
    'ਅਲਮਾਰੀ': '🗄️',

    //Days of Week
    'ਸੋਮਵਾਰ': '🗓️',
    'ਮੰਗਲਵਾਰ': '🗓️',
    'ਬੁੱਧਵਾਰ': '🗓️',
    'ਵੀਰਵਾਰ': '🗓️',
    'ਸ਼ੁੱਕਰਵਾਰ': '🗓️',
    'ਸ਼ਨੀਵਾਰ': '🗓️',
    'ਐਤਵਾਰ': '🗓️',
  };

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
