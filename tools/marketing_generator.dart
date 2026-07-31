// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

import 'package:qr/qr.dart';

/// Generates premium marketing PDFs of the curriculum.
///
/// To run this tool, use:
/// ```bash
/// dart tools/marketing_generator.dart [--full] [--flyer]
/// ```
///
/// If no flags are provided, both the full brochure and the flyer are generated.
void main(List<String> args) async {
  bool generateFull = args.isEmpty || args.contains('--full') || args.contains('-f');
  bool generateFlyer = args.isEmpty || args.contains('--flyer') || args.contains('-s');

  if (!generateFull && !generateFlyer) {
    print('Usage: dart tools/marketing_generator.dart [--full|-f] [--flyer|-s]');
    return;
  }

  print('🚀 Starting Marketing Generator...');
  final generator = await MarketingGenerator.load();

  if (generateFull) {
    await generator.generateBrochure();
  }

  if (generateFlyer) {
    await generator.generateFlyer();
  }
}

// --------------------------------------------------------------------------
// Context & Class Definition
// --------------------------------------------------------------------------

class MarketingGenerator {
  final _BrochureContext ctx;

  MarketingGenerator._(this.ctx);

  static Future<MarketingGenerator> load() async {
    final ctx = await _loadContext();
    return MarketingGenerator._(ctx);
  }

  /// Generates the multi-page premium brochure.
  Future<void> generateBrochure() async {
    print('📄 Building multi-page brochure...');
    final pages = <String>[_heroPage(ctx.brand, ctx.logoUri, ctx.version)];
    var pageNum = 2;

    void addPage(String html) {
      pages.add(html);
      pageNum++;
    }

    // 1. Journey Spotlight
    final journeySection = ctx.sections['journey'] as Map<String, dynamic>;
    addPage(_featurePage(
      badgeLabel: journeySection['badgeLabel'] as String,
      title: journeySection['title'] as String,
      gurmukhiLabel: journeySection['gurmukhiLabel'] as String,
      description: journeySection['description'] as String,
      pillsHtml: _pillList((journeySection['pills'] as List).cast<String>()),
      imageUri: ctx.journeyUri,
      footerLeft: journeySection['footerLabel'] as String,
      pageNum: pageNum,
    ));

    // 2. Lessons
    final remainingLessons = List<Map<String, dynamic>>.from(ctx.lessons)
      ..sort((a, b) {
        if (a['id'] == 'lesson_arrange_sentence') return 1;
        if (b['id'] == 'lesson_arrange_sentence') return -1;
        return 0;
      });

    final lessonSection = ctx.sections['lessonModule'] as Map<String, dynamic>;
    for (var i = 0; i < remainingLessons.length; i++) {
      final lesson = remainingLessons[i];
      final data = ctx.lessonContent[lesson['id']] as Map<String, dynamic>?;
      addPage(_featurePage(
        badgeLabel: '${lessonSection['badgeLabel']} ${i + 1}',
        title: lesson['title'] as String,
        gurmukhiLabel: ctx.brand['gurmukhiTagline'] as String,
        description: data?['copy'] as String? ?? '',
        pillsHtml: _pillList([
          for (final s in (lesson['sections'] as List)) s['title'] as String,
        ]),
        imageUri: ctx.lessonImages[lesson['id']],
        footerLeft: lessonSection['footerLabel'] as String,
        pageNum: pageNum,
      ));
    }

    // 3. Shop
    final shopSection = ctx.sections['shop'] as Map<String, dynamic>;
    addPage(_featurePage(
      badgeLabel: shopSection['badgeLabel'] as String,
      title: shopSection['title'] as String,
      gurmukhiLabel: shopSection['gurmukhiLabel'] as String,
      description: shopSection['description'] as String,
      pillsHtml: _pillList((shopSection['pills'] as List).cast<String>(), variant: 'shop'),
      imageUri: ctx.shopUri,
      variant: 'shop',
      footerLeft: shopSection['footerLabel'] as String,
      pageNum: pageNum,
    ));

    // 4. Arcade
    final arcadeSection = ctx.sections['arcade'] as Map<String, dynamic>;
    for (final game in ctx.games) {
      final description = (arcadeSection['descriptionTemplate'] as String)
          .replaceAll('{gameType}', (game['type'] as String).replaceAll('_', ' '))
          .replaceAll('{unlockLesson}', (game['unlockAfterLessonId'] as String).replaceAll('lesson_', '').replaceAll('_', ' '));
      addPage(_featurePage(
        badgeLabel: arcadeSection['badgeLabel'] as String,
        title: game['title'] as String,
        gurmukhiLabel: arcadeSection['gurmukhiLabel'] as String,
        description: description,
        pillsHtml: _pillList((arcadeSection['pills'] as List).cast<String>(), variant: 'arcade'),
        imageUri: ctx.gameImages[game['id']],
        variant: 'arcade',
        footerLeft: arcadeSection['footerLabel'] as String,
        pageNum: pageNum,
        dark: true,
      ));
    }

    // 5. Achievements
    final achievementsSection = ctx.sections['achievements'] as Map<String, dynamic>;
    addPage(_featurePage(
      badgeLabel: achievementsSection['badgeLabel'] as String,
      title: achievementsSection['title'] as String,
      gurmukhiLabel: achievementsSection['gurmukhiLabel'] as String,
      description: achievementsSection['description'] as String,
      pillsHtml: _pillList((achievementsSection['pills'] as List).cast<String>(), variant: 'achievements'),
      imageUri: ctx.achievementsUri,
      variant: 'achievements',
      footerLeft: achievementsSection['footerLabel'] as String,
      pageNum: pageNum,
    ));

    // 6. Closing
    pages.add(_closingPage(ctx.brand, ctx.sections['finalNotes'] as Map<String, dynamic>));

    await _renderPagesToPdf(
      pages: pages,
      css: ctx.css,
      colors: ctx.colors,
      outputPath: _brochureOutputPath,
      tempHtmlName: 'brochure_temp.html',
    );
  }

  /// Generates the single-page flyer.
  Future<void> generateFlyer() async {
    print('📄 Building single-page flyer...');
    final onePagerSection = ctx.sections['onePager'] as Map<String, dynamic>?;
    if (onePagerSection == null) {
      print('⚠️  No "onePager" section found in brochure_content.json — skipping flyer.');
      return;
    }

    final page = _onePagerPage(
      brand: ctx.brand,
      onePagerSection: onePagerSection,
      finalNotesSection: ctx.sections['finalNotes'] as Map<String, dynamic>,
      logoUri: ctx.logoUri,
      journeyImageUri: ctx.journeyUri,
    );

    await _renderPagesToPdf(
      pages: [page],
      css: ctx.css,
      colors: ctx.colors,
      outputPath: _onePagerOutputPath,
      tempHtmlName: 'flyer_temp.html',
    );
  }
}

// --------------------------------------------------------------------------
// Path & Context Resolution (Internal)
// --------------------------------------------------------------------------

String _findProjectRoot() {
  var dir = Directory.current;
  while (true) {
    if (File('${dir.path}/pubspec.yaml').existsSync()) return dir.path;
    final parent = dir.parent;
    if (parent.path == dir.path) return Directory.current.path;
    dir = parent;
  }
}

final _projectRoot = _findProjectRoot();
String get _contentConfigPath => '$_projectRoot/assets/data/brochure_content.json';
String get _stylesheetPath => '$_projectRoot/tools/style.css';
String get _manifestPath => '$_projectRoot/assets/data/journey_manifest.json';
String get _lessonsDir => '$_projectRoot/assets/data/lessons';
String get _gamesDir => '$_projectRoot/assets/data/games';
String get _brochureOutputPath => '$_projectRoot/exports/GNPS_Brochure_Premium.pdf';
String get _onePagerOutputPath => '$_projectRoot/exports/GNPS_OnePager.pdf';

class _BrochureContext {
  final Map<String, dynamic> brand;
  final Map<String, dynamic> colors;
  final Map<String, dynamic> sections;
  final Map<String, dynamic> lessonContent;
  final Map<String, dynamic> gameContent;
  final String css;
  final int version;
  final List<Map<String, dynamic>> lessons;
  final List<Map<String, dynamic>> games;
  final String? logoUri;
  final String? journeyUri;
  final String? shopUri;
  final String? achievementsUri;
  final Map<String, String> lessonImages;
  final Map<String, String> gameImages;

  _BrochureContext({
    required this.brand,
    required this.colors,
    required this.sections,
    required this.lessonContent,
    required this.gameContent,
    required this.css,
    required this.version,
    required this.lessons,
    required this.games,
    this.logoUri,
    this.journeyUri,
    this.shopUri,
    this.achievementsUri,
    required this.lessonImages,
    required this.gameImages,
  });
}

Future<_BrochureContext> _loadContext() async {
  final config = jsonDecode(File(_contentConfigPath).readAsStringSync()) as Map<String, dynamic>;
  final brand = config['brand'] as Map<String, dynamic>;
  final colors = config['colors'] as Map<String, dynamic>;
  final sections = config['sections'] as Map<String, dynamic>;
  final lessonContent = config['lessons'] as Map<String, dynamic>;
  final gameContent = config['games'] as Map<String, dynamic>;

  final css = File(_stylesheetPath).readAsStringSync();
  final manifest = jsonDecode(File(_manifestPath).readAsStringSync()) as Map<String, dynamic>;
  final version = manifest['version'] as int;
  final lessonFiles = (manifest['lessonFiles'] as List).cast<String>();
  final gameFiles = (manifest['gameFiles'] as List).cast<String>();

  final lessons = [for (final f in lessonFiles) jsonDecode(File('$_lessonsDir/$f').readAsStringSync()) as Map<String, dynamic>];
  final games = [for (final f in gameFiles) jsonDecode(File('$_gamesDir/$f').readAsStringSync()) as Map<String, dynamic>];

  Future<String?> loadImage(String? rel) => _loadAsDataUri(rel == null ? null : '$_projectRoot/$rel');

  final logoUri = await loadImage(brand['logoPath']);
  final journeyUri = await loadImage(sections['journey']['screenshot']);
  final shopUri = await loadImage(sections['shop']['screenshot']);
  final achievementsUri = await loadImage(sections['achievements']['screenshot']);

  final lessonImages = <String, String>{};
  for (final e in lessonContent.entries) {
    final uri = await loadImage(e.value['screenshot']);
    if (uri != null) lessonImages[e.key] = uri;
  }

  final gameImages = <String, String>{};
  for (final e in gameContent.entries) {
    final uri = await loadImage(e.value['screenshot']);
    if (uri != null) gameImages[e.key] = uri;
  }

  return _BrochureContext(
    brand: brand,
    colors: colors,
    sections: sections,
    lessonContent: lessonContent,
    gameContent: gameContent,
    css: css,
    version: version,
    lessons: lessons,
    games: games,
    logoUri: logoUri,
    journeyUri: journeyUri,
    shopUri: shopUri,
    achievementsUri: achievementsUri,
    lessonImages: lessonImages,
    gameImages: gameImages,
  );
}

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
// HTML Rendering & Helpers
// --------------------------------------------------------------------------

Future<void> _renderPagesToPdf({
  required List<String> pages,
  required String css,
  required Map<String, dynamic> colors,
  required String outputPath,
  required String tempHtmlName,
}) async {
  final html = StringBuffer()
    ..writeln('<!DOCTYPE html><html><head><meta charset="UTF-8">')
    ..writeln('<style>$css</style>')
    ..writeln(_rootColorOverride(colors))
    ..writeln('</head><body>')
    ..writeAll(pages)
    ..writeln('<script src="https://cdn.jsdelivr.net/npm/twemoji@14.0.2/dist/twemoji.min.js"></script>')
    ..writeln('<script>twemoji.parse(document.body, { folder: "svg", ext: ".svg" });</script>')
    ..writeln('</body></html>');

  final htmlFile = File(tempHtmlName);
  await htmlFile.writeAsString(html.toString());

  final chrome = await _findChromeExecutable();
  if (chrome == null) {
    print('❌ No Chrome executable found.');
    if (await htmlFile.exists()) await htmlFile.delete();
    return;
  }

  final outputFile = File(outputPath).absolute;
  await outputFile.parent.create(recursive: true);
  final result = await _printToPdf(chrome, outputFile.path, htmlFile.absolute.path);

  if (result.exitCode == 0 && await outputFile.exists()) {
    print('✅ Generated: ${outputFile.path}');
  } else {
    print('❌ PDF generation failed for ${outputFile.path}');
  }

  if (await htmlFile.exists()) await htmlFile.delete();
}

String _rootColorOverride(Map<String, dynamic> colors) {
  final vars = colors.entries.map((e) => '--color-${_kebab(e.key)}: ${e.value};').join(' ');
  return '<style>:root { $vars }</style>';
}

String _kebab(String camel) => camel.replaceAllMapped(RegExp(r'[A-Z]'), (m) => '-${m.group(0)!.toLowerCase()}');

String _heroPage(Map<String, dynamic> brand, String? logoUri, int version) {
  final logo = logoUri != null ? '<img src="$logoUri" alt="${brand['appName']} Logo" style="width: 180px; margin-bottom: 40px; border-radius: 30px; box-shadow: 0 20px 40px rgba(0,0,0,0.4);" />' : '';
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

String _closingPage(Map<String, dynamic> brand, Map<String, dynamic> finalNotes) {
  final platforms = (finalNotes['platforms'] as List).cast<Map<String, dynamic>>();
  final badgesHtml = platforms.map((p) {
    final available = (p['status'] as String).toLowerCase().contains('available');
    return '''
    <div class="store-badge ${available ? 'available' : 'soon'}">
      <div class="store-badge-icon">${_storeBadgeIcon(p['icon'])}</div>
      <div class="store-badge-text">
        <span class="store-badge-status">${p['status']}</span>
        <span class="store-badge-name">${p['name']}</span>
      </div>
    </div>''';
  }).join();

  return '''
<div class="page closing-page">
  <h1 style="font-size: 52px; margin: 0 0 12px 0;">${finalNotes['title']}</h1>
  <p class="gurmukhi-tag" style="margin: 0 0 20px 0;">${finalNotes['gurmukhiLabel']}</p>
  <p style="font-size: 19px; line-height: 1.6; max-width: 640px; color: rgba(251, 247, 239, 0.8);">${finalNotes['message']}</p>
  <div class="store-badges">$badgesHtml</div>
  ${_qrBlock(finalNotes['googlePlayUrl'], finalNotes['qrCaption'])}
  <div class="footer hero-footer"><span>${finalNotes['footerLabel']}</span><span>${brand['appName']}</span></div>
</div>''';
}

String _onePagerPage({
  required Map<String, dynamic> brand,
  required Map<String, dynamic> onePagerSection,
  required Map<String, dynamic> finalNotesSection,
  String? logoUri,
  String? journeyImageUri,
}) {
  final logo = logoUri != null ? '<img src="$logoUri" alt="${brand['appName']} Logo" />' : '';
  final imageBlock = journeyImageUri == null ? '' : '<div class="onepager-image"><div class="phone-mockup"><div class="phone-screen"><img src="$journeyImageUri" alt="App Preview" /></div></div></div>';

  return '''
<div class="page onepager-page">
  <div class="onepager-header">$logo<h1>${brand['appName']}</h1></div>
  <div class="onepager-body">
    <div class="onepager-text">
      <p class="gurmukhi-tag">${onePagerSection['gurmukhiLabel']}</p>
      <p class="description">${onePagerSection['shortDescription']}</p>
      <div class="onepager-footer-row">${_qrBlock(finalNotesSection['googlePlayUrl'], finalNotesSection['qrCaption'])}</div>
    </div>
    $imageBlock
  </div>
  <div class="footer hero-footer"><span>${onePagerSection['footerLabel']}</span><span>${brand['appName']}</span></div>
</div>''';
}

String _featurePage({
  required String badgeLabel,
  required String title,
  required String gurmukhiLabel,
  required String description,
  required String pillsHtml,
  required String footerLeft,
  required int pageNum,
  String? imageUri,
  String variant = '',
  bool dark = false,
}) {
  final alt = pageNum % 2 != 0;
  final pageClasses = ['page', 'feature-page', if (dark) 'dark-section', if (alt) 'alt'].join(' ');
  final withVariant = (String b) => variant.isEmpty ? b : '$b $variant';
  final imageBlock = imageUri == null ? '' : '<div class="image-side"><div class="${withVariant('phone-mockup')}"><div class="phone-screen"><img src="$imageUri" alt="$title Preview" /></div></div></div>';

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
  <div class="${dark ? 'footer hero-footer' : 'footer'}"><span>$footerLeft</span><span>PAGE $pageNum</span></div>
</div>''';
}

String _pillList(List<String> labels, {String variant = ''}) {
  final cls = variant.isEmpty ? 'pill' : 'pill $variant';
  return labels.map((l) => '<div class="$cls">$l</div>').join();
}

String _qrBlock(String? url, String? caption) {
  if (url == null || url.isEmpty) return '';
  return '<div class="qr-block"><div class="qr-code">${_qrCodeSvg(url)}</div><span class="qr-caption">${caption ?? 'Scan to download'}</span></div>';
}

String _qrCodeSvg(String data, {int size = 160}) {
  final qrCode = QrCode.fromData(data: data, errorCorrectLevel: QrErrorCorrectLevel.M);
  final qrImage = QrImage(qrCode);
  final moduleCount = qrImage.moduleCount;
  final cell = size / moduleCount;
  final modules = StringBuffer();
  for (var x = 0; x < moduleCount; x++) {
    for (var y = 0; y < moduleCount; y++) {
      if (qrImage.isDark(y, x)) {
        modules.write('<rect x="${(x * cell).toStringAsFixed(2)}" y="${(y * cell).toStringAsFixed(2)}" width="${cell.toStringAsFixed(2)}" height="${cell.toStringAsFixed(2)}" fill="#1B2A4A"/>');
      }
    }
  }
  return '<svg viewBox="0 0 $size $size" xmlns="http://www.w3.org/2000/svg"><rect width="$size" height="$size" fill="white"/>$modules</svg>';
}

String _storeBadgeIcon(String icon) {
  switch (icon) {
    case 'android': return '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M17.6 9.48l1.84-3.18c.16-.31.04-.69-.26-.85a.637.637 0 00-.83.22l-1.88 3.24a11.463 11.463 0 00-9.02 0L5.57 5.67a.637.637 0 00-.83-.22c-.3.16-.42.54-.26.85L6.32 9.48A10.877 10.877 0 001 18h22a10.877 10.877 0 00-5.4-8.52zM7 15.25a1.25 1.25 0 110-2.5 1.25 1.25 0 010 2.5zm10 0a1.25 1.25 0 110-2.5 1.25 1.25 0 010 2.5z"/></svg>';
    case 'ios': return '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><rect x="6" y="2" width="12" height="20" rx="2.5"/><line x1="10" y1="19" x2="14" y2="19" stroke-linecap="round"/></svg>';
    default: return '';
  }
}
