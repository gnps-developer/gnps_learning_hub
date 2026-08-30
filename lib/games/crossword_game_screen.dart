import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/game_config.dart';
import '../models/games/crossword_data.dart';
import '../config/ui_config.dart';
import '../config/ui_strings.dart';
import '../providers/progress_providers.dart';
import '../providers/audio_providers.dart';
import '../widgets/games/crossword_grid_widget.dart';
import '../widgets/games/letter_dial_widget.dart';

class CrosswordGameScreen extends ConsumerStatefulWidget {
  final GameConfig game;

  const CrosswordGameScreen({super.key, required this.game});

  @override
  ConsumerState<CrosswordGameScreen> createState() =>
      _CrosswordGameScreenState();
}

class _CrosswordGameScreenState extends ConsumerState<CrosswordGameScreen> {
  late CrosswordData _crosswordData;

  int _currentLevelIndex = 0;
  int _wordsFoundInLevel = 0;
  bool _isTransitioning = false;
  bool _gameFinished = false;

  @override
  void initState() {
    super.initState();
    _crosswordData = CrosswordData.fromJson(widget.game.content);

    // Load saved progress for this game if available
    final progress = ref.read(progressProvider).value;
    final savedLevel = progress?.unlockedGameDifficulties[widget.game.id] ?? 0;
    _currentLevelIndex = min(savedLevel, _crosswordData.levels.length - 1);
  }

  CrosswordLevel get _currentLevel => _crosswordData.levels[_currentLevelIndex];

  void _onWordCompleted(String word) {
    if (_isTransitioning || _gameFinished) return;

    bool found = false;
    setState(() {
      for (var cw in _currentLevel.words) {
        if (!cw.revealed && cw.answer == word) {
          cw.revealed = true;
          _wordsFoundInLevel++;
          found = true;

          final audioPath = _crosswordData.itemPool[word];
          if (audioPath != null) {
            ref.read(audioServiceProvider).speak(audioPath);
          } else {
            ref.read(audioServiceProvider).playSuccess();
          }
          break;
        }
      }
    });

    if (found) {
      if (_wordsFoundInLevel >= _currentLevel.words.length) {
        _onLevelComplete();
        _advanceToNextLevel();
      }
    } else {
      ref.read(audioServiceProvider).playFailure();
    }
  }

  void _onLevelComplete() {
    // Hook for future winning feedback effects (animations, sounds, etc.)
  }

  void _advanceToNextLevel() async {
    setState(() {
      _isTransitioning = true;
    });

    final winBonus = widget.game.content['winBonusPoints'] ?? 20;
    ref.read(progressProvider.notifier).addPoints(winBonus);

    // Save level progress
    await ref
        .read(progressProvider.notifier)
        .saveGameLevel(
          gameId: widget.game.id,
          levelIndex: _currentLevelIndex + 1,
        );

    // Short delay to allow the last word revelation to be seen
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;

    if (_currentLevelIndex < _crosswordData.levels.length - 1) {
      setState(() {
        // Reset word revealed states for the level just completed,
        // BEFORE advancing the index (so _currentLevel still points at it)
        for (var w in _currentLevel.words) {
          w.revealed = false;
        }
        _currentLevelIndex++;
        _wordsFoundInLevel = 0;
        _isTransitioning = false;
      });
    } else {
      setState(() {
        _gameFinished = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, size: 28),
                          onPressed: () => Navigator.of(context).pop(),
                          style: IconButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh.withValues(alpha: 0.3),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHigh.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Level ${_currentLevel.levelNumber} / ${_crosswordData.levels.length}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: CrosswordGridWidget(
                          gridSize: _currentLevel.gridSize,
                          words: _currentLevel.words,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Expanded(
                      flex: 2,
                      child: LetterDialWidget(
                        letters: _currentLevel.dialLetters,
                        onWordCompleted: _onWordCompleted,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (_gameFinished)
              Container(
                color: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.7),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Congratulations! 🎉',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'You finished all levels!',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xxl,
                            vertical: AppSpacing.md,
                          ),
                        ),
                        child: const Text(UIStrings.backToJourney),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
