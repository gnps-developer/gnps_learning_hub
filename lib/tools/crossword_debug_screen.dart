import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/games/crossword_data.dart';
import '../widgets/games/crossword_grid_widget.dart';
import '../config/ui_config.dart';
import '../config/ui_strings.dart';

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
      appBar: AppBar(title: const Text(UIStrings.crosswordDebugLabel)),
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

        // Create a deep copy of words and force them to be revealed for inspection
        final revealedWords = level.words.map((w) {
          return CrosswordWord(
            number: w.number,
            answer: w.answer,
            syllables: List.from(w.syllables),
            row: w.row,
            col: w.col,
            isHorizontal: w.isHorizontal,
            hint: w.hint,
            revealed: true,
          );
        }).toList();

        final hasAcross = level.words.any((w) => w.isHorizontal);
        final hasDown = level.words.any((w) => !w.isHorizontal);

        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.lg),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ExpansionTile(
            initiallyExpanded: index == 0,
            title: Text(
              'Level ${level.levelNumber}  (${level.gridWidth}x${level.gridHeight})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${level.words.length} words • Dial: ${level.dialLetters.join(", ")}'),
            trailing: (!hasAcross || !hasDown) 
                ? const Icon(Icons.warning_amber_rounded, color: Colors.orange) 
                : null,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('WORDS & HINTS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: level.words.map((w) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${w.isHorizontal ? "→" : "↓"} ${w.answer}: ${w.hint}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      )).toList(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      height: 380,
                      width: double.infinity,
                      child: Center(
                        child: CrosswordGridWidget(
                          gridWidth: level.gridWidth,
                          gridHeight: level.gridHeight,
                          words: revealedWords,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
