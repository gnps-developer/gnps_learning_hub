// ignore_for_file: avoid_print
import 'dart:io';
import 'package:gnps_learning_hub/data/journey_data.dart';

/// Generates a premium, detailed 2-page marketing PDF of the curriculum.
///
/// Requires Google Chrome or Chromium to be installed and on PATH
/// (used for accurate, browser-grade HTML -> PDF rendering).
///
/// To run this tool, use:
/// ```bash
/// flutter test tool/marketing_generator.dart
/// ```
void main() async {
  print('🚀 Starting Premium Curriculum Brochure Generator...');
  await generateMarketingPdf();
}

/// Looks for a usable Chrome/Chromium executable across common
/// locations on macOS, Linux and CI runners.
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
    } catch (_) {
      // Ignore and try the next candidate.
    }
  }
  return null;
}

/// Runs headless Chrome to print [htmlPath] to [outputPath], trying the
/// modern headless engine first and falling back to the classic one for
/// older Chrome/Chromium builds.
Future<ProcessResult> _printToPdf(
  String chrome,
  String outputPath,
  String htmlPath,
) async {
  final fileUri = Uri.file(htmlPath).toString();
  final baseArgs = [
    '--disable-gpu',
    '--no-sandbox',
    '--window-size=1240,1754', // A4 @ ~150dpi, avoids viewport-driven clipping
    '--print-to-pdf=$outputPath',
    '--no-pdf-header-footer',
    // Gives web fonts (Google Fonts + emoji fallback) time to load before
    // the page is printed — headless Chrome otherwise may print before
    // they arrive.
    '--virtual-time-budget=10000',
    fileUri,
  ];

  var result = await Process.run(chrome, ['--headless=new', ...baseArgs]);
  if (result.exitCode != 0 || !(await File(outputPath).exists())) {
    result = await Process.run(chrome, ['--headless', ...baseArgs]);
  }
  return result;
}

Future<void> generateMarketingPdf() async {
  final buffer = StringBuffer();

  int appTotalTasks = 0;
  for (final lesson in journeyData.lessons) {
    appTotalTasks += lesson.allTasks.length;
  }

  final lessonIcons = [
    '✍️', // Tracing
    '👂', // Letter Selection
    '🔡', // Spelling
    '🖼️', // Match Picture
    '📖', // Match Words
    '✏️', // Fill in Blanks
    '🧩', // Sentence Arrangement
  ];

  const accentColors = [
    '#F2A93B', // marigold
    '#FF7A29', // saffron
    '#E23E82', // phulkari pink
    '#4C9A6B', // leaf green
    '#3F6FA8', // sky blue
  ];

  final features = [
    {
      'icon': '🗣️',
      'title': 'Native Punjabi Audio',
      'desc':
          'Every word and letter comes with real Punjabi pronunciation, so kids learn to speak, not just read.',
    },
    {
      'icon': '✍️',
      'title': 'Guided Letter Tracing',
      'desc':
          'Step-by-step stroke guidance with checkpoints helps little hands learn to write Gurmukhi correctly, one stroke at a time.',
    },
    {
      'icon': '🎮',
      'title': 'Playful Practice',
      'desc':
          'Matching games, spelling challenges and arcade rounds turn repetition into something kids actually look forward to.',
    },
    {
      'icon': '🔒',
      'title': 'Safe & Private',
      'desc':
          'No sign-up, no ads, no data collection. All progress is saved right on the child\'s own device.',
    },
    {
      'icon': '🪔',
      'title': 'Rooted in Culture',
      'desc':
          'Gurmukhi script, Sikh characters and everyday vocabulary, designed with cultural authenticity in mind.',
    },
    {
      'icon': '📈',
      'title': 'A Roadmap to Grow',
      'desc':
          'A structured sequence of levels carries learners from first letters all the way to full sentences.',
    },
  ];

  const style = '''
<style>
  @import url('https://fonts.googleapis.com/css2?family=Baloo+Paaji+2:wght@500;600;700;800&family=Work+Sans:wght@400;500;600;700&display=swap');

  @page {
    size: A4;
    margin: 0;
  }

  * {
    box-sizing: border-box;
  }

  body {
    font-family: 'Work Sans', sans-serif;
    color: #1B2A4A;
    margin: 0;
    padding: 0;
    background: #FBF7EF;
    -webkit-print-color-adjust: exact;
  }

  h1, h2, h3, .display {
    font-family: 'Baloo Paaji 2', sans-serif;
  }

  /* Emoji-aware fallback stack — anywhere an emoji glyph actually
     appears in the markup. Guards against tofu boxes / missing icons
     on machines without a color-emoji font installed. */
  .lesson-title, .fun-zone-text h3, .feature-icon, .app-mark, .game-pill {
    font-family: 'Work Sans', 'Noto Color Emoji', 'Apple Color Emoji',
      'Segoe UI Emoji', sans-serif;
  }

  .page {
    width: 210mm;
  }

  .page-break {
    page-break-before: always;
    break-before: page;
  }

  /* ---------- Hero ---------- */
  .hero {
    background: linear-gradient(135deg, #1B2A4A 0%, #12203A 100%);
    color: #FBF7EF;
    padding: 46px 60px 36px 60px;
    position: relative;
    overflow: hidden;
    break-inside: avoid;
    page-break-inside: avoid;
  }

  .hero-watermark {
    position: absolute;
    top: -20px;
    right: 10px;
    width: 260px;
    height: 260px;
    opacity: 0.16;
  }

  .app-mark {
    width: 46px;
    height: 46px;
    border-radius: 12px;
    background: rgba(242, 169, 59, 0.14);
    border: 1px solid rgba(242, 169, 59, 0.4);
    display: flex;
    align-items: center;
    justify-content: center;
    font-family: 'Baloo Paaji 2', sans-serif;
    font-size: 24px;
    font-weight: 700;
    color: #F2A93B;
    margin-bottom: 16px;
  }

  .eyebrow {
    display: inline-block;
    font-size: 12px;
    font-weight: 700;
    letter-spacing: 2px;
    text-transform: uppercase;
    color: #F2A93B;
    border: 1px solid rgba(242, 169, 59, 0.4);
    padding: 6px 14px;
    border-radius: 99px;
    margin-bottom: 18px;
  }

  .hero h1 {
    font-size: 44px;
    font-weight: 800;
    margin: 0;
    letter-spacing: -1px;
    line-height: 1.05;
    color: #FBF7EF;
  }

  .hero .gurmukhi-tag {
    font-family: 'Baloo Paaji 2', sans-serif;
    font-size: 24px;
    font-weight: 600;
    color: #F2A93B;
    margin: 14px 0 6px 0;
  }

  .hero .sub-tag {
    font-size: 15px;
    font-weight: 500;
    color: rgba(251, 247, 239, 0.7);
    margin: 0;
  }

  /* ---------- Stat ribbon ---------- */
  .stat-ribbon {
    display: flex;
    background: #FBF7EF;
    border-bottom: 1px solid #EFE8D8;
    break-inside: avoid;
    page-break-inside: avoid;
  }

  .stat-item {
    flex: 1;
    text-align: center;
    padding: 22px 10px;
    border-left: 1px dashed #DCD3BC;
  }

  .stat-item:first-child {
    border-left: none;
  }

  .stat-value {
    display: block;
    font-family: 'Baloo Paaji 2', sans-serif;
    font-size: 32px;
    font-weight: 800;
    color: #1B2A4A;
    line-height: 1;
    margin-bottom: 6px;
  }

  .stat-item.featured .stat-value {
    color: #FF7A29;
  }

  .stat-label {
    font-size: 11px;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 1.2px;
    color: #8A8270;
  }

  /* ---------- Content ---------- */
  .content {
    padding: 40px 60px 20px 60px;
  }

  .section-heading-row {
    display: flex;
    align-items: center;
    gap: 16px;
    margin-bottom: 26px;
    break-after: avoid;
    page-break-after: avoid;
  }

  .section-heading {
    font-size: 22px;
    font-weight: 800;
    color: #1B2A4A;
    white-space: nowrap;
  }

  .section-kicker {
    font-size: 12px;
    font-weight: 700;
    letter-spacing: 1.4px;
    text-transform: uppercase;
    color: #B99A55;
    margin: 0 0 6px 0;
    break-after: avoid;
    page-break-after: avoid;
  }

  .trace-divider {
    flex: 1;
    height: 14px;
  }

  /* Flexbox (not CSS Grid) — Chromium's print engine unreliably
     fragments grid items across page breaks even with break-inside:
     avoid set. Flex-wrap respects break rules correctly. */
  .curriculum-grid {
    display: flex;
    flex-wrap: wrap;
    gap: 24px 32px;
  }

  .lesson-card {
    flex: 0 0 calc(50% - 16px);
    background: white;
    border: 1px solid #F1ECDE;
    border-top: 5px solid #F2A93B;
    border-radius: 14px;
    padding: 18px 20px 20px 20px;
    position: relative;
    break-inside: avoid;
    page-break-inside: avoid;
  }

  .lesson-number {
    position: absolute;
    top: -14px;
    right: 16px;
    background: #1B2A4A;
    color: #F2A93B;
    width: 26px;
    height: 26px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-family: 'Baloo Paaji 2', sans-serif;
    font-size: 13px;
    font-weight: 700;
  }

  .lesson-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12px;
  }

  .lesson-title {
    font-size: 16px;
    font-weight: 700;
    color: #1B2A4A;
    margin: 0;
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .micro-badge {
    font-size: 10px;
    background: #FBF7EF;
    color: #8A8270;
    padding: 4px 10px;
    border-radius: 99px;
    font-weight: 700;
    text-transform: uppercase;
    white-space: nowrap;
  }

  .section-list {
    margin: 0;
    padding: 0;
    list-style: none;
    font-size: 12px;
    color: #5C5648;
    display: flex;
    flex-wrap: wrap;
    gap: 6px;
  }

  .section-chip {
    background: #FBF7EF;
    border: 1px solid #F1ECDE;
    padding: 4px 10px;
    border-radius: 7px;
    white-space: nowrap;
  }

  /* ---------- Arcade / fun zone ---------- */
  .fun-zone {
    background: linear-gradient(135deg, #1B2A4A 0%, #12203A 100%);
    margin-top: 36px;
    padding: 26px 40px;
    border-radius: 18px;
    color: #FBF7EF;
    display: flex;
    justify-content: space-between;
    align-items: center;
    break-inside: avoid;
    page-break-inside: avoid;
  }

  .fun-zone-text h3 {
    font-size: 20px;
    font-weight: 800;
    margin: 0 0 5px 0;
    color: #F2A93B;
  }

  .fun-zone-text p {
    font-size: 13px;
    color: rgba(251, 247, 239, 0.7);
    margin: 0;
  }

  .game-container {
    display: flex;
    gap: 10px;
  }

  .game-pill {
    background: rgba(251, 247, 239, 0.08);
    padding: 8px 14px;
    border-radius: 10px;
    font-size: 12px;
    font-weight: 600;
    border: 1px solid rgba(251, 247, 239, 0.15);
    display: flex;
    align-items: center;
    gap: 6px;
    white-space: nowrap;
  }

  .game-pill span {
    color: #F2A93B;
  }

  /* ---------- Feature grid (page 2) ---------- */
  .feature-grid {
    display: flex;
    flex-wrap: wrap;
    gap: 22px 28px;
  }

  .feature-card {
    flex: 0 0 calc(50% - 14px);
    background: white;
    border: 1px solid #F1ECDE;
    border-radius: 14px;
    padding: 22px;
    break-inside: avoid;
    page-break-inside: avoid;
  }

  .feature-icon {
    width: 42px;
    height: 42px;
    border-radius: 11px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 20px;
    margin-bottom: 14px;
  }

  .feature-title {
    font-size: 15px;
    font-weight: 700;
    color: #1B2A4A;
    margin: 0 0 6px 0;
  }

  .feature-desc {
    font-size: 12.5px;
    line-height: 1.5;
    color: #5C5648;
    margin: 0;
  }

  /* ---------- CTA ---------- */
  .cta-band {
    margin-top: 36px;
    background: linear-gradient(135deg, #F2A93B 0%, #FF7A29 100%);
    border-radius: 18px;
    padding: 30px 40px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    color: #1B2A4A;
    break-inside: avoid;
    page-break-inside: avoid;
  }

  .cta-text h3 {
    font-size: 21px;
    font-weight: 800;
    margin: 0 0 4px 0;
  }

  .cta-text p {
    font-size: 13px;
    font-weight: 600;
    margin: 0;
    color: rgba(27, 42, 74, 0.75);
  }

  .cta-buttons {
    display: flex;
    gap: 10px;
  }

  .cta-button {
    background: #1B2A4A;
    color: #FBF7EF;
    padding: 11px 18px;
    border-radius: 10px;
    font-size: 12px;
    font-weight: 700;
    white-space: nowrap;
  }

  .cta-button.secondary {
    background: rgba(27, 42, 74, 0.12);
    color: #1B2A4A;
  }

  /* ---------- Footer ---------- */
  .footer-meta {
    margin-top: 24px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding-top: 16px;
    border-top: 1px solid #F1ECDE;
    color: #A39A83;
    font-size: 10px;
    font-weight: 600;
    letter-spacing: 0.4px;
    break-inside: avoid;
    page-break-inside: avoid;
  }
</style>
''';

  buffer.writeln(
    '<!DOCTYPE html><html><head><meta charset="UTF-8">$style</head><body>',
  );

  // ==================== PAGE 1 ====================
  buffer.writeln('<div class="page">');

  // ---------- Hero ----------
  buffer.writeln('<div class="hero">');
  buffer.writeln('''
    <svg class="hero-watermark" viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
      <path d="M 20 140 Q 60 40 120 60 T 180 40" fill="none" stroke="#F2A93B" stroke-width="6"
        stroke-linecap="round" stroke-dasharray="2 16"/>
      <circle cx="20" cy="140" r="7" fill="#F2A93B"/>
      <path d="M 168 34 L 180 40 L 168 46" fill="none" stroke="#F2A93B" stroke-width="6"
        stroke-linecap="round" stroke-linejoin="round"/>
    </svg>
  ''');
  buffer.writeln('  <div class="app-mark">ਅ</div>');
  buffer.writeln('  <span class="eyebrow">Punjabi • For Kids</span>');
  buffer.writeln('  <h1>GNPS Learning Hub</h1>');
  buffer.writeln('  <p class="gurmukhi-tag">ਸਿੱਖੋ, ਖੇਡੋ, ਵਧੋ</p>');
  buffer.writeln(
    '  <p class="sub-tag">Learn, Play, Grow — the Gurmukhi learning adventure for kids</p>',
  );
  buffer.writeln('</div>');

  // ---------- Stat ribbon ----------
  buffer.writeln('<div class="stat-ribbon">');
  buffer.writeln(
    '  <div class="stat-item"><span class="stat-value">${journeyData.lessons.length}</span><span class="stat-label">Levels</span></div>',
  );
  buffer.writeln(
    '  <div class="stat-item featured"><span class="stat-value">$appTotalTasks</span><span class="stat-label">Interactive Tasks</span></div>',
  );
  buffer.writeln(
    '  <div class="stat-item"><span class="stat-value">${journeyData.games.length}</span><span class="stat-label">Arcade Games</span></div>',
  );
  buffer.writeln('</div>');

  buffer.writeln('<div class="content">');

  // ---------- Curriculum heading ----------
  buffer.writeln('<div class="section-heading-row">');
  buffer.writeln('  <div class="section-heading">Curriculum Roadmap</div>');
  buffer.writeln('''
  <svg class="trace-divider" viewBox="0 0 600 14" preserveAspectRatio="none" xmlns="http://www.w3.org/2000/svg">
    <line x1="4" y1="7" x2="590" y2="7" stroke="#DCD3BC" stroke-width="2" stroke-dasharray="1 10" stroke-linecap="round"/>
    <path d="M 578 2 L 590 7 L 578 12" fill="none" stroke="#F2A93B" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
  </svg>
  ''');
  buffer.writeln('</div>');

  buffer.writeln('<div class="curriculum-grid">');

  for (var i = 0; i < journeyData.lessons.length; i++) {
    final lesson = journeyData.lessons[i];
    final icon = i < lessonIcons.length ? lessonIcons[i] : '📚';
    final accent = accentColors[i % accentColors.length];

    buffer.writeln(
      '    <div class="lesson-card" style="border-top-color: $accent;">',
    );
    buffer.writeln('      <div class="lesson-number">${i + 1}</div>');
    buffer.writeln('      <div class="lesson-header">');
    buffer.writeln(
      '        <h3 class="lesson-title">$icon ${lesson.title}</h3>',
    );
    buffer.writeln(
      '        <span class="micro-badge">${lesson.allTasks.length} tasks</span>',
    );
    buffer.writeln('      </div>');
    buffer.writeln('      <div class="section-list">');
    for (final section in lesson.sections) {
      buffer.writeln(
        '        <div class="section-chip">${section.title}</div>',
      );
    }
    buffer.writeln('      </div>');
    buffer.writeln('    </div>');
  }

  buffer.writeln('  </div>'); // End curriculum grid

  // ---------- Arcade section ----------
  buffer.writeln('  <div class="fun-zone">');
  buffer.writeln('    <div class="fun-zone-text">');
  buffer.writeln('      <h3>🕹️ Learning Arcade</h3>');
  buffer.writeln('      <p>Reinforcing concepts through gamified play.</p>');
  buffer.writeln('    </div>');
  buffer.writeln('    <div class="game-container">');
  for (final game in journeyData.games) {
    buffer.writeln(
      '      <div class="game-pill">${game.title} <span>${game.type.replaceAll("_", " ")}</span></div>',
    );
  }
  buffer.writeln('    </div>');
  buffer.writeln('  </div>');

  buffer.writeln('  <div class="footer-meta">');
  buffer.writeln(
    '    <span>Generated: ${DateTime.now().toString().split(' ')[0]}</span>',
  );
  buffer.writeln(
    '    <span>GNPS Learning Hub • Content v${journeyData.version}</span>',
  );
  buffer.writeln('    <span>Page 1 of 2</span>');
  buffer.writeln('  </div>');

  buffer.writeln('</div>'); // End content
  buffer.writeln('</div>'); // End page 1

  // ==================== PAGE 2 ====================
  buffer.writeln('<div class="page page-break">');
  buffer.writeln('<div class="content" style="padding-top: 56px;">');

  buffer.writeln(
    '  <p class="section-kicker">Designed with families in mind</p>',
  );
  buffer.writeln('<div class="section-heading-row">');
  buffer.writeln(
    '  <div class="section-heading">Why Families Choose GNPS</div>',
  );
  buffer.writeln('''
  <svg class="trace-divider" viewBox="0 0 600 14" preserveAspectRatio="none" xmlns="http://www.w3.org/2000/svg">
    <line x1="4" y1="7" x2="590" y2="7" stroke="#DCD3BC" stroke-width="2" stroke-dasharray="1 10" stroke-linecap="round"/>
    <path d="M 578 2 L 590 7 L 578 12" fill="none" stroke="#F2A93B" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
  </svg>
  ''');
  buffer.writeln('</div>');

  buffer.writeln('<div class="feature-grid">');
  for (var i = 0; i < features.length; i++) {
    final feature = features[i];
    final accent = accentColors[i % accentColors.length];
    buffer.writeln('  <div class="feature-card">');
    buffer.writeln(
      '    <div class="feature-icon" style="background: ${accent}22;">${feature['icon']}</div>',
    );
    buffer.writeln('    <h3 class="feature-title">${feature['title']}</h3>');
    buffer.writeln('    <p class="feature-desc">${feature['desc']}</p>');
    buffer.writeln('  </div>');
  }
  buffer.writeln('</div>'); // End feature grid

  // ---------- CTA ----------
  buffer.writeln('  <div class="cta-band">');
  buffer.writeln('    <div class="cta-text">');
  buffer.writeln('      <h3>Ready to begin the journey?</h3>');
  buffer.writeln('      <p>No account needed, made for young learners.</p>');
  buffer.writeln('    </div>');
  buffer.writeln('    <div class="cta-buttons">');
  buffer.writeln(
    '      <div class="cta-button">Coming Soon on Google Play</div>',
  );
  buffer.writeln(
    '      <div class="cta-button secondary">iOS — Coming Later</div>',
  );
  buffer.writeln('    </div>');
  buffer.writeln('  </div>');

  buffer.writeln('  <div class="footer-meta">');
  buffer.writeln(
    '    <span>Generated: ${DateTime.now().toString().split(' ')[0]}</span>',
  );
  buffer.writeln(
    '    <span>GNPS Learning Hub • Content v${journeyData.version}</span>',
  );
  buffer.writeln('    <span>Page 2 of 2</span>');
  buffer.writeln('  </div>');

  buffer.writeln('</div>'); // End content
  buffer.writeln('</div>'); // End page 2

  buffer.writeln('</body></html>');

  final htmlFile = File('curriculum_modern_v2_temp.html');
  await htmlFile.writeAsString(buffer.toString());

  final chrome = await _findChromeExecutable();
  if (chrome == null) {
    print(
      '❌ Could not find a Chrome/Chromium executable. Install Google '
      'Chrome or Chromium and ensure it is on PATH (or add it to the '
      'candidate list in _findChromeExecutable).',
    );
    await htmlFile.delete();
    return;
  }

  final outputPath = File('GNPS_Curriculum_Brochure_Premium.pdf').absolute.path;

  final result = await _printToPdf(chrome, outputPath, htmlFile.absolute.path);

  if (result.exitCode == 0 && await File(outputPath).exists()) {
    print('✅ Premium 2-Page Brochure generated: $outputPath');
  } else {
    print('❌ Chrome PDF generation failed: ${result.stderr}');
  }

  if (await htmlFile.exists()) await htmlFile.delete();
}
