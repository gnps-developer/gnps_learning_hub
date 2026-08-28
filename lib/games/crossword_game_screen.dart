import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/game_config.dart';
import '../models/games/crossword_data.dart';
import '../models/games/game_difficulty.dart';
import '../config/ui_config.dart';
import '../config/ui_strings.dart';
import '../providers/progress_providers.dart';
import '../providers/audio_providers.dart';
import '../widgets/games/crossword_grid_widget.dart';
import '../widgets/games/letter_dial_widget.dart';
import '../widgets/confetti/confetti_overlay.dart';

class CrosswordGameScreen extends ConsumerStatefulWidget {
  final GameConfig game;

  const CrosswordGameScreen({super.key, required this.game});

  @override
  ConsumerState<CrosswordGameScreen> createState() => _CrosswordGameScreenState();
}

class _CrosswordGameScreenState extends ConsumerState<CrosswordGameScreen> {
  late CrosswordData _crosswordData;
  final GlobalKey<ConfettiOverlayState> _confettiKey = GlobalKey();

  int _currentLevelIndex = 0;
  int _wordsFoundInLevel = 0;
  bool _levelComplete = false;
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
    if (_levelComplete || _gameFinished) return;

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
      }
    } else {
      ref.read(audioServiceProvider).playFailure();
    }
  }

  void _onLevelComplete() async {
    setState(() {
      _levelComplete = true;
    });
    
    _confettiKey.currentState?.play();
    ref.read(audioServiceProvider).playGameWon();
    
    final winBonus = widget.game.content['winBonusPoints'] ?? 20;
    ref.read(progressProvider.notifier).addPoints(winBonus);

    // Save level progress (we repurpose unlockedGameDifficulties for level index)
    await ref.read(progressProvider.notifier).recordGameScore(
      gameId: widget.game.id,
      score: _currentLevelIndex + 1,
      difficulty: GameDifficulty.easy, // Not used but required by API
      won: true,
    );

    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    if (_currentLevelIndex < _crosswordData.levels.length - 1) {
      setState(() {
        _currentLevelIndex++;
        _wordsFoundInLevel = 0;
        _levelComplete = false;
        // Reset word revealed states for the next level if they were reused
        for (var w in _currentLevel.words) {
          w.revealed = false;
        }
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, size: 32),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Text(
                          'Level ${_currentLevel.levelNumber} / ${_crosswordData.levels.length}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 48), // Spacer
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: CrosswordGridWidget(
                          gridSize: _currentLevel.gridSize,
                          words: _currentLevel.words,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
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

            if (_levelComplete && !_gameFinished)
              _TransitionOverlay(
                title: 'Level Complete!',
                subtitle: 'Moving to Level ${_currentLevel.levelNumber}...',
              ),

            if (_gameFinished)
              Container(
                color: AppColors.barrierDark.withValues(alpha: 0.7),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Congratulations! 🎉',
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const Text(
                        'You finished all levels!',
                        style: TextStyle(
                          color: Colors.white,
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

            Positioned.fill(child: ConfettiOverlay(key: _confettiKey)),
          ],
        ),
      ),
    );
  }
}

class _TransitionOverlay extends StatelessWidget {
  final String title;
  final String subtitle;

  const _TransitionOverlay({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.3),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white70, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
