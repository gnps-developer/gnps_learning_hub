// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
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

  print('📚 Appending detailed intro...');
  addPage(_appendixIntroPage(ctx, pageNum));

  // Add a transition page or just start appending
  print('📚 Appending detailed curriculum pages...');

  for (var i = 0; i < ctx.lessons.length; i++) {
    final lesson = ctx.lessons[i];
    if (lesson['id'] == 'lesson_tracing') {
      _addTracingPages(ctx, lesson, addPage, () => pageNum);
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
    } else if (g['id'] == 'bubble_pop_words' || g['id'] == 'bubble_pop_letters') {
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

  String pillsHtml;
  if (pills is Map<String, List<String>>) {
    final sectionsHtml = <String>[];
    pills.forEach((heading, list) {
      final isGame =
          heading.toLowerCase().contains('game') ||
          heading.toLowerCase().contains('arcade');
      final pillClass = isGame ? 'arcade' : variant;
      sectionsHtml.add(
        '<div style="margin-top: 16px; width: 100%;"><h4 style="margin: 0 0 8px 0; font-size: 14px; text-transform: uppercase; letter-spacing: 0.05em; color: var(--color-text-muted);">$heading</h4><div class="pill-container">${list.map((l) => '<div class="pill $pillClass">$l</div>').join()}</div></div>',
      );
    });
    pillsHtml = sectionsHtml.join();
  } else {
    pillsHtml =
        '<div class="pill-container">${(pills as List).map((l) => '<div class="pill $variant">$l</div>').join()}</div>';
  }

  return '<div class="$cls"><div class="text-side"><span class="badge $variant">$badge</span><h2 style="font-size: 38px; margin: 0;">$title</h2><p class="title-gurmukhi $variant">$gurmukhi</p><p class="description">$desc</p>$pillsHtml</div>$imgBlock<div class="${dark ? "footer hero-footer" : "footer"}"><span>$footer</span><span>PAGE $page</span></div></div>';
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

String _appendixIntroPage(BrochureContext ctx, int page) {
  final groupedPills = {
    'Lessons': ctx.lessons.map((l) => l['title'] as String).toList(),
    'Arcade Games': ctx.games.map((g) => g['title'] as String).toList(),
  };

  return _featurePage(
    ctx,
    'Appendix',
    'Curriculum Reference',
    ctx.brand['gurmukhiTagline'] ?? '',
    'The following pages contain the complete, detailed contents of every lesson and game in ${ctx.brand['appName']} — the full alphabet reference, vocabulary lists, matching pairs, sentences, and in-game word banks used throughout the learning journey.',
    groupedPills,
    null,
    'CURRICULUM REFERENCE',
    page,
  );
}

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

void _addMatchingImagesPages(
  BrochureContext ctx,
  Map<String, dynamic> lesson,
  void Function(String) addPage,
  int Function() getPageNum,
) {
  final root = BrochureEngine.findProjectRoot();
  final referenceFile = File('$root/assets/data/emoji_reference.json');
  final Map<String, dynamic> emojiReference = jsonDecode(
    referenceFile.readAsStringSync(),
  );

  final tasks = (lesson['sections'] as List)
      .expand((s) => s['tasks'] as List)
      .toList();

  final uniqueItems = <String, String>{};
  for (final t in tasks) {
    final c = t['content'] as Map<String, dynamic>;
    final word = c['word'] as String;
    // Source emoji dynamically from master reference file, with fallback if missing
    uniqueItems[word] = (emojiReference[word] ?? c['correctEmoji']) as String;
  }

  _paginate(
    uniqueItems.entries.toList(),
    32,
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
    36,
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

  _paginate(
    tasks,
    16,
    getPageNum,
    addPage,
    (chunk) {
      return chunk.map((t) {
        final content = t['content'] as Map<String, dynamic>;
        final sentence = (content['sentenceParts'] as List).join(' ');
        final correct = content['correctWord'] as String;
        final options = (content['options'] as List).cast<String>();

        final optionsHtml = options.map((opt) {
          final isCorrect = opt == correct;
          final style = isCorrect
              ? 'background: #E8F5E9; color: #2E7D32; border: 1px solid #A5D6A7; font-weight: 700;'
              : 'background: #F5F5F5; color: #616161; border: 1px solid #E0E0E0;';
          return '<span style="padding: 5px 12px; border-radius: 8px; font-size: 15px; $style">$opt</span>';
        }).join(' ');

        return '''
        <div class="content-tile" style="align-items: flex-start; text-align: left; padding: 18px; width: 100%;">
          <span class="tile-text" style="font-size: 21px; margin-bottom: 10px; width: 100%; line-height: 1.4;">$sentence</span>
          <div style="display: flex; gap: 10px; flex-wrap: wrap;">$optionsHtml</div>
        </div>
        ''';
      }).join();
    },
    'Fill in the Blanks',
    'Completing words within real-world contexts',
    'FILL IN THE BLANKS',
    gridClass: 'two-columns',
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
    14,
    getPageNum,
    addPage,
    (chunk) {
      return chunk.map((t) {
        final content = t['content'] as Map<String, dynamic>;
        final words = (content['words'] as List).cast<String>();
        final order = (content['correctOrder'] as List).cast<int>();
        
        // Reconstruct full correct sentence from indices
        final orderedWords = order.map((idx) => words[idx]).toList();
        final fullSentence = orderedWords.join(' ');

        return '''
        <div class="content-tile" style="align-items: flex-start; text-align: left; padding: 18px; width: 100%;">
          <span class="tile-text" style="font-size: 21px; margin-bottom: 10px; width: 100%; line-height: 1.4;">$fullSentence</span>
          <div style="display: flex; gap: 8px; flex-wrap: wrap;">
            ${words.map((w) => '<span style="background: #F5F5F5; color: #4A4439; border: 1px solid #E0E0E0; padding: 4px 10px; border-radius: 8px; font-size: 13px;">$w</span>').join(' ')}
          </div>
        </div>
        ''';
      }).join();
    },
    'Sentence Construction',
    'Building complex thoughts from single words',
    'CONVERSATIONAL PUNJABI',
    gridClass: 'two-columns',
  );
}

void _addCrosswordPages(
  BrochureContext ctx,
  Map<String, dynamic> game,
  void Function(String) addPage,
  int Function() getPageNum,
) {
  final levels = game['content']['levels'] as List;

  // Show exactly 1 crossword puzzle per page
  for (var i = 0; i < levels.length; i++) {
    final lvl = levels[i];
    final levelNum = lvl['levelNumber'] as int;
    final w = lvl['gridWidth'] as int;
    final h = lvl['gridHeight'] as int;
    final levelWords = lvl['words'] as List;
    
    // 1. Build a logical grid to render
    final cellMap = <String, Map<String, dynamic>>{};
    final acrossClues = <String>[];
    final downClues = <String>[];

    // 2. Dynamic style configuration
    final isCompact = levelNum >= 5;
    final cellSize = isCompact ? 62 : 70;
    final letterSize = isCompact ? 28 : 32;
    final numSize = isCompact ? 14 : 16;
    final clueFontSize = isCompact ? 18 : 20;
    final gridGap = 2;

    for (final wordObj in levelWords) {
      final syllables = wordObj['syllables'] as List;
      final startR = wordObj['row'] as int;
      final startC = wordObj['col'] as int;
      final isH = wordObj['isHorizontal'] as bool;
      final num = wordObj['number'] as int;
      final hint = wordObj['hint'] as String;

      final clue = '<li class="clue-item" style="font-size: ${clueFontSize}px;"><span class="clue-number" style="font-size: ${clueFontSize}px;">$num.</span> $hint</li>';
      if (isH) {
        acrossClues.add(clue);
      } else {
        downClues.add(clue);
      }

      for (var sIdx = 0; sIdx < syllables.length; sIdx++) {
        final r = isH ? startR : startR + sIdx;
        final c = isH ? startC + sIdx : startC;
        final key = '$r,$c';
        
        final cell = cellMap[key] ?? {};
        cell['char'] = syllables[sIdx];
        if (sIdx == 0) cell['num'] = num;
        cellMap[key] = cell;
      }
    }

    // 3. Generate HTML Grid Table
    final gridHtml = StringBuffer();
    gridHtml.writeln('<div class="crossword-html-grid" style="grid-template-columns: repeat($w, 1fr); width: ${w * (cellSize + gridGap)}px; gap: ${gridGap}px;">');
    for (var r = 1; r <= h; r++) {
      for (var c = 1; c <= w; c++) {
        final cell = cellMap['$r,$c'];
        if (cell != null) {
          final numLabel = cell.containsKey('num') ? '<span class="crossword-cell-number" style="font-size: ${numSize}px; top: ${isCompact ? 3 : 5}px; left: ${isCompact ? 5 : 8}px;">${cell['num']}</span>' : '';
          gridHtml.writeln('<div class="crossword-cell filled" style="width: ${cellSize}px; height: ${cellSize}px; border-radius: ${isCompact ? 5 : 8}px;">$numLabel<span class="crossword-cell-letter" style="font-size: ${letterSize}px;">${cell['char']}</span></div>');
        } else {
          gridHtml.writeln('<div class="crossword-cell empty" style="width: ${cellSize}px; height: ${cellSize}px;"></div>');
        }
      }
    }
    gridHtml.writeln('</div>');

    final html = '''
    <div class="crossword-container" style="align-items: center;">
      <h3 style="color: #F2A93B; margin: 0 0 ${isCompact ? 12 : 24}px 0; font-size: ${isCompact ? 26 : 32}px; text-align: center; width: 100%;">Level $levelNum Puzzle</h3>
      
      <div class="crossword-grid-wrapper" style="margin-bottom: ${isCompact ? 24 : 40}px; padding: ${isCompact ? 14 : 20}px;">$gridHtml</div>
      
      <div class="crossword-clues" style="display: flex; flex-direction: column; gap: ${isCompact ? 14 : 20}px; width: 100%; border-top: 1px solid rgba(255,255,255,0.1); padding-top: ${isCompact ? 16 : 24}px;">
        <div class="clues-column">
          <h4 style="font-size: ${isCompact ? 15 : 18}px; margin-bottom: ${isCompact ? 6 : 12}px; color: #F2A93B;">Across</h4>
          <ul class="clues-list" style="display: grid; grid-template-columns: repeat(4, 1fr); gap: ${isCompact ? 4 : 8}px;">${acrossClues.join()}</ul>
        </div>
        <div class="clues-column">
          <h4 style="font-size: ${isCompact ? 15 : 18}px; margin-bottom: ${isCompact ? 6 : 12}px; color: #F2A93B;">Down</h4>
          <ul class="clues-list" style="display: grid; grid-template-columns: repeat(4, 1fr); gap: ${isCompact ? 4 : 8}px;">${downClues.join()}</ul>
        </div>
      </div>
    </div>
    ''';

    addPage(
      BrochureEngine.contentPage(
        title: 'Crossword Challenges',
        subtitle: 'Vocabulary reinforcement through logic puzzles',
        bodyHtml: html,
        footerLeft: 'ARCADE MODULE',
        pageNum: getPageNum(),
        dark: true,
      ),
    );
  }
}

void _addBubblePopWordsPages(
  BrochureContext ctx,
  Map<String, dynamic> game,
  PageAdder addPage,
  int Function() getPageNum,
) {
  final itemPool = game['content']['itemPool'] as Map;
  final allItems = itemPool.keys.toList(); // Keep original ordering or standard sorting

  final isLetters = game['id'] == 'bubble_pop_letters';

  _paginate(
    allItems,
    isLetters ? 40 : 28,
    getPageNum,
    addPage,
    (chunk) {
      return chunk.map((item) {
        return '''
        <div class="content-tile" style="background: transparent; box-shadow: none; padding: 4px;">
          <div class="bubble-item">
            <span class="bubble-text">$item</span>
          </div>
        </div>
        ''';
      }).join();
    },
    isLetters ? 'Arcade: Letter Bubbles' : 'Arcade: Word Bubbles',
    isLetters ? 'Pop alphabet bubble characters to verify letters' : 'Dynamic word identification inside active bubble flows',
    'GAME VOCABULARY',
    gridClass: isLetters ? 'bubble-letters' : '',
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
