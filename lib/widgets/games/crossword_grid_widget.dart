import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/games/crossword_data.dart';

class CrosswordGridWidget extends StatelessWidget {
  final int gridSize;
  final List<CrosswordWord> words;

  const CrosswordGridWidget({
    super.key,
    required this.gridSize,
    required this.words,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Identify used cells and their bounds
    int minR = gridSize, maxR = -1, minC = gridSize, maxC = -1;
    final Set<Point<int>> usedCells = {};

    for (var word in words) {
      for (int i = 0; i < word.syllables.length; i++) {
        int r = word.isHorizontal ? word.row : word.row + i;
        int c = word.isHorizontal ? word.col + i : word.col;
        if (r >= 0 && r < gridSize && c >= 0 && c < gridSize) {
          usedCells.add(Point(r, c));
          minR = min(minR, r);
          maxR = max(maxR, r);
          minC = min(minC, c);
          maxC = max(maxC, c);
        }
      }
    }

    if (maxR == -1) return const SizedBox.shrink();

    // 2. Calculate offsets to center the active area in the gridSize x gridSize field
    int usedWidth = maxC - minC + 1;
    int usedHeight = maxR - minR + 1;
    int rowOffset = ((gridSize - usedHeight) / 2).floor() - minR;
    int colOffset = ((gridSize - usedWidth) / 2).floor() - minC;

    // 3. Prepare grids
    final grid = List.generate(
      gridSize,
      (_) => List<String?>.generate(gridSize, (_) => null),
    );
    final revealed = List.generate(
      gridSize,
      (_) => List<bool>.generate(gridSize, (_) => false),
    );
    final isPartOfWord = List.generate(
      gridSize,
      (_) => List<bool>.generate(gridSize, (_) => false),
    );

    for (var word in words) {
      for (int i = 0; i < word.syllables.length; i++) {
        int r = (word.isHorizontal ? word.row : word.row + i) + rowOffset;
        int c = (word.isHorizontal ? word.col + i : word.col) + colOffset;
        
        if (r >= 0 && r < gridSize && c >= 0 && c < gridSize) {
          grid[r][c] = word.syllables[i];
          isPartOfWord[r][c] = true;
          if (word.revealed) {
            revealed[r][c] = true;
          }
        }
      }
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cellSize =
                    (constraints.maxWidth - (gridSize - 1) * 6 - 24) / gridSize;

                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridSize,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                  ),
                  itemCount: gridSize * gridSize,
                  itemBuilder: (context, index) {
                    int r = index ~/ gridSize;
                    int c = index % gridSize;

                    if (!isPartOfWord[r][c]) {
                      return const SizedBox.shrink();
                    }

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutQuad,
                      decoration: BoxDecoration(
                        color:
                            revealed[r][c]
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow:
                            revealed[r][c]
                                ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                                : [],
                        border: Border.all(
                          color:
                              revealed[r][c]
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.shade300,
                          width: revealed[r][c] ? 2.5 : 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          revealed[r][c] ? grid[r][c]! : '',
                          style: TextStyle(
                            fontSize: cellSize * 0.5,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
