// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

/// Generates a premium, detailed multi-page marketing PDF of the curriculum.
///
/// All copy, labels, and colors live in `brochure_content.json`.
/// All styling lives in `style.css`.
/// Requires Google Chrome or Chromium to be installed and on PATH.
void main() async {
  print('🚀 Starting Brochure Generator...');
  await generateMarketingPdf();
}

// Resolve the project root by walking up from the current working directory
// until we find pubspec.yaml. This is more reliable than Platform.script,
// which points at a temporary kernel snapshot (not this file) when run via
// `flutter test` / `dart test`.
String _findProjectRoot() {
  var dir = Directory.current;
  while (true) {
    if (File('${dir.path}/pubspec.yaml').existsSync()) return dir.path;
    final parent = dir.parent;
    if (parent.path == dir.path) {
      // Reached filesystem root without finding pubspec.yaml — fall back
      // to the current directory rather than looping forever.
      return Directory.current.path;
    }
    dir = parent;
  }
}

final _projectRoot = _findProjectRoot();

// This script itself lives in tools/, alongside style.css.
String get _contentConfigPath =>
    '$_projectRoot/assets/data/brochure_content.json';

String get _stylesheetPath => '$_projectRoot/tools/style.css';

String get _manifestPath => '$_projectRoot/assets/data/journey_manifest.json';

String get _lessonsDir => '$_projectRoot/assets/data/lessons';

String get _gamesDir => '$_projectRoot/assets/data/games';

String get _outputPath => '$_projectRoot/exports/GNPS_Brochure_Premium.pdf';

// --------------------------------------------------------------------------
// Chrome / file helpers
// --------------------------------------------------------------------------

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

// --------------------------------------------------------------------------
// HTML page templates
// --------------------------------------------------------------------------

String _rootColorOverride(Map<String, dynamic> colors) {
  final vars = colors.entries
      .map((e) => '--color-${_kebab(e.key)}: ${e.value};')
      .join(' ');
  return '<style>:root { $vars }</style>';
}

String _kebab(String camel) => camel.replaceAllMapped(
  RegExp(r'[A-Z]'),
  (m) => '-${m.group(0)!.toLowerCase()}',
);

String _heroPage(Map<String, dynamic> brand, String? logoUri, int version) {
  final logo = logoUri != null
      ? '<img src="$logoUri" alt="${brand['appName']} Logo" '
            'style="width: 180px; margin-bottom: 40px; border-radius: 30px; '
            'box-shadow: 0 20px 40px rgba(0,0,0,0.4);" />'
      : '';
  return '''
<div class="page hero-page">
  $logo
  <span class="eyebrow">${brand['eyebrow']}</span>
  <h1 style="font-size: 64px; margin: 0;">${brand['appName']}</h1>
  <p class="gurmukhi-tag">${brand['heroGurmukhiTagline']}</p>
  <p class="sub-tag">${brand['heroSubtitle']}</p>
  <div style="background: rgba(251, 247, 239, 0.05); padding: 40px; border-radius: 30px; border: 1px solid rgba(251, 247, 239, 0.1); margin-top: 40px;">
    <p style="font-size: 20px; font-weight: 500; margin: 0;">${brand['coverSubtitle']}</p>
    <p style="font-size: 14px; opacity: 0.6; margin-top: 10px;">${brand['coverVersionLabel']} • CONTENT V$version</p>
  </div>
  <div class="footer hero-footer"><span>${brand['appName']}</span><span>Developed by ${brand['developer']}</span></div>
</div>''';
}

String _closingPage(
  Map<String, dynamic> brand,
  Map<String, dynamic> finalNotesSection,
) {
  return '''
<div class="page closing-page">
  <h1 style="font-size: 52px; margin: 0 0 24px 0;">${finalNotesSection['title']}</h1>
  <p style="font-size: 19px; line-height: 1.6; max-width: 640px; color: rgba(251, 247, 239, 0.8);">${finalNotesSection['message']}</p>
  <div class="footer hero-footer"><span>${finalNotesSection['footerLabel']}</span><span>${brand['appName']}</span></div>
</div>''';
}

String _pillList(List<String> labels, {String variant = ''}) {
  final cls = variant.isEmpty ? 'pill' : 'pill $variant';
  return labels.map((l) => '<div class="$cls">$l</div>').join();
}

/// A generic left/right feature page: badge, title, gurmukhi subtitle,
/// description, pills, optional phone mockup image, and footer.
/// `pageNum` drives both the footer's "PAGE N" text and left/right
/// alternation, so callers never compute those by hand.
String _featurePage({
  required String badgeLabel,
  required String title,
  required String gurmukhiLabel,
  required String description,
  required String pillsHtml,
  required String footerLeft,
  required int pageNum,
  String? imageUri,
  String variant = '', // '', 'arcade', 'shop', or 'achievements'
  bool dark = false,
}) {
  final alt = pageNum % 2 != 0;
  final pageClasses = [
    'page',
    'feature-page',
    if (dark) 'dark-section',
    if (alt) 'alt',
  ].join(' ');
  final withVariant = (String base) =>
      variant.isEmpty ? base : '$base $variant';
  final footerClass = dark ? 'footer hero-footer' : 'footer';

  final imageBlock = imageUri == null
      ? ''
      : '''
  <div class="image-side">
    <div class="${withVariant('phone-mockup')}">
      <div class="phone-screen"><img src="$imageUri" alt="$title Preview" /></div>
    </div>
  </div>''';

  return '''
<div class="$pageClasses">
  <div class="text-side">
    <span class="${withVariant('badge')}">$badgeLabel</span>
    <h2 style="font-size: 38px; margin: 0;">$title</h2>
    <p class="${withVariant('title-gurmukhi')}">$gurmukhiLabel</p>
    <p class="description">$description</p>
    <div class="pill-container">$pillsHtml</div>
  </div>
  $imageBlock
  <div class="$footerClass"><span>$footerLeft</span><span>PAGE $pageNum</span></div>
</div>''';
}

// --------------------------------------------------------------------------
// Main generation flow
// --------------------------------------------------------------------------

Future<void> generateMarketingPdf() async {
  // 1. Load content config, curriculum data, and stylesheet.
  final config =
      jsonDecode(File(_contentConfigPath).readAsStringSync())
          as Map<String, dynamic>;
  final brand = config['brand'] as Map<String, dynamic>;
  final colors = config['colors'] as Map<String, dynamic>;
  final sections = config['sections'] as Map<String, dynamic>;
  final lessonContent = config['lessons'] as Map<String, dynamic>;
  final gameContent = config['games'] as Map<String, dynamic>;

  final css = File(_stylesheetPath).readAsStringSync();

  final manifest =
      jsonDecode(File(_manifestPath).readAsStringSync())
          as Map<String, dynamic>;
  final version = manifest['version'] as int;
  final lessonFiles = (manifest['lessonFiles'] as List).cast<String>();
  final gameFiles = (manifest['gameFiles'] as List).cast<String>();

  final lessons = [
    for (final file in lessonFiles)
      jsonDecode(File('$_lessonsDir/$file').readAsStringSync()),
  ];
  final games = [
    for (final file in gameFiles)
      jsonDecode(File('$_gamesDir/$file').readAsStringSync()),
  ];

  // 2. Preload images as data URIs (paths in the JSON are relative to the
  // project root, same as assets/data/... above). Missing images log a
  // warning and simply render the page without a screenshot — no section
  // is ever dropped because of a missing image.
  Future<String?> loadImage(String? relativePath) => _loadAsDataUri(
    relativePath == null ? null : '$_projectRoot/$relativePath',
  );

  final logoUri = await loadImage(brand['logoPath'] as String?);
  final shopSection = sections['shop'] as Map<String, dynamic>;
  final shopUri = await loadImage(shopSection['screenshot'] as String?);
  final achievementsSection = sections['achievements'] as Map<String, dynamic>;
  final achievementsUri = await loadImage(
    achievementsSection['screenshot'] as String?,
  );

  final lessonImages = <String, String>{};
  for (final entry in lessonContent.entries) {
    final uri = await loadImage(entry.value['screenshot'] as String?);
    if (uri != null) lessonImages[entry.key] = uri;
  }

  final gameImages = <String, String>{};
  for (final entry in gameContent.entries) {
    final uri = await loadImage(entry.value['screenshot'] as String?);
    if (uri != null) gameImages[entry.key] = uri;
  }

  // 3. Build the page sequence:
  //    Hero -> Journey -> Lessons -> Shop -> Arcade -> Achievements -> Final Notes
  // Every section below always renders, even if its screenshot is missing —
  // a missing image only skips the image, never the whole page.
  final pages = <String>[_heroPage(brand, logoUri, version)];
  var pageNum = 2; // page 1 is the hero/cover

  void addPage(String html) {
    pages.add(html);
    pageNum++;
  }

  String pillLabelsFor(Map<String, dynamic> lesson) => _pillList([
    for (final s in (lesson['sections'] as List)) s['title'] as String,
  ]);

  // -- Journey (a standalone spotlight page; content comes entirely from
  //    journeySection in the config, independent of the lessons list) --
  final journeySection = sections['journey'] as Map<String, dynamic>;
  final journeyUri = await loadImage(journeySection['screenshot'] as String?);

  addPage(
    _featurePage(
      badgeLabel: journeySection['badgeLabel'] as String,
      title: journeySection['title'] as String,
      gurmukhiLabel: journeySection['gurmukhiLabel'] as String,
      description: journeySection['description'] as String,
      pillsHtml: _pillList((journeySection['pills'] as List).cast<String>()),
      imageUri: journeyUri,
      footerLeft: journeySection['footerLabel'] as String,
      pageNum: pageNum,
    ),
  );

  // -- Lessons (all lessons; lesson_arrange_sentence is sorted to the end
  //    since it works well as the capstone lesson right before Shop) --
  final remainingLessons = lessons.cast<Map<String, dynamic>>()
    ..sort((a, b) {
      if (a['id'] == 'lesson_arrange_sentence') return 1;
      if (b['id'] == 'lesson_arrange_sentence') return -1;
      return 0;
    });

  final lessonSection = sections['lessonModule'] as Map<String, dynamic>;
  for (var i = 0; i < remainingLessons.length; i++) {
    final lesson = remainingLessons[i];
    final data = lessonContent[lesson['id']] as Map<String, dynamic>?;
    addPage(
      _featurePage(
        badgeLabel: '${lessonSection['badgeLabel']} ${i + 1}',
        title: lesson['title'] as String,
        gurmukhiLabel: brand['gurmukhiTagline'] as String,
        description: data?['copy'] as String? ?? '',
        pillsHtml: pillLabelsFor(lesson),
        imageUri: lessonImages[lesson['id']],
        footerLeft: lessonSection['footerLabel'] as String,
        pageNum: pageNum,
      ),
    );
  }

  // -- Shop --
  addPage(
    _featurePage(
      badgeLabel: shopSection['badgeLabel'] as String,
      title: shopSection['title'] as String,
      gurmukhiLabel: shopSection['gurmukhiLabel'] as String,
      description: shopSection['description'] as String,
      pillsHtml: _pillList(
        (shopSection['pills'] as List).cast<String>(),
        variant: 'shop',
      ),
      imageUri: shopUri,
      variant: 'shop',
      footerLeft: shopSection['footerLabel'] as String,
      pageNum: pageNum,
    ),
  );

  // -- Arcade / games --
  final arcadeSection = sections['arcade'] as Map<String, dynamic>;
  for (final game in games.cast<Map<String, dynamic>>()) {
    final description = (arcadeSection['descriptionTemplate'] as String)
        .replaceAll('{gameType}', (game['type'] as String).replaceAll('_', ' '))
        .replaceAll(
          '{unlockLesson}',
          (game['unlockAfterLessonId'] as String)
              .replaceAll('lesson_', '')
              .replaceAll('_', ' '),
        );
    addPage(
      _featurePage(
        badgeLabel: arcadeSection['badgeLabel'] as String,
        title: game['title'] as String,
        gurmukhiLabel: arcadeSection['gurmukhiLabel'] as String,
        description: description,
        pillsHtml: _pillList(
          (arcadeSection['pills'] as List).cast<String>(),
          variant: 'arcade',
        ),
        imageUri: gameImages[game['id']],
        variant: 'arcade',
        footerLeft: arcadeSection['footerLabel'] as String,
        pageNum: pageNum,
        dark: true,
      ),
    );
  }

  // -- Achievements --
  addPage(
    _featurePage(
      badgeLabel: achievementsSection['badgeLabel'] as String,
      title: achievementsSection['title'] as String,
      gurmukhiLabel: achievementsSection['gurmukhiLabel'] as String,
      description: achievementsSection['description'] as String,
      pillsHtml: _pillList(
        (achievementsSection['pills'] as List).cast<String>(),
        variant: 'achievements',
      ),
      imageUri: achievementsUri,
      variant: 'achievements',
      footerLeft: achievementsSection['footerLabel'] as String,
      pageNum: pageNum,
    ),
  );

  // -- Final Notes (closing page) --
  final finalNotesSection = sections['finalNotes'] as Map<String, dynamic>;
  pages.add(_closingPage(brand, finalNotesSection));

  // 4. Assemble the HTML document.
  final html = StringBuffer()
    ..writeln('<!DOCTYPE html><html><head><meta charset="UTF-8">')
    ..writeln('<style>$css</style>')
    ..writeln(_rootColorOverride(colors))
    ..writeln('</head><body>')
    ..writeAll(pages)
    ..writeln(
      '<script src="https://cdn.jsdelivr.net/npm/twemoji@14.0.2/dist/twemoji.min.js"></script>',
    )
    ..writeln(
      '<script>twemoji.parse(document.body, { folder: "svg", ext: ".svg" });</script>',
    )
    ..writeln('</body></html>');

  // 5. Render to PDF via headless Chrome.
  final htmlFile = File('curriculum_modern_v3_temp.html');
  await htmlFile.writeAsString(html.toString());

  final chrome = await _findChromeExecutable();
  if (chrome == null) {
    print('❌ No Chrome executable found.');
    return;
  }

  final outputFile = File(_outputPath).absolute;
  await outputFile.parent.create(recursive: true);
  final result = await _printToPdf(
    chrome,
    outputFile.path,
    htmlFile.absolute.path,
  );

  if (result.exitCode == 0 && await outputFile.exists()) {
    print('✅ Brochure generated: ${outputFile.path}');
  } else {
    print('❌ PDF generation failed.');
  }

  if (await htmlFile.exists()) await htmlFile.delete();
}
