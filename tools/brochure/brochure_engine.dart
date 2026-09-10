// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
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
  static String findProjectRoot() {
    var dir = Directory.current;
    while (true) {
      if (File('${dir.path}/pubspec.yaml').existsSync()) return dir.path;
      final parent = dir.parent;
      if (parent.path == dir.path) return Directory.current.path;
      dir = parent;
    }
  }

  static Future<BrochureContext> loadContext() async {
    final root = findProjectRoot();
    final config = jsonDecode(File('$root/assets/data/brochure_content.json').readAsStringSync()) as Map<String, dynamic>;
    final manifest = jsonDecode(File('$root/assets/data/journey_manifest.json').readAsStringSync()) as Map<String, dynamic>;
    
    final lessons = [
      for (final f in (manifest['lessonFiles'] as List).cast<String>())
        jsonDecode(File('$root/assets/data/lessons/$f').readAsStringSync()) as Map<String, dynamic>,
    ];
    final games = [
      for (final f in (manifest['gameFiles'] as List).cast<String>())
        jsonDecode(File('$root/assets/data/games/$f').readAsStringSync()) as Map<String, dynamic>,
    ];

    Future<String?> loadImage(String? rel) => _loadAsDataUri(rel == null ? null : '$root/$rel');

    final lessonImages = <String, String>{};
    for (final e in (config['lessons'] as Map).entries) {
      final uri = await loadImage(e.value['screenshot']);
      if (uri != null) lessonImages[e.key] = uri;
    }

    final gameImages = <String, String>{};
    for (final e in (config['games'] as Map).entries) {
      final uri = await loadImage(e.value['screenshot']);
      if (uri != null) gameImages[e.key] = uri;
    }

    return BrochureContext(
      brand: config['brand'],
      colors: config['colors'],
      sections: config['sections'],
      lessonContent: config['lessons'],
      gameContent: config['games'],
      css: File('$root/tools/style.css').readAsStringSync(),
      version: manifest['version'],
      lessons: lessons,
      games: games,
      logoUri: await loadImage(config['brand']['logoPath']),
      journeyUri: await loadImage(config['sections']['journey']['screenshot']),
      shopUri: await loadImage(config['sections']['shop']['screenshot']),
      achievementsUri: await loadImage(config['sections']['achievements']['screenshot']),
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
      ..writeln('<script src="https://cdn.jsdelivr.net/npm/twemoji@14.0.2/dist/twemoji.min.js"></script>')
      ..writeln('<script>twemoji.parse(document.body, { folder: "svg", ext: ".svg" });</script>')
      ..writeln('</body></html>');

    final htmlFile = File(tempHtmlName);
    await htmlFile.writeAsString(html.toString());

    final chrome = await _findChrome();
    if (chrome == null) throw Exception('❌ No Chrome executable found.');

    final outputFile = File(outputPath).absolute;
    await outputFile.parent.create(recursive: true);

    final fileUri = Uri.file(htmlFile.absolute.path).toString();
    final args = [
      '--headless=new', '--disable-gpu', '--no-sandbox', '--window-size=1240,1754',
      '--print-to-pdf=${outputFile.path}', '--no-pdf-header-footer',
      '--virtual-time-budget=20000', '--run-all-compositor-stages-before-draw', fileUri,
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
      case 'android': return '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M17.6 9.48l1.84-3.18c.16-.31.04-.69-.26-.85a.637.637 0 00-.83.22l-1.88 3.24a11.463 11.463 0 00-9.02 0L5.57 5.67a.637.637 0 00-.83-.22c-.3.16-.42.54-.26.85L6.32 9.48A10.877 10.877 0 001 18h22a10.877 10.877 0 00-5.4-8.52zM7 15.25a1.25 1.25 0 110-2.5 1.25 1.25 0 010 2.5zm10 0a1.25 1.25 0 110-2.5 1.25 1.25 0 010 2.5z"/></svg>';
      case 'ios': return '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><rect x="6" y="2" width="12" height="20" rx="2.5"/><line x1="10" y1="19" x2="14" y2="19" stroke-linecap="round"/></svg>';
      default: return '';
    }
  }

  static String _rootColorOverride(Map<String, dynamic> colors) {
    final vars = colors.entries.map((e) => '--color-${e.key.replaceAllMapped(RegExp(r"[A-Z]"), (m) => "-${m.group(0)!.toLowerCase()}")}: ${e.value};').join(' ');
    return '<style>:root { $vars }</style>';
  }

  static String _qrCodeSvg(String data) {
    final qrCode = QrCode.fromData(data: data, errorCorrectLevel: QrErrorCorrectLevel.M);
    final qrImage = QrImage(qrCode);
    final cell = 200 / qrImage.moduleCount;
    final modules = StringBuffer();
    for (var x = 0; x < qrImage.moduleCount; x++) {
      for (var y = 0; y < qrImage.moduleCount; y++) {
        if (qrImage.isDark(y, x)) modules.write('<rect x="${(x * cell).toStringAsFixed(2)}" y="${(y * cell).toStringAsFixed(2)}" width="${cell.toStringAsFixed(2)}" height="${cell.toStringAsFixed(2)}" fill="#1B2A4A"/>');
      }
    }
    return '<svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg"><rect width="200" height="200" fill="white"/>$modules</svg>';
  }

  static Future<String?> _findChrome() async {
    final paths = ['google-chrome-stable', 'google-chrome', 'chromium', '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'];
    for (final p in paths) {
      if (p.startsWith('/') && File(p).existsSync()) return p;
      try {
        final r = await Process.run('which', [p]);
        if (r.exitCode == 0) return (r.stdout as String).trim();
      } catch (_) {}
    }
    return null;
  }

  static Future<String?> _loadAsDataUri(String? path) async {
    if (path == null || !File(path).existsSync()) return null;
    final bytes = await File(path).readAsBytes();
    final mime = path.toLowerCase().endsWith('.png') ? 'image/png' : 'image/jpeg';
    return 'data:$mime;base64,${base64Encode(bytes)}';
  }
}
