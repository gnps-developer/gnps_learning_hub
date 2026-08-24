import 'dart:convert';
import 'dart:io';

/// A tool to generate Punjabi voiceover audio files using Google Translate TTS.
/// 
/// Usage: dart tools/generate_voiceover.dart [output_directory]
void main(List<String> args) async {
  final scriptFile = File('tools/voiceover_script.json');
  if (!scriptFile.existsSync()) {
    print('Error: tools/voiceover_script.json not found.');
    exit(1);
  }

  final outputDir = Directory(args.isNotEmpty ? args[0] : 'exports/voiceover');
  if (outputDir.existsSync()) {
    print('Cleaning output directory: ${outputDir.path}...');
    outputDir.deleteSync(recursive: true);
  }
  outputDir.createSync(recursive: true);

  final scriptData = jsonDecode(scriptFile.readAsStringSync());
  final segments = scriptData['segments'] as List;
  final lang = scriptData['language'] ?? 'pa';

  final client = HttpClient();
  
  try {
    for (final segment in segments) {
      final id = segment['id'];
      final text = segment['text'];
      final fileName = '$id.mp3';
      final outputFile = File('${outputDir.path}/$fileName');

      print('Generating $fileName...');
      
      final url = Uri.parse(
        'https://translate.google.com/translate_tts?ie=UTF-8&tl=$lang&client=tw-ob&q=${Uri.encodeComponent(text)}'
      );

      final request = await client.getUrl(url);
      // Need a browser-like User-Agent to avoid 403 from Google
      request.headers.add('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36');
      
      final response = await request.close();
      
      if (response.statusCode == 200) {
        final bytes = await response.expand((b) => b).toList();
        await outputFile.writeAsBytes(bytes);
        print('✅ Saved: ${outputFile.path}');
      } else {
        print('❌ Failed to generate $id: ${response.statusCode} ${response.reasonPhrase}');
      }
    }
    print('\nDone! All voiceover files generated in ${outputDir.path}');
  } catch (e) {
    print('Error occurred: $e');
  } finally {
    client.close();
  }
}
