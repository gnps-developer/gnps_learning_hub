// ignore_for_file: avoid_print
import 'dart:io';
import 'brochure_engine.dart';

void main() async {
  print('🚀 Starting One-Pager Flyer Generator...');
  final ctx = await BrochureEngine.loadContext();
  final op = ctx.sections['onePager'];
  final fn = ctx.sections['finalNotes'];

  if (op == null) {
    print('⚠️ No "onePager" section found - skipping.');
    return;
  }

  final logo = ctx.logoUri != null ? '<img src="${ctx.logoUri}" alt="${ctx.brand['appName']} Logo" />' : '';
  final imgBlock = ctx.journeyUri == null ? '' : '<div class="onepager-image"><div class="phone-mockup"><div class="phone-screen"><img src="${ctx.journeyUri}" alt="App Preview" /></div></div></div>';
  final badges = (fn['platforms'] as List).map((p) => '<div class="store-badge ${p['status'].toString().toLowerCase().contains('available') ? 'available' : 'soon'}" style="padding: 10px 16px; width: 210px; gap: 10px;"><div class="store-badge-icon" style="width: 24px; height: 24px;">${BrochureEngine.storeBadgeIcon(p['icon'])}</div><div class="store-badge-text"><span class="store-badge-status" style="font-size: 9px;">${p['status']}</span><span class="store-badge-name" style="font-size: 15px;">${p['name']}</span></div></div>').join();

  final page = '''
<div class="page onepager-page">
  <div class="onepager-header">
    $logo
    <div class="onepager-header-text">
      <h1>${ctx.brand['appName']}</h1>
      <span class="onepager-subtitle">${fn['subtitle'] ?? ""}</span>
    </div>
  </div>
  <div class="onepager-body">
    <div class="onepager-text">
      <p class="gurmukhi-tag">${op['gurmukhiLabel']}</p>
      <p class="description">${op['shortDescription']}</p>
      <div class="store-badges" style="margin-top: 24px; justify-content: flex-start; gap: 16px;">$badges</div>
      <div class="onepager-footer-row">${BrochureEngine.qrBlock(fn['googlePlayUrl'], fn['qrCaption'])}</div>
    </div>
    $imgBlock
  </div>
  <div class="footer hero-footer"><span>${op['footerLabel']}</span><span>${ctx.brand['appName']}</span></div>
</div>''';

  final out = '${BrochureEngine.findProjectRoot()}/exports/brochure/Gurmukhi_Sikho_OnePager.pdf';
  await BrochureEngine.renderPdf(pages: [page], ctx: ctx, outputPath: out, tempHtmlName: 'flyer_temp.html');
}
