// ignore_for_file: avoid_print
import 'dart:io';
import 'brochure_engine.dart';

void main() async {
  print('🚀 Starting Premium Brochure Generator...');
  final ctx = await BrochureEngine.loadContext();
  final pages = <String>[];
  var pageNum = 1;

  void addPage(String html) {
    pages.add(html);
    pageNum++;
  }

  // 1. Hero
  addPage(_heroPage(ctx));

  // 2. Journey
  final js = ctx.sections['journey'];
  addPage(_featurePage(ctx, js['badgeLabel'], js['title'], js['gurmukhiLabel'], js['description'], js['pills'], ctx.journeyUri, js['footerLabel'], pageNum));

  // 3. Lessons
  final ls = ctx.sections['lessonModule'];
  for (var i = 0; i < ctx.lessons.length; i++) {
    final lesson = ctx.lessons[i];
    final copy = ctx.lessonContent[lesson['id']]?['copy'] ?? '';
    final pills = (lesson['sections'] as List).map((s) => s['title'] as String).toList();
    addPage(_featurePage(ctx, '${ls['badgeLabel']} ${i+1}', lesson['title'], ctx.brand['gurmukhiTagline'], copy, pills, ctx.lessonImages[lesson['id']], ls['footerLabel'], pageNum));
  }

  // 4. Shop
  final ss = ctx.sections['shop'];
  addPage(_featurePage(ctx, ss['badgeLabel'], ss['title'], ss['gurmukhiLabel'], ss['description'], ss['pills'], ctx.shopUri, ss['footerLabel'], pageNum, variant: 'shop'));

  // 5. Arcade
  final as = ctx.sections['arcade'];
  for (final g in ctx.games) {
    final desc = as['descriptionTemplate'].replaceAll('{gameType}', g['type'].replaceAll('_', ' ')).replaceAll('{unlockLesson}', g['unlockAfterLessonId'].replaceAll('lesson_', '').replaceAll('_', ' '));
    addPage(_featurePage(ctx, as['badgeLabel'], g['title'], as['gurmukhiLabel'], desc, as['pills'], ctx.gameImages[g['id']], as['footerLabel'], pageNum, variant: 'arcade', dark: true));
  }

  // 6. Achievements
  final ach = ctx.sections['achievements'];
  addPage(_featurePage(ctx, ach['badgeLabel'], ach['title'], ach['gurmukhiLabel'], ach['description'], ach['pills'], ctx.achievementsUri, ach['footerLabel'], pageNum, variant: 'achievements'));

  // 7. Closing
  pages.add(_closingPage(ctx));

  final out = '${BrochureEngine.findProjectRoot()}/exports/brochure/Gurmukhi_Sikho_Brochure.pdf';
  await BrochureEngine.renderPdf(pages: pages, ctx: ctx, outputPath: out, tempHtmlName: 'brochure_full_temp.html');
}

String _heroPage(BrochureContext ctx) {
  final logo = ctx.logoUri != null ? '<img src="${ctx.logoUri}" style="width: 180px; margin-bottom: 40px; border-radius: 30px; box-shadow: 0 20px 40px rgba(0,0,0,0.4);" />' : '';
  return '<div class="page hero-page">$logo<span class="eyebrow">${ctx.brand['eyebrow']}</span><h1 style="font-size: 64px; margin: 0;">${ctx.brand['appName']}</h1><p class="gurmukhi-tag">${ctx.brand['heroGurmukhiTagline']}</p><p class="sub-tag">${ctx.brand['heroSubtitle']}</p><div style="background: rgba(251, 247, 239, 0.05); padding: 40px; border-radius: 30px; border: 1px solid rgba(251, 247, 239, 0.1); margin-top: 40px;"><p style="font-size: 20px; font-weight: 500; margin: 0;">${ctx.brand['coverSubtitle']}</p><p style="font-size: 14px; opacity: 0.6; margin-top: 10px;">${ctx.brand['coverVersionLabel']} • CONTENT V${ctx.version}</p></div><div class="footer hero-footer"><span>${ctx.brand['appName']}</span><span>Developed by ${ctx.brand['developer']}</span></div></div>';
}

String _featurePage(BrochureContext ctx, String badge, String title, String gurmukhi, String desc, dynamic pills, String? img, String footer, int page, {String variant = '', bool dark = false}) {
  final alt = page % 2 != 0;
  final cls = 'page feature-page ${dark ? "dark-section" : ""} ${alt ? "alt" : ""}';
  final imgBlock = img == null ? '' : '<div class="image-side"><div class="phone-mockup ${variant}"><div class="phone-screen"><img src="$img" /></div></div></div>';
  final pillsHtml = (pills as List).map((l) => '<div class="pill $variant">$l</div>').join();
  return '<div class="$cls"><div class="text-side"><span class="badge $variant">$badge</span><h2 style="font-size: 38px; margin: 0;">$title</h2><p class="title-gurmukhi $variant">$gurmukhi</p><p class="description">$desc</p><div class="pill-container">$pillsHtml</div></div>$imgBlock<div class="${dark ? "footer hero-footer" : "footer"}"><span>$footer</span><span>PAGE $page</span></div></div>';
}

String _closingPage(BrochureContext ctx) {
  final fn = ctx.sections['finalNotes'];
  final badges = (fn['platforms'] as List).map((p) => '<div class="store-badge ${p['status'].toString().toLowerCase().contains('available') ? 'available' : 'soon'}"><div class="store-badge-icon">${BrochureEngine.storeBadgeIcon(p['icon'])}</div><div class="store-badge-text"><span class="store-badge-status">${p['status']}</span><span class="store-badge-name">${p['name']}</span></div></div>').join();
  return '<div class="page closing-page"><h1 style="font-size: 52px; margin: 0;">${fn['title']}</h1><p class="closing-subtitle">${fn['subtitle'] ?? ""}</p><p class="gurmukhi-tag" style="margin: 16px 0 20px 0;">${fn['gurmukhiLabel']}</p><p style="font-size: 19px; line-height: 1.6; max-width: 640px; color: rgba(251, 247, 239, 0.8);">${fn['message']}</p><div class="store-badges">$badges</div>${BrochureEngine.qrBlock(fn['googlePlayUrl'], fn['qrCaption'])}<div class="footer hero-footer"><span>${fn['footerLabel']}</span><span>${ctx.brand['appName']}</span></div></div>';
}
