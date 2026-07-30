// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

/// Generates a premium, detailed multi-page marketing PDF of the curriculum.
///
/// Requires Google Chrome or Chromium to be installed and on PATH.
void main() async {
  print('🚀 Starting Premium Multi-Page Brochure Generator...');
  await generateMarketingPdf();
}

/// Looks for a usable Chrome/Chromium executable across common locations.
Future<String?> _findChromeExecutable() async {
  final candidates = [
    'google-chrome-stable',
    'google-chrome',
    'chromium',
    'chromium-browser',
    'chrome',
    '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
    '/Applications/Chromium.app/Contents/MacOS/Chromium',
  ];

  for (final candidate in candidates) {
    try {
      if (candidate.startsWith('/')) {
        if (await File(candidate).exists()) return candidate;
        continue;
      }
      final result = await Process.run('which', [candidate]);
      if (result.exitCode == 0 && (result.stdout as String).trim().isNotEmpty) {
        return candidate;
      }
    } catch (_) {}
  }
  return null;
}

/// Reads a file from disk and returns it as a base64 data URI.
Future<String?> _loadAsDataUri(String? path) async {
  if (path == null) return null;
  final file = File(path);
  if (!await file.exists()) {
    print('⚠️  Image not found at $path — skipping.');
    return null;
  }
  try {
    final bytes = await file.readAsBytes();
    final base64Str = base64Encode(bytes);
    final extension = path.split('.').last.toLowerCase();
    final mimeType = extension == 'png' ? 'image/png' : 'image/jpeg';
    return 'data:$mimeType;base64,$base64Str';
  } catch (e) {
    print('⚠️  Failed to read $path ($e) — skipping.');
    return null;
  }
}

/// Runs headless Chrome to print [htmlPath] to [outputPath].
Future<ProcessResult> _printToPdf(
  String chrome,
  String outputPath,
  String htmlPath,
) async {
  final fileUri = Uri.file(htmlPath).toString();
  final baseArgs = [
    '--disable-gpu',
    '--no-sandbox',
    '--window-size=1240,1754',
    '--print-to-pdf=$outputPath',
    '--no-pdf-header-footer',
    '--virtual-time-budget=20000',
    '--run-all-compositor-stages-before-draw',
    fileUri,
  ];

  var result = await Process.run(chrome, ['--headless=new', ...baseArgs]);
  if (result.exitCode != 0 || !(await File(outputPath).exists())) {
    result = await Process.run(chrome, ['--headless', ...baseArgs]);
  }
  return result;
}

Future<void> generateMarketingPdf() async {
  // 0. Asset Mappings & Descriptions
  const lessonScreenshots = {
    'lesson_tracing': 'listing/google-play-store/phone/phone_letter.png',
    'lesson_letter_selection':
        'listing/google-play-store/phone/phone_letter.png',
    'lesson_spelling': 'listing/google-play-store/phone/phone_spelling.png',
    'lesson_matching_images':
        'listing/google-play-store/phone/phone_picture.png',
    'lesson_matching_words': 'listing/google-play-store/tablet/match_word.png',
    'lesson_fill_in_blank':
        'listing/google-play-store/phone/phone_fillinblanks.png',
    'lesson_arrange_sentence':
        'listing/google-play-store/phone/phone_journey.png',
  };

  const lessonMarketingCopy = {
    'lesson_tracing':
        'Master the elegant strokes of Gurmukhi. Our guided tracing system uses interactive checkpoints to ensure children learn the correct direction and form of every letter, building tactile memory and confidence.',
    'lesson_letter_selection':
        'Build a strong auditory foundation. Kids listen to authentic native pronunciations and identify the correct characters, reinforcing the vital link between the spoken sound and the written script.',
    'lesson_spelling':
        'Seamlessly transition from letters to complete words. Using a library of vibrant emojis and a tactile letter-bank, students learn to assemble common Punjabi vocabulary in a way that feels like play.',
    'lesson_matching_images':
        'Accelerate reading through visual association. Children match Punjabi words to their real-world objects, strengthening cognitive paths and building a robust vocabulary of everyday nouns.',
    'lesson_matching_words':
        'Cultivate dual-language fluency. This comprehensive module helps young learners bridge the gap between English and Punjabi, teaching them to translate and recognize terms they use every day.',
    'lesson_fill_in_blank':
        'Natural grammar in action. By completing missing pieces of common sentences, children learn how words function together, providing the perfect stepping stone toward confident conversation.',
    'lesson_arrange_sentence':
        'Master the flow of Punjabi syntax. A fun, puzzle-like challenge where students order words to form correct sentences, internalizing the natural rhythm and structure of the language.',
  };

  const gameScreenshots = {
    'bubble_pop_letters': 'listing/google-play-store/phone/bubble_letters.png',
    'bubble_pop_words': 'listing/google-play-store/phone/bubble_words.png',
  };

  // 1. Load data
  final manifestStr = File(
    'assets/data/journey_manifest.json',
  ).readAsStringSync();
  final manifest = jsonDecode(manifestStr) as Map<String, dynamic>;
  final version = manifest['version'] as int;
  final lessonFiles = (manifest['lessonFiles'] as List).cast<String>();
  final gameFiles = (manifest['gameFiles'] as List).cast<String>();

  final List games = [];
  for (final file in gameFiles) {
    games.add(jsonDecode(File('assets/data/games/$file').readAsStringSync()));
  }

  final List lessons = [];
  for (final file in lessonFiles) {
    lessons.add(
      jsonDecode(File('assets/data/lessons/$file').readAsStringSync()),
    );
  }

  final logoDataUri = await _loadAsDataUri('assets/logo/logo.jpg');
  final shopDataUri = await _loadAsDataUri(
    'listing/google-play-store/phone/shop.png',
  );

  final lessonImgData = <String, String>{};
  for (final entry in lessonScreenshots.entries) {
    final uri = await _loadAsDataUri(entry.value);
    if (uri != null) lessonImgData[entry.key] = uri;
  }

  final gameImgData = <String, String>{};
  for (final entry in gameScreenshots.entries) {
    final uri = await _loadAsDataUri(entry.value);
    if (uri != null) gameImgData[entry.key] = uri;
  }

  final buffer = StringBuffer();

  const style = '''
<style>
  @import url('https://fonts.googleapis.com/css2?family=Baloo+Paaji+2:wght@500;600;700;800&family=Work+Sans:wght@400;500;600;700&family=Noto+Sans+Gurmukhi:wght@400;500;600;700&display=swap');

  @page { size: A4; margin: 0; }
  * { box-sizing: border-box; }
  body {
    font-family: 'Work Sans', 'Noto Sans Gurmukhi', sans-serif;
    color: #1B2A4A;
    margin: 0;
    padding: 0;
    background: #FBF7EF;
    -webkit-print-color-adjust: exact;
  }
  h1, h2, h3, h4 { font-family: 'Baloo Paaji 2', 'Noto Sans Gurmukhi', sans-serif; line-height: 1.1; }
  
  img.emoji { height: 1.1em; width: 1.1em; margin: 0 0.05em 0 0.1em; vertical-align: -0.15em; }

  .page {
    width: 210mm;
    height: 297mm;
    position: relative;
    overflow: hidden;
    display: flex;
    flex-direction: column;
    page-break-after: always;
  }

  /* ---------- Page Layouts ---------- */
  .hero-page { background: linear-gradient(135deg, #1B2A4A 0%, #12203A 100%); color: #FBF7EF; justify-content: center; align-items: center; text-align: center; }
  .feature-page { padding: 30px 60px; display: flex; flex-direction: row; align-items: center; gap: 60px; }
  .feature-page.alt { flex-direction: row-reverse; }

  /* ---------- Components ---------- */
  .text-side { flex: 1; min-width: 0; }
  .image-side { flex: 0 0 450px; height: 100%; display: flex; align-items: center; justify-content: center; }

  .phone-mockup {
    width: 400px;
    height: 800px;
    background: #000;
    border-radius: 60px;
    padding: 12px;
    box-shadow: 0 30px 60px rgba(0,0,0,0.3);
    border: 4px solid #333;
    overflow: hidden;
    position: relative;
  }
  .phone-screen { width: 100%; height: 100%; background: #fff; border-radius: 48px; overflow: hidden; }
  .phone-screen img { width: 100%; height: 100%; object-fit: cover; }

  .badge {
    display: inline-block;
    background: #F2A93B;
    color: #1B2A4A;
    padding: 6px 16px;
    border-radius: 12px;
    font-weight: 800;
    font-size: 14px;
    text-transform: uppercase;
    margin-bottom: 20px;
  }
  
  .title-gurmukhi { font-size: 26px; color: #F2A93B; margin: 6px 0 16px 0; font-family: 'Noto Sans Gurmukhi', sans-serif; }
  .description { font-size: 17px; line-height: 1.55; color: #4A4439; margin-bottom: 22px; font-weight: 500; }
  
  .pill-container { display: flex; flex-direction: row; flex-wrap: wrap; gap: 10px; }
  .pill {
    background: white;
    border-left: 6px solid #F2A93B;
    padding: 10px 16px;
    border-radius: 12px;
    font-weight: 700;
    font-size: 14px;
    line-height: 1.3;
    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
    white-space: nowrap;
    font-family: 'Work Sans', 'Noto Sans Gurmukhi', sans-serif;
  }

  .footer {
    position: absolute;
    bottom: 30px;
    left: 60px;
    right: 60px;
    display: flex;
    justify-content: space-between;
    font-size: 12px;
    font-weight: 600;
    color: #A39A83;
    border-top: 1px solid rgba(0,0,0,0.05);
    padding-top: 15px;
  }
  
  .hero-footer { border-top-color: rgba(251, 247, 239, 0.1); color: rgba(251, 247, 239, 0.5); }

  /* ---------- Arcade & Shop ---------- */
  .dark-section { background: #1B2A4A; color: white; }
  .dark-section .description { color: rgba(251, 247, 239, 0.7); }
</style>
''';

  buffer.writeln(
    '<!DOCTYPE html><html><head><meta charset="UTF-8">$style</head><body>',
  );

  // ==================== COVER PAGE ====================
  buffer.writeln('<div class="page hero-page">');
  if (logoDataUri != null) {
    buffer.writeln(
      '<img src="$logoDataUri" alt="GNPS Logo" style="width: 180px; margin-bottom: 40px; border-radius: 30px; box-shadow: 0 20px 40px rgba(0,0,0,0.4);" />',
    );
  }
  buffer.writeln(
    '<h1 style="font-size: 64px; margin: 0;">GNPS Learning Hub</h1>',
  );
  buffer.writeln(
    '<p style="font-size: 32px; color: #F2A93B; margin: 20px 0 60px 0;">Interactive Punjabi For Kids</p>',
  );
  buffer.writeln(
    '<div style="background: rgba(251, 247, 239, 0.05); padding: 40px; border-radius: 30px; border: 1px solid rgba(251, 247, 239, 0.1);">',
  );
  buffer.writeln(
    '<p style="font-size: 20px; font-weight: 500; margin: 0;">A Premium Multi-Page Curriculum Guide</p>',
  );
  buffer.writeln(
    '<p style="font-size: 14px; opacity: 0.6; margin-top: 10px;">VERSION 2026 • CONTENT V$version</p>',
  );
  buffer.writeln('</div>');
  buffer.writeln(
    '<div class="footer hero-footer"><span>GNPS Learning Hub</span><span>Developed by GNPS</span></div>',
  );
  buffer.writeln('</div>');

  // ==================== LESSON PAGES ====================
  for (var i = 0; i < lessons.length; i++) {
    final lesson = lessons[i];
    final id = lesson['id'];
    final imgUri = lessonImgData[id];
    final copy = lessonMarketingCopy[id] ?? '';
    final isAlt = i % 2 != 0;

    buffer.writeln('<div class="page feature-page${isAlt ? ' alt' : ''}">');

    // Text Side
    buffer.writeln('<div class="text-side">');
    buffer.writeln('<span class="badge">Module ${i + 1}</span>');
    buffer.writeln(
      '<h2 style="font-size: 38px; margin: 0;">${lesson['title']}</h2>',
    );
    buffer.writeln('<p class="title-gurmukhi">ਪੰਜਾਬੀ ਸਿੱਖੋ</p>');
    buffer.writeln('<p class="description">$copy</p>');
    buffer.writeln('<div class="pill-container">');
    for (final section in lesson['sections']) {
      buffer.writeln('<div class="pill">${section['title']}</div>');
    }
    buffer.writeln('</div>');
    buffer.writeln('</div>');

    // Image Side
    if (imgUri != null) {
      buffer.writeln('<div class="image-side">');
      buffer.writeln('<div class="phone-mockup">');
      buffer.writeln(
        '<div class="phone-screen"><img src="$imgUri" alt="${lesson['title']} Preview" /></div>',
      );
      buffer.writeln('</div>');
      buffer.writeln('</div>');
    }

    buffer.writeln(
      '<div class="footer"><span>MODULE OVERVIEW</span><span>PAGE ${i + 2}</span></div>',
    );
    buffer.writeln('</div>');
  }

  // ==================== ARCADE PAGES ====================
  for (var i = 0; i < games.length; i++) {
    final game = games[i];
    final id = game['id'];
    final imgUri = gameImgData[id];
    final isAlt = (lessons.length + i) % 2 != 0;

    buffer.writeln(
      '<div class="page feature-page dark-section${isAlt ? ' alt' : ''}">',
    );

    buffer.writeln('<div class="text-side">');
    buffer.writeln(
      '<span class="badge" style="background: #E23E82; color: white;">Arcade Mode</span>',
    );
    buffer.writeln(
      '<h2 style="font-size: 38px; margin: 0;">${game['title']}</h2>',
    );
    buffer.writeln(
      '<p class="title-gurmukhi" style="color: #E23E82;">Fast-Paced Learning</p>',
    );
    buffer.writeln(
      '<p class="description">High-energy vocabulary reinforcement. This ${game['type'].replaceAll("_", " ")} challenge is unlocked after the ${game['unlockAfterLessonId'].replaceAll("lesson_", "").replaceAll("_", " ")} module.</p>',
    );
    buffer.writeln('<div class="pill-container">');
    buffer.writeln(
      '<div class="pill" style="border-left-color: #E23E82;">Adaptive Difficulty</div>',
    );
    buffer.writeln(
      '<div class="pill" style="border-left-color: #E23E82;">Visual & Auditory Cues</div>',
    );
    buffer.writeln(
      '<div class="pill" style="border-left-color: #E23E82;">High Score Tracking</div>',
    );
    buffer.writeln('</div>');
    buffer.writeln('</div>');

    if (imgUri != null) {
      buffer.writeln('<div class="image-side">');
      buffer.writeln(
        '<div class="phone-mockup" style="border-color: #E23E82;">',
      );
      buffer.writeln(
        '<div class="phone-screen"><img src="$imgUri" alt="${game['title']} Preview" /></div>',
      );
      buffer.writeln('</div>');
      buffer.writeln('</div>');
    }

    buffer.writeln(
      '<div class="footer hero-footer"><span>ARCADE SPOTLIGHT</span><span>PAGE ${lessons.length + i + 2}</span></div>',
    );
    buffer.writeln('</div>');
  }

  // ==================== SHOP & CUSTOMIZATION ====================
  if (shopDataUri != null) {
    final pageNum = lessons.length + games.length + 2;
    buffer.writeln(
      '<div class="page feature-page${(pageNum % 2 != 0) ? ' alt' : ''}">',
    );
    buffer.writeln('<div class="text-side">');
    buffer.writeln(
      '<span class="badge" style="background: #4C9A6B; color: white;">Rewards</span>',
    );
    buffer.writeln(
      '<h2 style="font-size: 38px; margin: 0;">Your Avatar, Your Style</h2>',
    );
    buffer.writeln(
      '<p class="title-gurmukhi" style="color: #4C9A6B;">Shop & Personalize</p>',
    );
    buffer.writeln(
      '<p class="description">Earn gems through focused study and spend them in the shop! Customize your hero with turbans, outfits, and accessories while protecting your progress with streak freezes.</p>',
    );
    buffer.writeln('<div class="pill-container">');
    buffer.writeln(
      '<div class="pill" style="border-left-color: #4C9A6B;">Interactive Gem Economy</div>',
    );
    buffer.writeln(
      '<div class="pill" style="border-left-color: #4C9A6B;">Dozens of Custom Items</div>',
    );
    buffer.writeln(
      '<div class="pill" style="border-left-color: #4C9A6B;">Gamified Streak System</div>',
    );
    buffer.writeln('</div>');
    buffer.writeln('</div>');
    buffer.writeln('<div class="image-side">');
    buffer.writeln('<div class="phone-mockup" style="border-color: #4C9A6B;">');
    buffer.writeln(
      '<div class="phone-screen"><img src="$shopDataUri" alt="Shop and Customization Preview" /></div>',
    );
    buffer.writeln('</div>');
    buffer.writeln('</div>');
    buffer.writeln(
      '<div class="footer"><span>CUSTOMIZATION</span><span>PAGE $pageNum</span></div>',
    );
    buffer.writeln('</div>');
  }

  buffer.writeln(
    '<script src="https://cdn.jsdelivr.net/npm/twemoji@14.0.2/dist/twemoji.min.js"></script>',
  );
  buffer.writeln(
    '<script>twemoji.parse(document.body, { folder: "svg", ext: ".svg" });</script>',
  );
  buffer.writeln('</body></html>');

  final htmlFile = File('curriculum_modern_v3_temp.html');
  await htmlFile.writeAsString(buffer.toString());

  final chrome = await _findChromeExecutable();
  if (chrome == null) {
    print('❌ No Chrome executable found.');
    return;
  }

  final outputFile = File('exports/GNPS_Brochure_Premium.pdf').absolute;
  await outputFile.parent.create(recursive: true);
  final result = await _printToPdf(
    chrome,
    outputFile.path,
    htmlFile.absolute.path,
  );

  if (result.exitCode == 0 && await outputFile.exists()) {
    print('✅ Premium Multi-Page Brochure generated: ${outputFile.path}');
  } else {
    print('❌ PDF generation failed.');
  }

  if (await htmlFile.exists()) await htmlFile.delete();
}
