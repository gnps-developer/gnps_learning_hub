// ignore_for_file: avoid_print
import 'brochure_engine.dart';

typedef PageAdder = void Function(String html);

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
  addPage(_heroPage(ctx, pageNum));

  // 2. Journey Spotlight
  final js = ctx.sections['journey'];
  addPage(
    _featurePage(
      ctx,
      js['badgeLabel'],
      js['title'],
      js['gurmukhiLabel'],
      js['description'],
      js['pills'],
      ctx.journeyUri,
      js['footerLabel'],
      pageNum,
    ),
  );

  // 3. Lesson Summaries (Feature Pages Only)
  final ls = ctx.sections['lessonModule'];
  var lessonIdx = 1;
  for (var i = 0; i < ctx.lessons.length; i++) {
    final lesson = ctx.lessons[i];

    final copy = ctx.lessonContent[lesson['id']]?['copy'] ?? '';
    final pills = (lesson['sections'] as List)
        .map((s) => s['title'] as String)
        .toList();

    addPage(
      _featurePage(
        ctx,
        '${ls['badgeLabel']} $lessonIdx',
        lesson['title'],
        ctx.brand['gurmukhiTagline'],
        copy,
        pills,
        ctx.lessonImages[lesson['id']],
        ls['footerLabel'],
        pageNum,
      ),
    );
    lessonIdx++;
  }

  // 4. Shop
  final ss = ctx.sections['shop'];
  addPage(
    _featurePage(
      ctx,
      ss['badgeLabel'],
      ss['title'],
      ss['gurmukhiLabel'],
      ss['description'],
      ss['pills'],
      ctx.shopUri,
      ss['footerLabel'],
      pageNum,
      variant: 'shop',
    ),
  );

  // 5. Arcade (Summary Pages Only)
  final as = ctx.sections['arcade'];
  for (final g in ctx.games) {
    final desc = as['descriptionTemplate']
        .replaceAll('{gameType}', g['type'].replaceAll('_', ' '))
        .replaceAll(
          '{unlockLesson}',
          g['unlockAfterLessonId']
              .replaceAll('lesson_', '')
              .replaceAll('_', ' '),
        );
    addPage(
      _featurePage(
        ctx,
        as['badgeLabel'],
        g['title'],
        as['gurmukhiLabel'],
        desc,
        as['pills'],
        ctx.gameImages[g['id']],
        as['footerLabel'],
        pageNum,
        variant: 'arcade',
        dark: true,
      ),
    );
  }

  // 6. Achievements
  final ach = ctx.sections['achievements'];
  addPage(
    _featurePage(
      ctx,
      ach['badgeLabel'],
      ach['title'],
      ach['gurmukhiLabel'],
      ach['description'],
      ach['pills'],
      ctx.achievementsUri,
      ach['footerLabel'],
      pageNum,
      variant: 'achievements',
    ),
  );

  // --------------------------------------------------------------------------
  // Appendix: Detailed Curriculum Content
  // --------------------------------------------------------------------------

  // Add a transition page or just start appending
  print('📚 Appending detailed curriculum pages...');

  for (var i = 0; i < ctx.lessons.length; i++) {
    final lesson = ctx.lessons[i];
    if (lesson['id'] == 'lesson_tracing') {
      _addTracingPages(ctx, lesson, addPage, () => pageNum);
    } else if (lesson['id'] == 'lesson_spelling') {
      _addSpellingPages(ctx, lesson, addPage, () => pageNum);
    } else if (lesson['id'] == 'lesson_matching_images') {
      _addMatchingImagesPages(ctx, lesson, addPage, () => pageNum);
    } else if (lesson['id'] == 'lesson_matching_words') {
      _addMatchingWordsPages(ctx, lesson, addPage, () => pageNum);
    } else if (lesson['id'] == 'lesson_fill_in_blank') {
      _addFillInBlankPages(ctx, lesson, addPage, () => pageNum);
    } else if (lesson['id'] == 'lesson_arrange_sentence') {
      _addSentencesPages(ctx, lesson, addPage, () => pageNum);
    }
  }

  for (final g in ctx.games) {
    if (g['id'] == 'crossword_punjabi') {
      _addCrosswordPages(ctx, g, addPage, () => pageNum);
    } else if (g['id'] == 'bubble_pop_words') {
      _addBubblePopWordsPages(ctx, g, addPage, () => pageNum);
    }
  }

  // 7. Closing
  pages.add(_closingPage(ctx));

  final out =
      '${BrochureEngine.findProjectRoot()}/exports/brochure/Gurmukhi_Sikho_Brochure.pdf';
  await BrochureEngine.renderPdf(
    pages: pages,
    ctx: ctx,
    outputPath: out,
    tempHtmlName: 'brochure_full_temp.html',
  );
}

// --------------------------------------------------------------------------
// Standard Page Templates
// --------------------------------------------------------------------------

String _heroPage(BrochureContext ctx, int page) {
  final logo = ctx.logoUri != null
      ? '<img src="${ctx.logoUri}" style="width: 180px; margin-bottom: 40px; border-radius: 30px; box-shadow: 0 20px 40px rgba(0,0,0,0.4);" />'
      : '';
  return '<div class="page hero-page">$logo<span class="eyebrow">${ctx.brand['eyebrow']}</span><h1 style="font-size: 64px; margin: 0;">${ctx.brand['appName']}</h1><p class="gurmukhi-tag">${ctx.brand['heroGurmukhiTagline']}</p><p class="sub-tag">${ctx.brand['heroSubtitle']}</p><div style="background: rgba(251, 247, 239, 0.05); padding: 40px; border-radius: 30px; border: 1px solid rgba(251, 247, 239, 0.1); margin-top: 40px;"><p style="font-size: 20px; font-weight: 500; margin: 0;">${ctx.brand['coverSubtitle']}</p><p style="font-size: 14px; opacity: 0.6; margin-top: 10px;">${ctx.brand['coverVersionLabel']} • CONTENT V${ctx.version}</p></div><div class="footer hero-footer"><span>${ctx.brand['appName']}</span><span>Developed by ${ctx.brand['developer']}</span></div></div>';
}

String _featurePage(
  BrochureContext ctx,
  String badge,
  String title,
  String gurmukhi,
  String desc,
  dynamic pills,
  String? img,
  String footer,
  int page, {
  String variant = '',
  bool dark = false,
}) {
  final alt = page % 2 != 0;
  final cls =
      'page feature-page ${dark ? "dark-section" : ""} ${alt ? "alt" : ""}';
  final imgBlock = img == null
      ? ''
      : '<div class="image-side"><div class="phone-mockup $variant"><div class="phone-screen"><img src="$img" /></div></div></div>';
  final pillsHtml = (pills as List)
      .map((l) => '<div class="pill $variant">$l</div>')
      .join();
  return '<div class="$cls"><div class="text-side"><span class="badge $variant">$badge</span><h2 style="font-size: 38px; margin: 0;">$title</h2><p class="title-gurmukhi $variant">$gurmukhi</p><p class="description">$desc</p><div class="pill-container">$pillsHtml</div></div>$imgBlock<div class="${dark ? "footer hero-footer" : "footer"}"><span>$footer</span><span>PAGE $page</span></div></div>';
}

String _closingPage(BrochureContext ctx) {
  final fn = ctx.sections['finalNotes'];
  final badges = (fn['platforms'] as List)
      .map(
        (p) =>
            '<div class="store-badge ${p['status'].toString().toLowerCase().contains('available') ? 'available' : 'soon'}"><div class="store-badge-icon">${BrochureEngine.storeBadgeIcon(p['icon'])}</div><div class="store-badge-text"><span class="store-badge-status">${p['status']}</span><span class="store-badge-name">${p['name']}</span></div></div>',
      )
      .join();
  return '<div class="page closing-page"><h1 style="font-size: 52px; margin: 0;">${fn['title']}</h1><p class="closing-subtitle">${fn['subtitle'] ?? ""}</p><p class="gurmukhi-tag" style="margin: 16px 0 20px 0;">${fn['gurmukhiLabel']}</p><p style="font-size: 19px; line-height: 1.6; max-width: 640px; color: rgba(251, 247, 239, 0.8);">${fn['message']}</p><div class="store-badges">$badges</div>${BrochureEngine.qrBlock(fn['googlePlayUrl'], fn['qrCaption'])}<div class="footer hero-footer"><span>${fn['footerLabel']}</span><span>${ctx.brand['appName']}</span></div></div>';
}

// --------------------------------------------------------------------------
// Curriculum Detail Generators
// --------------------------------------------------------------------------

void _addTracingPages(
  BrochureContext ctx,
  Map<String, dynamic> lesson,
  void Function(String) addPage,
  int Function() getPageNum,
) {
  final tasks = (lesson['sections'] as List)
      .expand((s) => s['tasks'] as List)
      .toList();
  final tiles = tasks.map((t) {
    final content = t['content'] as Map<String, dynamic>;
    return BrochureEngine.tracingLetterSvg(
      content['letter'],
      content['checkpoints'],
    );
  }).join();

  addPage(
    BrochureEngine.contentPage(
      title: 'Tracing',
      subtitle: 'Step-by-step tracing for all 35 Gurmukhi alphabets',
      bodyHtml: '<div class="content-grid tracing">$tiles</div>',
      footerLeft: 'ALPHABET REFERENCE',
      pageNum: getPageNum(),
    ),
  );
}

void _addSpellingPages(
  BrochureContext ctx,
  Map<String, dynamic> lesson,
  void Function(String) addPage,
  int Function() getPageNum,
) {
  final tasks = (lesson['sections'] as List)
      .expand((s) => s['tasks'] as List)
      .toList();
  final uniqueItems = <String, String>{};
  for (final t in tasks) {
    final c = t['content'] as Map<String, dynamic>;
    uniqueItems[c['targetWord']] = c['emoji'];
  }

  _paginate(
    uniqueItems.entries.toList(),
    20,
    getPageNum,
    addPage,
    (chunk) {
      return chunk.map((e) {
        return '<div class="content-tile"><span class="tile-emoji">${e.value}</span><span class="tile-text">${e.key}</span></div>';
      }).join();
    },
    'Word Building',
    'Master spelling with essential Punjabi words',
    'VOCABULARY LIST',
  );
}

void _addMatchingImagesPages(
  BrochureContext ctx,
  Map<String, dynamic> lesson,
  void Function(String) addPage,
  int Function() getPageNum,
) {
  final tasks = (lesson['sections'] as List)
      .expand((s) => s['tasks'] as List)
      .toList();
  final uniqueItems = <String, String>{};
  for (final t in tasks) {
    final c = t['content'] as Map<String, dynamic>;
    uniqueItems[c['word']] = c['correctEmoji'];
  }

  _paginate(
    uniqueItems.entries.toList(),
    20,
    getPageNum,
    addPage,
    (chunk) {
      return chunk.map((e) {
        return '<div class="content-tile"><span class="tile-emoji">${e.value}</span><span class="tile-text">${e.key}</span></div>';
      }).join();
    },
    'Visual Vocabulary',
    'Connecting images to Gurmukhi script',
    'PICTURE MATCHING',
  );
}

void _addMatchingWordsPages(
  BrochureContext ctx,
  Map<String, dynamic> lesson,
  void Function(String) addPage,
  int Function() getPageNum,
) {
  final tasks = (lesson['sections'] as List)
      .expand((s) => s['tasks'] as List)
      .toList();
  final allPairs = <String, String>{};
  for (final t in tasks) {
    final pairs = t['content']['pairs'] as Map<String, dynamic>;
    allPairs.addAll(pairs.cast<String, String>());
  }

  _paginate(
    allPairs.entries.toList(),
    24,
    getPageNum,
    addPage,
    (chunk) {
      return chunk
          .map(
            (e) =>
                '<div class="content-tile"><span class="tile-text">${e.key}</span><span class="tile-sub">${e.value}</span></div>',
          )
          .join();
    },
    'Word Recognition',
    'Building reading confidence through repetition',
    'READING PRACTICE',
  );
}

void _addFillInBlankPages(
  BrochureContext ctx,
  Map<String, dynamic> lesson,
  void Function(String) addPage,
  int Function() getPageNum,
) {
  final tasks = (lesson['sections'] as List)
      .expand((s) => s['tasks'] as List)
      .toList();
  final uniqueWords = <String>{};
  for (final t in tasks) {
    final content = t['content'] as Map<String, dynamic>;
    if (content.containsKey('correctWord')) {
      uniqueWords.add(content['correctWord'] as String);
    }
  }

  _paginate(
    uniqueWords.toList()..sort(),
    24,
    getPageNum,
    addPage,
    (chunk) {
      return chunk
          .map(
            (w) =>
                '<div class="content-tile"><span class="tile-text">$w</span></div>',
          )
          .join();
    },
    'Contextual Learning',
    'Completing words within real-world contexts',
    'FILL IN THE BLANKS',
  );
}

void _addSentencesPages(
  BrochureContext ctx,
  Map<String, dynamic> lesson,
  void Function(String) addPage,
  int Function() getPageNum,
) {
  final tasks = (lesson['sections'] as List)
      .expand((s) => s['tasks'] as List)
      .toList();
  _paginate(
    tasks,
    10,
    getPageNum,
    addPage,
    (chunk) {
      return chunk
          .map(
            (t) =>
                '<div class="content-tile sentence-tile"><span class="tile-text">${t['content']['fullSentence']}</span></div>',
          )
          .join();
    },
    'Sentence Construction',
    'Building complex thoughts from single words',
    'CONVERSATIONAL PUNJABI',
    gridClass: 'sentences',
  );
}

void _addCrosswordPages(
  BrochureContext ctx,
  Map<String, dynamic> game,
  void Function(String) addPage,
  int Function() getPageNum,
) {
  final allWords = <String, String>{};
  for (final level in (game['content']['levels'] as List)) {
    for (final w in (level['words'] as List)) {
      allWords[w['answer']] = w['hint'] ?? '';
    }
  }

  _paginate(
    allWords.entries.toList(),
    24,
    getPageNum,
    addPage,
    (chunk) {
      return chunk
          .map(
            (e) =>
                '<div class="content-tile"><span class="tile-text">${e.key}</span><span class="tile-sub">${e.value}</span></div>',
          )
          .join();
    },
    'Crossword Challenges',
    'Reinforcing vocabulary through logic puzzles',
    'GAME VOCABULARY',
    dark: true,
  );
}

void _addBubblePopWordsPages(
  BrochureContext ctx,
  Map<String, dynamic> game,
  PageAdder addPage,
  int Function() getPageNum,
) {
  final allWords = (game['content']['itemPool'] as Map).keys.toList();
  _paginate(
    allWords..sort(),
    24,
    getPageNum,
    addPage,
    (chunk) {
      return chunk
          .map(
            (w) =>
                '<div class="content-tile"><span class="tile-text">$w</span></div>',
          )
          .join();
    },
    'Arcade: Bubble Pop',
    'Dynamic word identification under pressure',
    'GAME VOCABULARY',
    dark: true,
  );
}

// --------------------------------------------------------------------------
// Pagination Utility
// --------------------------------------------------------------------------

void _paginate<T>(
  List<T> items,
  int perPage,
  int Function() getPageNum,
  PageAdder addPage,
  String Function(List<T>) renderer,
  String title,
  String subtitle,
  String footer, {
  String gridClass = '',
  bool dark = false,
}) {
  for (var i = 0; i < items.length; i += perPage) {
    final chunk = items.sublist(
      i,
      (i + perPage) > items.length ? items.length : i + perPage,
    );
    addPage(
      BrochureEngine.contentPage(
        title: title,
        subtitle: subtitle,
        bodyHtml:
            '<div class="content-grid $gridClass">${renderer(chunk)}</div>',
        footerLeft: footer,
        pageNum: getPageNum(),
        dark: dark,
      ),
    );
  }
}
