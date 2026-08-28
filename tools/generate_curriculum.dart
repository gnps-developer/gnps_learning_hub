// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

/// Automatically generates CURRICULUM.md from the app's lesson data.
///
/// To run this tool, use:
/// ```bash
/// dart tools/generate_curriculum.dart
/// ```
const Map<String, String> lessonDescriptions = {
  'lesson_tracing': '*Master the strokes of the Gurmukhi script.*',
  'lesson_letter_selection':
      '*Practice auditory recognition and matching of Punjabi letters.*',
  // Add new lesson descriptions here as they're introduced.
};

void main([List<String> args = const []]) {
  // 1. Load manifest
  final manifestStr =
      File('assets/data/journey_manifest.json').readAsStringSync();
  final manifest = jsonDecode(manifestStr) as Map<String, dynamic>;
  final version = manifest['version'] as int;
  final lessonFiles = (manifest['lessonFiles'] as List).cast<String>();
  final gameFiles = (manifest['gameFiles'] as List).cast<String>();

  // 2. Load games
  final gamesJson = <Map<String, dynamic>>[];
  for (final file in gameFiles) {
    final gameStr = File('assets/data/games/$file').readAsStringSync();
    gamesJson.add(jsonDecode(gameStr) as Map<String, dynamic>);
  }

  // 3. Load lessons
  final lessonsJson = <Map<String, dynamic>>[];
  for (final file in lessonFiles) {
    final lessonStr = File('assets/data/lessons/$file').readAsStringSync();
    lessonsJson.add(jsonDecode(lessonStr) as Map<String, dynamic>);
  }

  final Map<String, dynamic> journeyData = {
    'version': version,
    'lessons': lessonsJson,
    'games': gamesJson,
  };

  final buffer = StringBuffer();
  buffer.writeln('# GNPS Learning Hub - Curriculum Overview');
  buffer.writeln();
  buffer.writeln(
    'This document is automatically generated from the app\'s lesson data.',
  );
  buffer.writeln();

  final lessons = journeyData['lessons'] as List;
  final games = journeyData['games'] as List;

  int appTotalTasks = 0;
  for (final lesson in lessons) {
    for (final section in lesson['sections']) {
      appTotalTasks += (section['tasks'] as List).length;
    }
  }

  buffer.writeln('### 📊 App Statistics');
  buffer.writeln('- **Total Lessons**: ${lessons.length}');
  buffer.writeln('- **Total Interactive Tasks**: $appTotalTasks');
  buffer.writeln('- **Total Games**: ${games.length}');
  buffer.writeln();
  buffer.writeln('---');
  buffer.writeln();
  buffer.writeln('## 📚 Lessons');
  buffer.writeln();

  for (var i = 0; i < lessons.length; i++) {
    final lesson = lessons[i];
    int lessonTasks = 0;
    for (final section in lesson['sections']) {
      lessonTasks += (section['tasks'] as List).length;
    }

    buffer.writeln('### ${i + 1}. ${lesson['title']} ($lessonTasks tasks)');

    final description = lessonDescriptions[lesson['id']];
    if (description != null) {
      buffer.writeln(description);
    }

    for (final section in lesson['sections']) {
      buffer.writeln('- **${section['title']}** (${(section['tasks'] as List).length} tasks)');
    }
    buffer.writeln();
  }

  buffer.writeln('---');
  buffer.writeln();
  buffer.writeln('## 🕹️ Arcade Games');
  buffer.writeln();

  for (final game in games) {
    buffer.writeln(
      '- **${game['title']}**: ${game['type'].replaceAll('_', ' ')} game unlocked after `${game['unlockAfterLessonId']}`.',
    );
  }
  buffer.writeln();
  buffer.writeln('---');
  buffer.writeln('*Last Updated: ${DateTime.now().toString().split(' ')[0]}*');

  final file = File('guides/CURRICULUM.md');
  file.writeAsStringSync(buffer.toString());

  print('✅ guides/CURRICULUM.md has been refreshed!');
}
