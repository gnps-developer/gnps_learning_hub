// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

void main() {
  final file = File('assets/data/games/crossword_punjabi.json');
  if (!file.existsSync()) {
    print('❌ File not found');
    return;
  }

  final json = jsonDecode(file.readAsStringSync());
  final levels = json['content']['levels'] as List;
  final itemPool = json['content']['itemPool'] as Map;

  final allUsedWords = <String>{};
  for (final level in levels) {
    final words = level['words'] as List;
    for (final word in words) {
      allUsedWords.add(word['answer']);
    }
  }

  final missingInPool = <String>[];
  for (final word in allUsedWords) {
    if (!itemPool.containsKey(word)) {
      missingInPool.add(word);
    }
  }

  if (missingInPool.isEmpty) {
    print('✅ All ${allUsedWords.length} used words are present in the itemPool.');
  } else {
    print('❌ Missing ${missingInPool.length} words in itemPool:');
    for (final word in missingInPool) {
      print('  - $word');
    }
  }
}
