/// Models for the crossword game's JSON content.
///
/// Schema notes (vs. the earlier version):
///  - Levels now carry `gridWidth`/`gridHeight` (a tight rectangular bounding
///    box) instead of a single square `gridSize`. `gridSize` is still read
///    as a fallback for any old level data that hasn't been regenerated.
///  - Each word can carry a clue `number` (real-crossword-style numbering,
///    shared across an Across/Down pair that starts on the same cell) and a
///    `hint` (short English gloss).
///  - `itemPool` entries can be either the old plain audio-path string, or
///    the new `{ "audio": ..., "hint": ... }` object. Both are accepted.
library;

class CrosswordWord {
  final int? number;
  final String answer;
  final List<String> syllables;
  final int row;
  final int col;
  final bool isHorizontal;
  final String hint;
  bool revealed;

  CrosswordWord({
    this.number,
    required this.answer,
    required this.syllables,
    required this.row,
    required this.col,
    required this.isHorizontal,
    this.hint = '',
    this.revealed = false,
  });

  factory CrosswordWord.fromJson(Map<String, dynamic> json) {
    return CrosswordWord(
      number: json['number'] as int?,
      answer: json['answer'] as String,
      syllables: List<String>.from(json['syllables'] as List),
      row: json['row'] as int,
      col: json['col'] as int,
      isHorizontal: json['isHorizontal'] as bool,
      hint: json['hint'] as String? ?? '',
    );
  }
}

class CrosswordLevel {
  final int levelNumber;
  final int gridWidth;
  final int gridHeight;
  final List<CrosswordWord> words;
  final List<String> dialLetters;

  /// Kept for any screen still reading a single grid dimension
  /// (e.g. legacy centering code). Uses the larger of the two axes.
  int get gridSize => gridWidth > gridHeight ? gridWidth : gridHeight;

  CrosswordLevel({
    required this.levelNumber,
    required this.gridWidth,
    required this.gridHeight,
    required this.words,
    required this.dialLetters,
  });

  factory CrosswordLevel.fromJson(Map<String, dynamic> json) {
    // Fallback to old square `gridSize` if the new fields aren't present.
    final legacySize = json['gridSize'] as int?;
    return CrosswordLevel(
      levelNumber: json['levelNumber'] as int,
      gridWidth: json['gridWidth'] as int? ?? legacySize ?? 7,
      gridHeight: json['gridHeight'] as int? ?? legacySize ?? 7,
      words: (json['words'] as List)
          .map((w) => CrosswordWord.fromJson(w as Map<String, dynamic>))
          .toList(),
      dialLetters: List<String>.from(json['dialLetters'] as List),
    );
  }
}

class CrosswordItem {
  final String audio;
  final String hint;

  const CrosswordItem({required this.audio, this.hint = ''});

  factory CrosswordItem.fromDynamic(dynamic value) {
    // Old schema: itemPool[word] was just the audio path string.
    if (value is String) {
      return CrosswordItem(audio: value);
    }
    final map = value as Map<String, dynamic>;
    return CrosswordItem(
      audio: map['audio'] as String? ?? '',
      hint: map['hint'] as String? ?? '',
    );
  }
}

class CrosswordData {
  final List<CrosswordLevel> levels;
  final Map<String, CrosswordItem> itemPool;
  final int winBonusPoints;

  CrosswordData({
    required this.levels,
    required this.itemPool,
    required this.winBonusPoints,
  });

  factory CrosswordData.fromJson(Map<String, dynamic> json) {
    final levelsJson = json['levels'] as List;
    final poolJson = (json['itemPool'] as Map<String, dynamic>?) ?? {};
    return CrosswordData(
      levels: levelsJson
          .map((l) => CrosswordLevel.fromJson(l as Map<String, dynamic>))
          .toList(),
      itemPool: poolJson.map(
            (k, v) => MapEntry(k, CrosswordItem.fromDynamic(v)),
      ),
      winBonusPoints: json['winBonusPoints'] as int? ?? 20,
    );
  }
}