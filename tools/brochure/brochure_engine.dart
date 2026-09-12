// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:qr/qr.dart';

class BrochureContext {
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

  BrochureContext({
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

class BrochureEngine {
  static const _dataRoot = 'tools/brochure/data';
  static const _screenshotsRoot = 'tools/brochure/screenshots';
  static const _screenshotExtensions = ['png', 'jpg', 'jpeg', 'webp'];
  static const _lessonContentRoot = 'assets/data';

  static String findProjectRoot() {
    var dir = Directory.current;
    while (true) {
      if (File('${dir.path}/pubspec.yaml').existsSync()) return dir.path;
      final parent = dir.parent;
      if (parent.path == dir.path) return Directory.current.path;
      dir = parent;
    }
  }

  static Future<BrochureContext> loadContext({
    String contentFile = 'brochure_full.json',
  }) async {
    final root = findProjectRoot();
    final shared =
        jsonDecode(
              File('$root/$_dataRoot/marketing_shared.json').readAsStringSync(),
            )
            as Map<String, dynamic>;
    final content =
        jsonDecode(File('$root/$_dataRoot/$contentFile').readAsStringSync())
            as Map<String, dynamic>;

    final manifest =
        jsonDecode(
              File(
                '$root/$_lessonContentRoot/journey_manifest.json',
              ).readAsStringSync(),
            )
            as Map<String, dynamic>;

    final lessons = [
      for (final f in (manifest['lessonFiles'] as List).cast<String>())
        jsonDecode(
              File('$root/$_lessonContentRoot/lessons/$f').readAsStringSync(),
            )
            as Map<String, dynamic>,
    ];
    final games = [
      for (final f in (manifest['gameFiles'] as List).cast<String>())
        jsonDecode(
              File('$root/$_lessonContentRoot/games/$f').readAsStringSync(),
            )
            as Map<String, dynamic>,
    ];

    // Merge sections. Shared 'finalNotes' goes into 'sections'
    final mergedSections = Map<String, dynamic>.from(content['sections'] ?? {});
    mergedSections['finalNotes'] = shared['finalNotes'];
    mergedSections['journey'] =
        mergedSections['journey'] ?? {}; // Fallback if missing

    final lessonContent = (content['lessons'] as Map?) ?? {};
    final gameContent = (content['games'] as Map?) ?? {};

    // --- Resolve images -----------------------------------------------
    // Every image is looked up purely by convention:
    // tools/brochure/screenshots/<category>/<id>.<ext>
    // There is no fallback to a `screenshot`/`logoPath` JSON field — if the
    // file isn't there, a warning is printed and the brochure renders
    // without that image. Adding a new lesson/game/section just means
    // dropping a correctly-named file in the right folder; no JSON edits.

    final lessonImages = <String, String>{};
    for (final lesson in lessons) {
      final id = lesson['id'] as String;
      final uri = await _resolveImage(root, 'lessons', id);
      if (uri != null) {
        lessonImages[id] = uri;
      } else {
        print(
          '⚠️  No screenshot found for lesson "$id" (expected $_screenshotsRoot/lessons/$id.<ext>)',
        );
      }
    }

    final gameImages = <String, String>{};
    for (final game in games) {
      final id = game['id'] as String;
      final uri = await _resolveImage(root, 'games', id);
      if (uri != null) {
        gameImages[id] = uri;
      } else {
        print(
          '⚠️  No screenshot found for game "$id" (expected $_screenshotsRoot/games/$id.<ext>)',
        );
      }
    }

    Future<String?> resolveSection(String key) =>
        _resolveImage(root, 'sections', key);

    final journeyUri = await resolveSection('journey');
    final shopUri = await resolveSection('shop');
    final achievementsUri = await resolveSection('achievements');

    if (journeyUri == null) {
      print(
        '⚠️  No screenshot found for section "journey" (expected $_screenshotsRoot/sections/journey.<ext>)',
      );
    }
    if (shopUri == null) {
      print(
        '⚠️  No screenshot found for section "shop" (expected $_screenshotsRoot/sections/shop.<ext>)',
      );
    }
    if (achievementsUri == null) {
      print(
        '⚠️  No screenshot found for section "achievements" (expected $_screenshotsRoot/sections/achievements.<ext>)',
      );
    }

    final logoUri = await _resolveImage(root, 'brand', 'logo');
    if (logoUri == null) {
      print('⚠️  No logo found (expected $_screenshotsRoot/brand/logo.<ext>)');
    }

    return BrochureContext(
      brand: shared['brand'],
      colors: shared['colors'],
      sections: mergedSections,
      lessonContent: lessonContent.cast<String, dynamic>(),
      gameContent: gameContent.cast<String, dynamic>(),
      css: File('$root/tools/style.css').readAsStringSync(),
      version: manifest['version'],
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

  static Future<void> renderPdf({
    required List<String> pages,
    required BrochureContext ctx,
    required String outputPath,
    required String tempHtmlName,
  }) async {
    final html = StringBuffer()
      ..writeln('<!DOCTYPE html><html><head><meta charset="UTF-8">')
      ..writeln('<style>${ctx.css}</style>')
      ..writeln(_rootColorOverride(ctx.colors))
      ..writeln('</head><body>')
      ..writeAll(pages)
      ..writeln(
        '<script src="https://cdn.jsdelivr.net/npm/twemoji@14.0.2/dist/twemoji.min.js"></script>',
      )
      ..writeln(
        '<script>twemoji.parse(document.body, { folder: "svg", ext: ".svg" });</script>',
      )
      ..writeln('</body></html>');

    final htmlFile = File(tempHtmlName);
    await htmlFile.writeAsString(html.toString());

    final chrome = await _findChrome();
    if (chrome == null) throw Exception('❌ No Chrome executable found.');

    final outputFile = File(outputPath).absolute;
    await outputFile.parent.create(recursive: true);

    final fileUri = Uri.file(htmlFile.absolute.path).toString();
    final args = [
      '--headless=new',
      '--disable-gpu',
      '--no-sandbox',
      '--window-size=1240,1754',
      '--print-to-pdf=${outputFile.path}',
      '--no-pdf-header-footer',
      '--virtual-time-budget=20000',
      '--run-all-compositor-stages-before-draw',
      fileUri,
    ];

    final result = await Process.run(chrome, args);
    if (await htmlFile.exists()) await htmlFile.delete();

    if (result.exitCode == 0 && await outputFile.exists()) {
      print('✅ Generated: ${outputFile.path}');
    } else {
      print('❌ PDF generation failed: ${result.stderr}');
    }
  }

  static String qrBlock(String? url, String? caption) {
    if (url == null || url.isEmpty) return '';
    return '<div class="qr-block"><div class="qr-code">${_qrCodeSvg(url)}</div><span class="qr-caption">${caption ?? 'Scan to download'}</span></div>';
  }

  static String storeBadgeIcon(String icon) {
    switch (icon) {
      case 'android':
        return '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M17.6 9.48l1.84-3.18c.16-.31.04-.69-.26-.85a.637.637 0 00-.83.22l-1.88 3.24a11.463 11.463 0 00-9.02 0L5.57 5.67a.637.637 0 00-.83-.22c-.3.16-.42.54-.26.85L6.32 9.48A10.877 10.877 0 001 18h22a10.877 10.877 0 00-5.4-8.52zM7 15.25a1.25 1.25 0 110-2.5 1.25 1.25 0 010 2.5zm10 0a1.25 1.25 0 110-2.5 1.25 1.25 0 010 2.5z"/></svg>';
      case 'ios':
        return '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><rect x="6" y="2" width="12" height="20" rx="2.5"/><line x1="10" y1="19" x2="14" y2="19" stroke-linecap="round"/></svg>';
      default:
        return '';
    }
  }

  static String contentPage({
    required String title,
    required String subtitle,
    required String bodyHtml,
    required String footerLeft,
    required int pageNum,
    bool dark = false,
  }) {
    return '''
<div class="page content-page ${dark ? 'dark-section' : ''}">
  <div class="content-header">
    <h2 style="font-size: 32px; margin: 0;">$title</h2>
    <p class="content-subtitle">$subtitle</p>
  </div>
  <div class="content-body">
    $bodyHtml
  </div>
  <div class="footer ${dark ? 'hero-footer' : ''}">
    <span>$footerLeft</span>
    <span>PAGE $pageNum</span>
  </div>
</div>''';
  }

  static String tracingLetterSvg(String letter, List<dynamic> strokes) {
    final paths = <String>[];
    int strokeNum = 1;
    for (final stroke in strokes) {
      final points = stroke as List<dynamic>;
      if (points.isEmpty) continue;

      final polyPoints = points
          .map(
            (p) =>
                '${(p['x'] * 100).toStringAsFixed(1)},${(p['y'] * 100).toStringAsFixed(1)}',
          )
          .join(' ');

      // The "Ghost" path of the letter (thick background)
      paths.add(
        '<polyline points="$polyPoints" fill="none" stroke="#BDBDBD" stroke-width="12" stroke-linecap="round" stroke-linejoin="round" />',
      );

      // Add directional arrows at EVERY checkpoint to show the flow clearly
      for (int i = 0; i < points.length - 1; i++) {
        final p1 = points[i];
        final p2 = points[i + 1];
        final x1 = p1['x'] * 100;
        final y1 = p1['y'] * 100;
        final x2 = p2['x'] * 100;
        final y2 = p2['y'] * 100;

        final dx = x2 - x1;
        final dy = y2 - y1;
        final distance = sqrt(dx * dx + dy * dy);

        if (distance > 1.5) {
          final angle = atan2(dy, dx);

          // Larger, clearer arrows
          final hl = 6.0; // Increased head size
          final al = min(10.0, distance * 0.8); // Increased body length

          final ex = x1 + cos(angle) * al;
          final ey = y1 + sin(angle) * al;

          final h1x = ex - hl * cos(angle - pi / 6);
          final h1y = ey - hl * sin(angle - pi / 6);
          final h2x = ex - hl * cos(angle + pi / 6);
          final h2y = ey - hl * sin(angle + pi / 6);

          // High-contrast Arrow Body
          paths.add(
            '<line x1="${x1.toStringAsFixed(1)}" y1="${y1.toStringAsFixed(1)}" x2="${ex.toStringAsFixed(1)}" y2="${ey.toStringAsFixed(1)}" stroke="var(--color-primary)" stroke-width="2.2" stroke-linecap="round" />',
          );
          // High-contrast Arrow Head
          paths.add(
            '<polyline points="${h1x.toStringAsFixed(1)},${h1y.toStringAsFixed(1)} ${ex.toStringAsFixed(1)},${ey.toStringAsFixed(1)} ${h2x.toStringAsFixed(1)},${h2y.toStringAsFixed(1)}" fill="none" stroke="var(--color-primary)" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" />',
          );
        }

        // Checkpoint dot (subtle)
        paths.add(
          '<circle cx="${x1.toStringAsFixed(1)}" cy="${y1.toStringAsFixed(1)}" r="1" fill="var(--color-accent)" opacity="0.4" />',
        );
      }

      // Final checkpoint dot
      final last = points.last;
      paths.add(
        '<circle cx="${(last['x'] * 100).toStringAsFixed(1)}" cy="${(last['y'] * 100).toStringAsFixed(1)}" r="1" fill="var(--color-accent)" opacity="0.4" />',
      );

      // Subtle Stroke Number Badge
      final start = points.first;
      final sx = start['x'] * 100;
      final sy = start['y'] * 100;
      paths.add('''
        <circle cx="${sx.toStringAsFixed(1)}" cy="${sy.toStringAsFixed(1)}" r="5" fill="var(--color-accent)" opacity="0.3" />
        <text x="${sx.toStringAsFixed(1)}" y="${(sy + 1.8).toStringAsFixed(1)}" text-anchor="middle" font-size="6" font-weight="600" fill="var(--color-primary)" opacity="0.6">$strokeNum</text>
      ''');

      strokeNum++;
    }

    return '''
<div class="tracing-tile">
  <div class="tracing-svg-container">
    <svg viewBox="0 0 100 100" class="tracing-svg">
      ${paths.join('\n')}
    </svg>
  </div>
  <span class="tracing-letter-label">$letter</span>
</div>''';
  }

  static String _rootColorOverride(Map<String, dynamic> colors) {
    final vars = colors.entries
        .map(
          (e) =>
              '--color-${e.key.replaceAllMapped(RegExp(r"[A-Z]"), (m) => "-${m.group(0)!.toLowerCase()}")}: ${e.value};',
        )
        .join(' ');
    return '<style>:root { $vars }</style>';
  }

  static String _qrCodeSvg(String data) {
    final qrCode = QrCode.fromData(
      data: data,
      errorCorrectLevel: QrErrorCorrectLevel.M,
    );
    final qrImage = QrImage(qrCode);
    final cell = 200 / qrImage.moduleCount;
    final modules = StringBuffer();
    for (var x = 0; x < qrImage.moduleCount; x++) {
      for (var y = 0; y < qrImage.moduleCount; y++) {
        if (qrImage.isDark(y, x)) {
          modules.write(
            '<rect x="${(x * cell).toStringAsFixed(2)}" y="${(y * cell).toStringAsFixed(2)}" width="${cell.toStringAsFixed(2)}" height="${cell.toStringAsFixed(2)}" fill="#1B2A4A"/>',
          );
        }
      }
    }
    return '<svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg"><rect width="200" height="200" fill="white"/>$modules</svg>';
  }

  static Future<String?> _findChrome() async {
    final paths = [
      'google-chrome-stable',
      'google-chrome',
      'chromium',
      '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
    ];
    for (final p in paths) {
      if (p.startsWith('/') && File(p).existsSync()) return p;
      try {
        final r = await Process.run('which', [p]);
        if (r.exitCode == 0) return (r.stdout as String).trim();
      } catch (_) {}
    }
    return null;
  }

  /// Resolves an image for [id] within [category] (e.g. 'lessons', 'games',
  /// 'sections', 'brand') by looking for
  /// `$_screenshotsRoot/$category/$id.<ext>` across each known extension.
  /// Returns a base64 data URI, or null if no matching file exists.
  static Future<String?> _resolveImage(
    String root,
    String category,
    String id,
  ) async {
    for (final ext in _screenshotExtensions) {
      final candidate = '$root/$_screenshotsRoot/$category/$id.$ext';
      if (File(candidate).existsSync()) {
        return _loadAsDataUri(candidate);
      }
    }
    return null;
  }

  static Future<String?> _loadAsDataUri(String? path) async {
    if (path == null || !File(path).existsSync()) return null;
    final bytes = await File(path).readAsBytes();
    final lower = path.toLowerCase();
    final mime = lower.endsWith('.png')
        ? 'image/png'
        : lower.endsWith('.webp')
        ? 'image/webp'
        : 'image/jpeg';
    return 'data:$mime;base64,${base64Encode(bytes)}';
  }
}
