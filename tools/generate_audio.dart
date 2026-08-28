// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

/// Automatically generates MP3 audio files based on explicit full paths 
/// defined in both lesson and game JSON data.
///
/// Usage:
/// ```bash
/// dart tools/generate_audio.dart [id_1] [id_2] ...
/// ```
void main(List<String> args) async {
  final projectRoot = _findProjectRoot();
  final assetsRoot = Directory('$projectRoot/assets');
  final audioLessonsRoot = Directory('$projectRoot/assets/audio/lessons');

  // 0. Ensure directory exists (DO NOT DELETE EXISTING FILES)
  if (!audioLessonsRoot.existsSync()) {
    print('📁 Creating audio directory...');
    audioLessonsRoot.createSync(recursive: true);
  }

  final lessonsDir = Directory('$projectRoot/assets/data/lessons');
  final gamesDir = Directory('$projectRoot/assets/data/games');
  
  // Maps Full Asset Path -> Punjabi Text to synthesize
  final downloadQueue = <String, String>{};

  final List<String> targetIds = args.where((a) => !a.startsWith('-')).toList();
  final bool isFiltering = targetIds.isNotEmpty;

  if (isFiltering) {
    print('🔍 Scanning specific items: ${targetIds.join(', ')}');
  } else {
    print('🔍 Scanning all content for explicit audio definitions...');
  }

  // 1. Scan Lessons
  if (lessonsDir.existsSync()) {
    for (final file in lessonsDir.listSync().whereType<File>().where((f) => f.path.endsWith('.json'))) {
      try {
        final json = jsonDecode(file.readAsStringSync());
        if (isFiltering && !targetIds.contains(json['id'])) continue;
        _extractExplicitAudio(json, downloadQueue);
      } catch (e) {
        print('⚠️  Error parsing ${file.path}: $e');
      }
    }
  }

  // 2. Scan Games
  if (gamesDir.existsSync()) {
    for (final file in gamesDir.listSync().whereType<File>().where((f) => f.path.endsWith('.json'))) {
      try {
        final json = jsonDecode(file.readAsStringSync());
        if (isFiltering && !targetIds.contains(json['id'])) continue;
        _extractExplicitAudio(json, downloadQueue);
      } catch (e) {
        print('⚠️  Error parsing ${file.path}: $e');
      }
    }
  }

  if (downloadQueue.isEmpty) {
    print('⚠️  No explicit audio definitions found.');
    return;
  }

  print('🎯 Found ${downloadQueue.length} unique audio items to generate.');

  final client = HttpClient();
  int downloaded = 0;

  for (final entry in downloadQueue.entries) {
    final assetPath = entry.key; // e.g. "audio/lessons/alphabets/ura.mp3"
    final punjabiText = entry.value;

    final file = File('${assetsRoot.path}/$assetPath');
    if (file.existsSync()) {
      print('⏭️  Skipping existing: $assetPath');
      continue;
    }

    if (!file.parent.existsSync()) {
      file.parent.createSync(recursive: true);
    }

    print('📥 Downloading: "$punjabiText" -> $assetPath');

    try {
      final uri = Uri.parse(
        'https://translate.google.com/translate_tts?ie=UTF-8&q=${Uri.encodeComponent(punjabiText)}&tl=pa&client=tw-ob',
      );

      final request = await client.getUrl(uri);
      request.headers.add('User-Agent', 'Mozilla/5.0');
      final response = await request.close();

      if (response.statusCode == 200) {
        final bytes = await response.fold<List<int>>([], (p, e) => p..addAll(e));
        file.writeAsBytesBytesSync(bytes);
        downloaded++;
        // Throttling to respect the service
        await Future.delayed(const Duration(milliseconds: 700));
      } else {
        print('❌ Failed: HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error: $e');
    }
  }

  client.close();
  print('\n✅ Done!');
  print('✨ Downloaded: $downloaded');
  print('📁 Audio saved to: assets/audio/lessons/');
}

extension FileExt on File {
  void writeAsBytesBytesSync(List<int> bytes) => writeAsBytesSync(bytes);
}

void _extractExplicitAudio(dynamic data, Map<String, String> queue) {
  if (data is Map) {
    final content = data['content'];
    if (content is Map) {
      // 1. Single audio file definition
      if (content.containsKey('audioFile')) {
        final path = content['audioFile'] as String;
        final text = content['letter'] ?? content['targetWord'] ?? content['correctLetter'] ?? content['word'] ?? content['fullSentence'];
        if (text is String) {
          queue[path] = text;
        }
      }
      
      // 2. Mapping definitions (Matching Words & Games)
      if (content.containsKey('itemPool')) {
        final mapping = content['itemPool'] as Map;
        for (final entry in mapping.entries) {
          if (entry.key is String && entry.value is String) {
            queue[entry.value as String] = entry.key as String;
          }
        }
      }
    }

    for (final value in data.values) {
      _extractExplicitAudio(value, queue);
    }
  } else if (data is List) {
    for (final item in data) {
      _extractExplicitAudio(item, queue);
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
