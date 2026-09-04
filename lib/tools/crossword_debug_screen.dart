import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/games/crossword_data.dart';
import '../widgets/games/crossword_grid_widget.dart';
import '../config/ui_config.dart';

class CrosswordDebugScreen extends StatefulWidget {
  const CrosswordDebugScreen({super.key});

  @override
  State<CrosswordDebugScreen> createState() => _CrosswordDebugScreenState();
}

class _CrosswordDebugScreenState extends State<CrosswordDebugScreen> {
  CrosswordData? _crosswordData;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/games/crossword_punjabi.json',
      );
      final jsonData = jsonDecode(jsonString);
      setState(() {
        _crosswordData = CrosswordData.fromJson(
          jsonData['content'] ?? jsonData,
        );
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crossword Layout Debug')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Center(
        child: Text(
          'Error: $_error',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (_crosswordData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: _crosswordData!.levels.length,
      itemBuilder: (context, index) {
        final level = _crosswordData!.levels[index];

        // Clone words and mark them as revealed for debug view
        final revealedWords = level.words.map((w) {
          return CrosswordWord(
            number: w.number,
            answer: w.answer,
            syllables: w.syllables,
            row: w.row,
            col: w.col,
            isHorizontal: w.isHorizontal,
            hint: w.hint,
            revealed: true,
          );
        }).toList();

        // Sanity flags a human reviewer cares about at a glance: does the
        // word count look like a real crossword (>=2 words, at least one
        // intersection), and are both directions actually represented.
        final hasAcross = level.words.any((w) => w.isHorizontal);
        final hasDown = level.words.any((w) => !w.isHorizontal);
        final looksSparse = level.words.length < 6;

        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.lg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Level ${level.levelNumber}  '
                      '(Grid: ${level.gridWidth}x${level.gridHeight}, '
                      '${level.words.length} words)',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    if (looksSparse || !hasAcross || !hasDown)
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                        size: 20,
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                for (final w in level.words)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Text(
                      '#${w.number ?? '-'} '
                      '${w.isHorizontal ? '→' : '↓'} '
                      '${w.answer}  (${w.row},${w.col})'
                      '${w.hint.isNotEmpty ? '  — ${w.hint}' : ''}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text(
                      'Dial: ',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Expanded(
                      child: Wrap(
                        spacing: 4,
                        children: level.dialLetters
                            .map(
                              (l) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondaryContainer,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  l,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSecondaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 420,
                  width: double.infinity,
                  child: Center(
                    child: CrosswordGridWidget(
                      gridWidth: level.gridWidth,
                      gridHeight: level.gridHeight,
                      words: revealedWords,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
