import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/games/crossword_data.dart';

class CrosswordGridWidget extends StatelessWidget {
  final int gridWidth;
  final int gridHeight;
  final List<CrosswordWord> words;

  const CrosswordGridWidget({
    super.key,
    required this.gridWidth,
    required this.gridHeight,
    required this.words,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Identify used cells and their bounds (defensive: the generator
    // already emits a tight bounding box that matches gridWidth/gridHeight,
    // but we still re-derive bounds here in case older level data is
    // padded or offset differently).
    int minR = gridHeight, maxR = -1, minC = gridWidth, maxC = -1;

    for (var word in words) {
      for (int i = 0; i < word.syllables.length; i++) {
        int r = word.isHorizontal ? word.row : word.row + i;
        int c = word.isHorizontal ? word.col + i : word.col;
        minR = min(minR, r);
        maxR = max(maxR, r);
        minC = min(minC, c);
        maxC = max(maxC, c);
      }
    }

    if (maxR == -1) return const SizedBox.shrink();

    // 2. Offset so the used area sits flush at (0,0) inside a
    // gridWidth x gridHeight field (no forced square padding).
    int usedWidth = maxC - minC + 1;
    int usedHeight = maxR - minR + 1;
    int rowOffset = ((gridHeight - usedHeight) / 2).floor() - minR;
    int colOffset = ((gridWidth - usedWidth) / 2).floor() - minC;

    // 3. Prepare grids
    final grid = List.generate(
      gridHeight,
          (_) => List<String?>.generate(gridWidth, (_) => null),
    );
    final revealed = List.generate(
      gridHeight,
          (_) => List<bool>.generate(gridWidth, (_) => false),
    );
    final isPartOfWord = List.generate(
      gridHeight,
          (_) => List<bool>.generate(gridWidth, (_) => false),
    );
    final cellNumber = List.generate(
      gridHeight,
          (_) => List<int?>.generate(gridWidth, (_) => null),
    );

    for (var word in words) {
      for (int i = 0; i < word.syllables.length; i++) {
        int r = (word.isHorizontal ? word.row : word.row + i) + rowOffset;
        int c = (word.isHorizontal ? word.col + i : word.col) + colOffset;

        if (r >= 0 && r < gridHeight && c >= 0 && c < gridWidth) {
          grid[r][c] = word.syllables[i];
          isPartOfWord[r][c] = true;
          if (word.revealed) {
            revealed[r][c] = true;
          }
          if (i == 0 && word.number != null) {
            cellNumber[r][c] = word.number;
          }
        }
      }
    }

    final aspectRatio = gridWidth / gridHeight;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
        child: AspectRatio(
          aspectRatio: aspectRatio,
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
                    (constraints.maxWidth - (gridWidth - 1) * spacing - 16) / gridWidth;

                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridWidth,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                  ),
                  itemCount: gridWidth * gridHeight,
                  itemBuilder: (context, index) {
                    int r = index ~/ gridWidth;
                    int c = index % gridWidth;

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

                    final number = cellNumber[r][c];

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
                      child: Stack(
                        children: [
                          if (number != null)
                            Positioned(
                              top: 2,
                              left: 3,
                              child: Text(
                                '$number',
                                style: TextStyle(
                                  fontSize: cellSize * 0.22,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                                ),
                              ),
                            ),
                          Center(
                            child: Text(
                              revealed[r][c] ? grid[r][c]! : '',
                              style: TextStyle(
                                fontSize: cellSize * 0.5,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ],
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