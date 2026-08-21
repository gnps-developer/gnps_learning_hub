import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final projectRoot = _findProjectRoot();
  final lessonsDir = Directory('$projectRoot/assets/data/lessons');
  final gamesDir = Directory('$projectRoot/assets/data/games');

  group('Audio Asset Validation', () {
    test('All lessons should have valid audio paths that exist on disk', () {
      if (!lessonsDir.existsSync()) {
        fail('Lessons directory not found at ${lessonsDir.path}');
      }

      final files = lessonsDir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'));

      for (final file in files) {
        final json = jsonDecode(file.readAsStringSync());
        _verifyAudioInJson(json, file.path, projectRoot);
      }
    });

    test('All games should have valid audio paths that exist on disk', () {
      if (!gamesDir.existsSync()) {
        fail('Games directory not found at ${gamesDir.path}');
      }

      final files = gamesDir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'));

      for (final file in files) {
        final json = jsonDecode(file.readAsStringSync());
        _verifyAudioInJson(json, file.path, projectRoot);
      }
    });
  });
}

void _verifyAudioInJson(dynamic data, String filePath, String projectRoot) {
  if (data is Map) {
    // 1. Check for 'audioFile' key
    if (data.containsKey('audioFile') && data['audioFile'] is String) {
      final assetPath = data['audioFile'] as String;
      final file = File('$projectRoot/assets/$assetPath');
      expect(
        file.existsSync(),
        isTrue,
        reason: 'Audio file "$assetPath" referenced in "$filePath" does not exist.',
      );
    }

    // 2. Check for 'itemPool' key (Maps Punjabi -> Path)
    if (data.containsKey('itemPool') && data['itemPool'] is Map) {
      final pool = data['itemPool'] as Map;
      for (final entry in pool.entries) {
        final assetPath = entry.value as String;
        final file = File('$projectRoot/assets/$assetPath');
        expect(
          file.existsSync(),
          isTrue,
          reason: 'Audio file "$assetPath" in itemPool of "$filePath" does not exist (Key: ${entry.key}).',
        );
      }
    }

    // Recurse
    for (final value in data.values) {
      _verifyAudioInJson(value, filePath, projectRoot);
    }
  } else if (data is List) {
    for (final item in data) {
      _verifyAudioInJson(item, filePath, projectRoot);
    }
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
