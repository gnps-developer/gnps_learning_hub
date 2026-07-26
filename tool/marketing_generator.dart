// ignore_for_file: avoid_print
import 'dart:io';
import 'package:gnps_learning_hub/data/journey_data.dart';

/// Generates a premium, modern 1-page marketing PDF of the curriculum.
///
/// To run this tool, use:
/// ```bash
/// flutter test tool/marketing_generator.dart
/// ```
void main() async {
  print('🚀 Starting Premium Curriculum Brochure Generator...');
  await generateMarketingPdf();
}

Future<void> generateMarketingPdf() async {
  final buffer = StringBuffer();
  
  int appTotalTasks = 0;
  for (final lesson in journeyData.lessons) {
    appTotalTasks += lesson.allTasks.length;
  }

  // Icons for lesson titles
  final lessonIcons = [
    '✍️', // Tracing
    '👂', // Letter Selection
    '🔡', // Spelling
    '🖼️', // Match Picture
    '📖', // Match Words
    '✏️', // Fill in Blanks
    '🧩', // Sentence Arrangement
  ];

  // Modern CSS for a high-end 1-page brochure
  const style = '''
<style>
  @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700;800&display=swap');
  
  @page {
    size: A4;
    margin: 0;
  }

  body {
    font-family: 'Plus Jakarta Sans', sans-serif;
    color: #0f172a;
    margin: 0;
    padding: 0;
    background: #fdfdfd;
    -webkit-print-color-adjust: exact;
  }
  
  .hero {
    background: linear-gradient(135deg, #02569B 0%, #0369a1 100%);
    color: white;
    padding: 50px 60px 80px 60px;
    text-align: left;
    position: relative;
    overflow: hidden;
  }

  .hero::after {
    content: '';
    position: absolute;
    top: -50px;
    right: -50px;
    width: 200px;
    height: 200px;
    background: rgba(255, 255, 255, 0.05);
    border-radius: 50%;
  }
  
  .hero h1 {
    font-size: 42px;
    font-weight: 800;
    margin: 0;
    letter-spacing: -1.5px;
    line-height: 1;
  }
  
  .hero p {
    font-size: 20px;
    font-weight: 500;
    opacity: 0.9;
    margin: 12px 0 0 0;
  }
  
  .stats-container {
    display: flex;
    justify-content: flex-start;
    gap: 24px;
    margin-top: -50px;
    padding: 0 60px;
    position: relative;
    z-index: 10;
  }
  
  .stat-card {
    background: #ffffff;
    padding: 24px 32px;
    border-radius: 24px;
    text-align: center;
    box-shadow: 0 12px 30px rgba(0,0,0,0.08);
    border: 1px solid rgba(2, 86, 155, 0.05);
    flex: 1;
    max-width: 180px;
  }
  
  .stat-card.featured {
    background: #FFCA28;
    border: none;
  }
  
  .stat-value {
    display: block;
    font-size: 34px;
    font-weight: 800;
    color: #02569B;
    line-height: 1;
    margin-bottom: 4px;
  }
  
  .stat-label {
    font-size: 12px;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 1.2px;
    color: #64748b;
  }

  .stat-card.featured .stat-label {
    color: #02569B;
    opacity: 0.8;
  }
  
  .content {
    padding: 60px 60px 40px 60px;
  }
  
  .section-heading {
    font-size: 24px;
    font-weight: 800;
    color: #02569B;
    margin-bottom: 30px;
    display: flex;
    align-items: center;
    gap: 12px;
  }

  .section-heading::after {
    content: '';
    flex: 1;
    height: 2px;
    background: #f1f5f9;
  }
  
  .curriculum-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    column-gap: 40px;
    row-gap: 24px;
  }
  
  .lesson-card {
    background: white;
    border: 1px solid #f1f5f9;
    border-radius: 20px;
    padding: 20px;
    transition: transform 0.2s;
    position: relative;
    page-break-inside: avoid;
  }

  .lesson-number {
    position: absolute;
    top: -12px;
    left: 20px;
    background: #02569B;
    color: white;
    width: 28px;
    height: 28px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 14px;
    font-weight: 800;
    box-shadow: 0 4px 10px rgba(2, 86, 155, 0.2);
  }
  
  .lesson-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12px;
    padding-top: 5px;
  }
  
  .lesson-title {
    font-size: 17px;
    font-weight: 700;
    color: #1e293b;
    margin: 0;
    display: flex;
    align-items: center;
    gap: 8px;
  }
  
  .micro-badge {
    font-size: 10px;
    background: #f1f5f9;
    color: #64748b;
    padding: 4px 10px;
    border-radius: 99px;
    font-weight: 700;
    text-transform: uppercase;
  }
  
  .section-list {
    margin: 0;
    padding: 0;
    list-style: none;
    font-size: 13px;
    color: #475569;
    display: flex;
    flex-wrap: wrap;
    gap: 6px;
  }
  
  .section-chip {
    background: #f8fafc;
    border: 1px solid #f1f5f9;
    padding: 4px 10px;
    border-radius: 8px;
    white-space: nowrap;
  }
  
  .fun-zone {
    background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
    margin-top: 50px;
    padding: 30px 40px;
    border-radius: 24px;
    color: white;
    display: flex;
    justify-content: space-between;
    align-items: center;
    page-break-inside: avoid;
  }
  
  .fun-zone-text h3 {
    font-size: 22px;
    font-weight: 800;
    margin: 0 0 5px 0;
    color: #FFCA28;
  }
  
  .fun-zone-text p {
    font-size: 14px;
    opacity: 0.8;
    margin: 0;
  }
  
  .game-container {
    display: flex;
    gap: 12px;
  }
  
  .game-pill {
    background: rgba(255, 255, 255, 0.1);
    padding: 8px 16px;
    border-radius: 12px;
    font-size: 13px;
    font-weight: 600;
    border: 1px solid rgba(255, 255, 255, 0.1);
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .game-pill span {
    color: #FFCA28;
  }

  .footer-meta {
    margin-top: 40px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding-top: 20px;
    border-top: 1px solid #f1f5f9;
    color: #94a3b8;
    font-size: 11px;
    font-weight: 600;
  }
</style>
''';

  buffer.writeln('<!DOCTYPE html><html><head><meta charset="UTF-8">$style</head><body>');

  // Hero Section
  buffer.writeln('<div class="hero">');
  buffer.writeln('  <h1>GNPS Learning Hub</h1>');
  buffer.writeln('  <p>The Premium Punjabi Learning Adventure for Kids</p>');
  buffer.writeln('</div>');

  // Stats Row
  buffer.writeln('<div class="stats-container">');
  buffer.writeln('  <div class="stat-card"><span class="stat-value">${journeyData.lessons.length}</span><span class="stat-label">Levels</span></div>');
  buffer.writeln('  <div class="stat-card featured"><span class="stat-value">$appTotalTasks</span><span class="stat-label">Interactive Tasks</span></div>');
  buffer.writeln('  <div class="stat-card"><span class="stat-value">${journeyData.games.length}</span><span class="stat-label">Arcade Games</span></div>');
  buffer.writeln('</div>');

  buffer.writeln('<div class="content">');
  
  buffer.writeln('<div class="section-heading">Curriculum Roadmap</div>');
  buffer.writeln('<div class="curriculum-grid">');

  for (var i = 0; i < journeyData.lessons.length; i++) {
    final lesson = journeyData.lessons[i];
    final icon = i < lessonIcons.length ? lessonIcons[i] : '📚';
    
    buffer.writeln('    <div class="lesson-card">');
    buffer.writeln('      <div class="lesson-number">${i + 1}</div>');
    buffer.writeln('      <div class="lesson-header">');
    buffer.writeln('        <h3 class="lesson-title">$icon ${lesson.title}</h3>');
    buffer.writeln('        <span class="micro-badge">${lesson.allTasks.length} tasks</span>');
    buffer.writeln('      </div>');
    buffer.writeln('      <div class="section-list">');
    for (final section in lesson.sections) {
      buffer.writeln('        <div class="section-chip">${section.title}</div>');
    }
    buffer.writeln('      </div>');
    buffer.writeln('    </div>');
  }

  buffer.writeln('  </div>'); // End grid

  // Arcade Section
  buffer.writeln('  <div class="fun-zone">');
  buffer.writeln('    <div class="fun-zone-text">');
  buffer.writeln('      <h3>🕹️ Learning Arcade</h3>');
  buffer.writeln('      <p>Reinforcing concepts through gamified play.</p>');
  buffer.writeln('    </div>');
  buffer.writeln('    <div class="game-container">');
  for (final game in journeyData.games) {
    buffer.writeln('      <div class="game-pill">${game.title} <span>${game.type.replaceAll("_", " ")}</span></div>');
  }
  buffer.writeln('    </div>');
  buffer.writeln('  </div>');

  buffer.writeln('  <div class="footer-meta">');
  buffer.writeln('    <span>Generated: ${DateTime.now().toString().split(' ')[0]}</span>');
  buffer.writeln('    <span>GNPS Learning Hub • Content v${journeyData.version}</span>');
  buffer.writeln('    <span>www.gnps.edu.in</span>');
  buffer.writeln('  </div>');
  
  buffer.writeln('</div>'); // End content

  buffer.writeln('</body></html>');

  final htmlFile = File('curriculum_modern_v2_temp.html');
  await htmlFile.writeAsString(buffer.toString());
  
  final result = await Process.run('libreoffice', [
    '--headless',
    '--convert-to',
    'pdf',
    'curriculum_modern_v2_temp.html',
    '--outdir',
    '.',
  ]);

  if (result.exitCode == 0) {
    final pdfFile = File('curriculum_modern_v2_temp.pdf');
    if (await pdfFile.exists()) {
      await pdfFile.rename('GNPS_Curriculum_Brochure_Premium.pdf');
      print('✅ Premium 1-Page Brochure generated: GNPS_Curriculum_Brochure_Premium.pdf');
    }
  } else {
    print('❌ LibreOffice conversion failed: ${result.stderr}');
  }

  if (await htmlFile.exists()) await htmlFile.delete();
}
