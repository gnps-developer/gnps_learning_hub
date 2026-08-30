import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final projectRoot = _findProjectRoot();
  final dataDir = Directory('$projectRoot/assets/data');
  final audioDir = Directory('$projectRoot/assets/audio');
  final soundsDir = Directory('$projectRoot/assets/sounds');

  /**
   * AUDIO ASSET SYNCHRONIZATION TEST
   * THIS TEST ENSURES THAT ALL AUDIO FILES REFERENCED IN LESSON DATA EXIST ON DISK.
   * IT ALSO ENSURES THERE ARE NO UNUSED AUDIO FILES LINGERING IN THE ASSETS FOLDER.
   * MAINTAINING A 1:1 MAPPING HELPS KEEP THE APP BUNDLE SIZE OPTIMIZED.
   * SYSTEM SOUNDS ARE ALSO VERIFIED FOR COMPLETENESS.
   */

  group('Audio Asset Synchronization', () {
    // 1. Collect all referenced audio from JSON files
    final referencedAudio = <String>{};
    final jsonFiles = dataDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.json'));

    for (final file in jsonFiles) {
      final content = file.readAsStringSync();
      try {
        final json = jsonDecode(content);
        _collectAudioPaths(json, referencedAudio);
      } catch (e) {
        // Skip non-json or malformed files
      }
    }

    // 2. Collect all files on disk
    final audioFilesOnDisk = <String>{};
    if (audioDir.existsSync()) {
      audioDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.mp3'))
          .forEach((f) {
        final relativePath = f.path.split('assets/').last;
        audioFilesOnDisk.add(relativePath);
      });
    }

    test('All referenced audio files must exist on disk', () {
      final missingFiles = referencedAudio.difference(audioFilesOnDisk);
      
      if (missingFiles.isNotEmpty) {
        fail('The following audio files are referenced in JSON but MISSING from assets/audio/:\n'
             '${missingFiles.join("\n")}');
      }
    });

    test('No extra audio files should exist in assets/audio/', () {
      final extraFiles = audioFilesOnDisk.difference(referencedAudio);
      
      if (extraFiles.isNotEmpty) {
        fail('The following audio files exist on disk but are NOT referenced in any JSON data file:\n'
             '${extraFiles.join("\n")}');
      }
    });

    test('System sounds synchronization', () {
      final systemSounds = [
        'sounds/success.mp3',
        'sounds/failure.mp3',
        'sounds/gem_earned.mp3',
        'sounds/lesson-completed.mp3',
        'sounds/game_won.mp3',
        'sounds/game_over.mp3',
      ];

      final missingSounds = <String>[];
      for (final sound in systemSounds) {
        final file = File('$projectRoot/assets/$sound');
        if (!file.existsSync()) {
          missingSounds.add(sound);
        }
      }

      final extraSounds = <String>[];
      if (soundsDir.existsSync()) {
        final filesOnDisk = soundsDir
            .listSync()
            .whereType<File>()
            .map((f) => f.path.split('assets/').last)
            .toSet();

        for (final file in filesOnDisk) {
          if (!systemSounds.contains(file)) {
            extraSounds.add(file);
          }
        }
      }

      if (missingSounds.isNotEmpty || extraSounds.isNotEmpty) {
        var message = 'System sound synchronization failed:\n';
        if (missingSounds.isNotEmpty) message += 'MISSING: ${missingSounds.join(", ")}\n';
        if (extraSounds.isNotEmpty) message += 'EXTRA (Unreferenced): ${extraSounds.join(", ")}';
        fail(message);
      }
    });
  });
}

void _collectAudioPaths(dynamic data, Set<String> paths) {
  if (data is Map) {
    for (final key in data.keys) {
      final value = data[key];
      if (key == 'audioFile' && value is String) {
        paths.add(value);
      } else if (key == 'itemPool' && value is Map) {
        for (final val in value.values) {
          if (val is String) paths.add(val);
        }
      } else {
        _collectAudioPaths(value, paths);
      }
    }
  } else if (data is List) {
    for (final item in data) {
      _collectAudioPaths(item, paths);
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
