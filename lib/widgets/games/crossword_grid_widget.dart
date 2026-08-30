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
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.2), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.05),
                  blurRadius: 15,
                  spreadRadius: 2,
                )
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 2.0;
                final cellSize =
                    (constraints.maxWidth - (gridSize - 1) * spacing - 16) / gridSize;

                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridSize,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                  ),
                  itemCount: gridSize * gridSize,
                  itemBuilder: (context, index) {
                    int r = index ~/ gridSize;
                    int c = index % gridSize;

                    if (!isPartOfWord[r][c]) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            width: 0.5,
                          ),
                        ),
                      );
                    }

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutQuad,
                      decoration: BoxDecoration(
                        color:
                            revealed[r][c]
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow:
                            revealed[r][c]
                                ? [
                                  BoxShadow(
                                    color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ]
                                : [],
                        border: Border.all(
                          color:
                              revealed[r][c]
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.outline.withValues(alpha: 0.4),
                          width: revealed[r][c] ? 2.0 : 1.0,
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
