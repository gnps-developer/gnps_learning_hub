class CrosswordWord {
  final String answer;
  final List<String> syllables;
  final int row;
  final int col;
  final bool isHorizontal;
  bool revealed;

  CrosswordWord({
    required this.answer,
    required this.syllables,
    required this.row,
    required this.col,
    required this.isHorizontal,
    this.revealed = false,
  });

  factory CrosswordWord.fromJson(Map<String, dynamic> json) {
    return CrosswordWord(
      answer: json['answer'] as String,
      syllables: List<String>.from(json['syllables'] as List),
      row: json['row'] as int,
      col: json['col'] as int,
      isHorizontal: json['isHorizontal'] as bool,
      revealed: json['revealed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'answer': answer,
        'syllables': syllables,
        'row': row,
        'col': col,
        'isHorizontal': isHorizontal,
        'revealed': revealed,
      };
}

class CrosswordLevel {
  final int levelNumber;
  final int gridSize;
  final List<CrosswordWord> words;
  final List<String> dialLetters;

  CrosswordLevel({
    required this.levelNumber,
    required this.gridSize,
    required this.words,
    required this.dialLetters,
  });

  factory CrosswordLevel.fromJson(Map<String, dynamic> json) {
    return CrosswordLevel(
      levelNumber: json['levelNumber'] as int? ?? 1,
      gridSize: json['gridSize'] as int? ?? 8,
      words: (json['words'] as List)
          .map((w) => CrosswordWord.fromJson(w as Map<String, dynamic>))
          .toList(),
      dialLetters: List<String>.from(json['dialLetters'] as List),
    );
  }

  Map<String, dynamic> toJson() => {
        'levelNumber': levelNumber,
        'gridSize': gridSize,
        'words': words.map((w) => w.toJson()).toList(),
        'dialLetters': dialLetters,
      };
}

class CrosswordData {
  final List<CrosswordLevel> levels;
  final Map<String, String> itemPool;

  CrosswordData({
    required this.levels,
    required this.itemPool,
  });

  factory CrosswordData.fromJson(Map<String, dynamic> json) {
    return CrosswordData(
      levels: (json['levels'] as List)
          .map((l) => CrosswordLevel.fromJson(l as Map<String, dynamic>))
          .toList(),
      itemPool: Map<String, String>.from(json['itemPool'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'levels': levels.map((l) => l.toJson()).toList(),
        'itemPool': itemPool,
      };
}
