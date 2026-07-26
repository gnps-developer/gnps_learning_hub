// ignore_for_file: avoid_print
import 'dart:io';
import 'package:gnps_learning_hub/data/journey_data.dart';
import 'package:gnps_learning_hub/config/content_ids.dart';

const Map<String, String> lessonDescriptions = {
  ContentIds.tracing: '*Master the strokes of the Gurmukhi script.*',
  ContentIds.letterSelection:
      '*Practice auditory recognition and matching of Punjabi letters.*',
  // Add new lesson descriptions here as they're introduced.
};

void main() {
  final buffer = StringBuffer();
  buffer.writeln('# GNPS Learning Hub - Curriculum Overview');
  buffer.writeln();
  buffer.writeln(
    'This document is automatically generated from the app\'s lesson data.',
  );
  buffer.writeln();

  int appTotalTasks = 0;
  for (final lesson in journeyData.lessons) {
    appTotalTasks += lesson.allTasks.length;
  }

  buffer.writeln('### 📊 App Statistics');
  buffer.writeln('- **Total Lessons**: ${journeyData.lessons.length}');
  buffer.writeln('- **Total Interactive Tasks**: $appTotalTasks');
  buffer.writeln('- **Total Games**: ${journeyData.games.length}');
  buffer.writeln();
  buffer.writeln('---');
  buffer.writeln();
  buffer.writeln('## 📚 Lessons');
  buffer.writeln();

  for (var i = 0; i < journeyData.lessons.length; i++) {
    final lesson = journeyData.lessons[i];
    final lessonTasks = lesson.allTasks.length;

    buffer.writeln('### ${i + 1}. ${lesson.title} ($lessonTasks tasks)');

    final description = lessonDescriptions[lesson.id];
    if (description != null) {
      buffer.writeln(description);
    }

    for (final section in lesson.sections) {
      buffer.writeln('- **${section.title}** (${section.tasks.length} tasks)');
    }
    buffer.writeln();
  }

  buffer.writeln('---');
  buffer.writeln();
  buffer.writeln('## 🕹️ Arcade Games');
  buffer.writeln();

  for (final game in journeyData.games) {
    buffer.writeln(
      '- **${game.title}**: ${game.type.replaceAll('_', ' ')} game unlocked after `${game.unlockAfterLessonId}`.',
    );
  }
  buffer.writeln();

  buffer.writeln('---');
  buffer.writeln();
  buffer.writeln('### 🛠️ Maintenance');
  buffer.writeln('To refresh this document after modifying lesson data, run:');
  buffer.writeln('```bash');
  buffer.writeln('dart run tool/generate_curriculum.dart');
  buffer.writeln('```');
  buffer.writeln();
  buffer.writeln('---');
  buffer.writeln('*Last Updated: ${DateTime.now().toString().split(' ')[0]}*');

  final file = File('CURRICULUM.md');
  file.writeAsStringSync(buffer.toString());

  print('✅ CURRICULUM.md has been refreshed!');
}
