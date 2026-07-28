import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/game_config.dart';
import '../models/games/game_difficulty.dart';
import '../models/shop/default_item_ids.dart';
import '../config/ui_config.dart';
import '../config/ui_strings.dart';
import '../providers/progress_providers.dart';
import '../providers/audio_providers.dart';
import '../widgets/common/task_speaker_button.dart';
import '../widgets/common/task_header.dart';
import '../widgets/confetti/confetti_overlay.dart';

class BubbleGameScreen extends ConsumerStatefulWidget {
  final GameConfig game;
  final GameDifficulty? difficulty;

  const BubbleGameScreen({super.key, required this.game, this.difficulty});

  @override
  ConsumerState<BubbleGameScreen> createState() => _BubbleGameScreenState();
}

class _BubbleGameScreenState extends ConsumerState<BubbleGameScreen>
    with TickerProviderStateMixin {
  final Random _random = Random();
  final List<_Bubble> _bubbles = [];
  late Timer _spawnTimer;
  late Timer _gameLoop;
  final GlobalKey<ConfettiOverlayState> _confettiKey = GlobalKey();

  int _score = 0;
  String _targetLetter = '';
  List<String> _letterPool = [];
  bool _gameOver = false;
  bool _gameWon = false;
  bool _isConsumingHeart = false;
  int _pendingLosses = 0;
  GameDifficulty? _selectedDifficulty;
  Map<String, dynamic>? _newAchievement;

  // Configurable parameters from game.content
  late int _spawnRateMs;
  late double _minSpeed;
  late double _maxSpeed;
  late double _baseBubbleSize;
  late int _targetScore;
  late int _pointsPerCorrect;
  late int _initialDelayMs;
  late double _targetProbability;

  @override
  void initState() {
    super.initState();

    // Initialize config with defaults
    final content = widget.game.content;
    _spawnRateMs = (content['spawnRateMs'] as num? ?? 1500).toInt();
    _minSpeed = (content['minSpeed'] as num? ?? 2.0).toDouble();
    _maxSpeed = (content['maxSpeed'] as num? ?? 4.0).toDouble();
    _baseBubbleSize = (content['bubbleSize'] as num? ?? 70.0).toDouble();
    _targetScore = (content['targetScore'] as num? ?? 100).toInt();
    _pointsPerCorrect = (content['pointsPerCorrect'] as num? ?? 10).toInt();
    _initialDelayMs = (content['initialDelayMs'] as num? ?? 1200).toInt();
    _targetProbability =
        (content['targetProbability'] as num? ?? 0.3).toDouble();

    if (widget.difficulty != null) {
      _startGame(widget.difficulty!);
    }
  }

  void _startGame(GameDifficulty diff) {
    setState(() {
      _selectedDifficulty = diff;
    });

    // Scale difficulty based on configuration
    final content = widget.game.content;
    final Map<String, dynamic>? difficulties = content['difficulties'];
    if (difficulties != null && difficulties.containsKey(diff.name)) {
      final Map<String, dynamic> config = difficulties[diff.name];
      
      final spawnRateMult = (config['spawnRateMultiplier'] as num? ?? 1.0).toDouble();
      final speedMult = (config['speedMultiplier'] as num? ?? 1.0).toDouble();
      final probMult = (config['probabilityMultiplier'] as num? ?? 1.0).toDouble();

      _spawnRateMs = (_spawnRateMs * spawnRateMult).toInt();
      _maxSpeed = _maxSpeed * speedMult;
      _targetProbability = _targetProbability * probMult;
    }

    _initGame();
  }

  Future<void> _initGame() async {
    final content = widget.game.content;
    final List<String> letters = (content['letters'] as List? ?? [])
        .map((e) => e.toString())
        .toList();

    setState(() {
      _letterPool = letters.isEmpty ? ['ੳ', 'ਅ', 'ੲ', 'ਸ', 'ਹ'] : letters;
      // Pick first target immediately so bubbles can spawn with it,
      // but we wait to speak it.
      _targetLetter = _letterPool[_random.nextInt(_letterPool.length)];
    });

    _spawnTimer = Timer.periodic(Duration(milliseconds: _spawnRateMs), (timer) {
      if (!_gameOver) _spawnBubble();
    });

    _gameLoop = Timer.periodic(
      const Duration(milliseconds: 16),
      (timer) {
        if (!_gameOver) _updateBubbles();
      },
    );

    // Wait for the configured initial delay before speaking the first word.
    await Future.delayed(Duration(milliseconds: _initialDelayMs));
    if (!mounted) return;

    _speakTarget();
  }

  void _nextRound() {
    if (_letterPool.isEmpty) return;
    _targetLetter = _letterPool[_random.nextInt(_letterPool.length)];
    _speakTarget();
  }

  Future<void> _speakTarget() async {
    ref.read(audioServiceProvider).speak(_targetLetter);
  }

  void _spawnBubble() {
    final x =
        _random.nextDouble() * (MediaQuery.of(context).size.width - 80) + 40;
    final letter = _random.nextDouble() < _targetProbability
        ? _targetLetter
        : _letterPool[_random.nextInt(_letterPool.length)];

    setState(() {
      _bubbles.add(
        _Bubble(
          id: DateTime.now().millisecondsSinceEpoch,
          x: x,
          y: MediaQuery.of(context).size.height,
          letter: letter,
          speed: _minSpeed + _random.nextDouble() * (_maxSpeed - _minSpeed),
          size: _baseBubbleSize * (0.8 + _random.nextDouble() * 0.4),
          color: Colors.primaries[_random.nextInt(Colors.primaries.length)]
              .withValues(alpha: 0.6),
        ),
      );
    });
  }

  void _updateBubbles() {
    int lostCount = 0;
    setState(() {
      for (var i = _bubbles.length - 1; i >= 0; i--) {
        _bubbles[i].y -= _bubbles[i].speed;
        if (_bubbles[i].y < -100) {
          if (_bubbles[i].letter == _targetLetter && !_bubbles[i].popped) {
            lostCount++;
          }
          _bubbles.removeAt(i);
        }
      }
    });

    for (int i = 0; i < lostCount; i++) {
      _loseLife();
    }
  }

  void _popBubble(_Bubble bubble) async {
    if (bubble.popped || _gameOver || bubble.status != _BubbleStatus.normal) {
      return;
    }

    setState(() {
      if (bubble.letter == _targetLetter) {
        _score += _pointsPerCorrect;
        bubble.status = _BubbleStatus.correct;
        ref.read(audioServiceProvider).playSuccess();
      } else {
        bubble.status = _BubbleStatus.wrong;
      }
    });

    if (bubble.letter == _targetLetter) {
      if (_score >= _targetScore) {
        _winGame();
      } else {
        _nextRound();
      }
    } else {
      _loseLife();
    }

    // Stage 1: Show the result icon for a moment
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    // Stage 2: Trigger the "burst" animation
    setState(() {
      bubble.popped = true;
    });

    // Stage 3: Wait for animation to finish before removing
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    setState(() {
      _bubbles.removeWhere((b) => b.id == bubble.id);
    });
  }

  void _loseLife() async {
    _pendingLosses++;
    if (_gameOver || _isConsumingHeart) return;

    _isConsumingHeart = true;
    while (_pendingLosses > 0 && !_gameOver) {
      _pendingLosses--;

      final progress = ref.read(progressProvider).value;
      final hearts =
          progress?.ownedItemQuantities[DefaultItemIds.extraLife] ?? 0;

      if (hearts > 0) {
        ref.read(audioServiceProvider).playFailure();
        await ref
            .read(progressProvider.notifier)
            .consumeItem(DefaultItemIds.extraLife);

        if (hearts <= 1 && mounted) {
          setState(() => _gameOver = true);
          ref.read(audioServiceProvider).playGameOver();
          _recordFinalScore(won: false);
        }
      } else {
        if (mounted) {
          setState(() => _gameOver = true);
          ref.read(audioServiceProvider).playGameOver();
          _recordFinalScore(won: false);
        }
      }
    }
    _isConsumingHeart = false;
  }

  void _winGame() {
    setState(() {
      _gameOver = true;
      _gameWon = true;
    });
    _confettiKey.currentState?.play();
    ref.read(audioServiceProvider).playGameWon();
    ref.read(progressProvider.notifier).addPoints(50);
    _recordFinalScore(won: true);
  }

  Future<void> _recordFinalScore({required bool won}) async {
    if (_selectedDifficulty == null) return;
    final newIndex = await ref.read(progressProvider.notifier).recordGameScore(
      gameId: widget.game.id,
      score: _score,
      difficulty: _selectedDifficulty!,
      won: won,
    );

    if (newIndex != null && mounted) {
      setState(() {
        _newAchievement = {
          'gameTitle': widget.game.title,
          'difficultyIndex': newIndex,
        };
      });
    }
  }

  @override
  void dispose() {
    _spawnTimer.cancel();
    _gameLoop.cancel();
    super.dispose();
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
            // Game Area
            ..._bubbles.map(
              (bubble) => Positioned(
                key: ValueKey(bubble.id),
                left: bubble.x - bubble.size / 2,
                top: bubble.y - bubble.size / 2,
                child: GestureDetector(
                  onTap: () => _popBubble(bubble),
                  child: _BubbleWidget(bubble: bubble),
                ),
              ),
            ),

            // UI Overlay
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, size: 32),
                          onPressed: () =>
                              Navigator.of(context).pop(_newAchievement),
                        ),
                        Row(
                          children: [
                            ...List.generate(
                              3,
                              (index) => Icon(
                                index <
                                        (ref
                                                .watch(progressProvider)
                                                .value
                                                ?.ownedItemQuantities[DefaultItemIds
                                                .extraLife] ??
                                            0)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: AppColors.heart,
                                size: 32,
                              ),
                            ),
                            if ((ref
                                        .watch(progressProvider)
                                        .value
                                        ?.ownedItemQuantities[DefaultItemIds
                                        .extraLife] ??
                                    0) >
                                3) ...[
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                '+${(ref.watch(progressProvider).value?.ownedItemQuantities[DefaultItemIds.extraLife] ?? 0) - 3}',
                                style: const TextStyle(
                                  color: AppColors.heart,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          '${UIStrings.scoreLabel}: $_score',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (_selectedDifficulty != null) ...[
                          Text(
                            'Difficulty: ${_selectedDifficulty!.displayName}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Best: ${ref.read(progressProvider).value?.gameHighScores[widget.game.id]?[_selectedDifficulty!.name] ?? 0} ⭐',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.ml),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          TaskHeader(
                            title: widget.game.id.contains('word')
                                ? 'Listen to the word'
                                : 'Listen to the letter',
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          TaskSpeakerButton(
                            textToSpeak: _targetLetter,
                            iconSize: 40,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (_gameOver)
              Container(
                color: AppColors.barrierDark.withValues(alpha: 0.7),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _gameWon ? UIStrings.victoryTitle : UIStrings.gameOverTitle,
                        style: TextStyle(
                          color: _gameWon ? Colors.yellow : AppColors.error,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        UIStrings.finalScore(_score),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.of(context).pop(_newAchievement),
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

            if (_selectedDifficulty == null)
              _DifficultySelectionOverlay(
                gameTitle: widget.game.title,
                unlockedLevel: ref
                        .watch(progressProvider)
                        .value
                        ?.unlockedGameDifficulties[widget.game.id] ??
                    0,
                onSelected: _startGame,
                onClose: () => Navigator.of(context).pop(),
              ),
          ],
        ),
      ),
    );
  }
}

class _DifficultySelectionOverlay extends StatelessWidget {
  final String gameTitle;
  final int unlockedLevel;
  final ValueChanged<GameDifficulty> onSelected;
  final VoidCallback onClose;

  const _DifficultySelectionOverlay({
    required this.gameTitle,
    required this.unlockedLevel,
    required this.onSelected,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 20)],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      gameTitle,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text('Select difficulty:'),
                    const SizedBox(height: 24),
                    _DifficultyButton(
                      difficulty: GameDifficulty.easy,
                      isLocked: false,
                      onPressed: () => onSelected(GameDifficulty.easy),
                    ),
                    const SizedBox(height: 12),
                    _DifficultyButton(
                      difficulty: GameDifficulty.medium,
                      isLocked: unlockedLevel < 1,
                      onPressed: () => onSelected(GameDifficulty.medium),
                    ),
                    const SizedBox(height: 12),
                    _DifficultyButton(
                      difficulty: GameDifficulty.hard,
                      isLocked: unlockedLevel < 2,
                      onPressed: () => onSelected(GameDifficulty.hard),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DifficultyButton extends StatelessWidget {
  final GameDifficulty difficulty;
  final bool isLocked;
  final VoidCallback onPressed;

  const _DifficultyButton({
    required this.difficulty,
    required this.isLocked,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: isLocked ? null : onPressed,
        icon: Icon(isLocked ? Icons.lock : difficulty.icon, size: 20),
        label: Text(difficulty.displayName),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}

enum _BubbleStatus { normal, correct, wrong }

class _Bubble {
  final int id;
  double x;
  double y;
  final String letter;
  final double speed;
  final double size;
  final Color color;
  bool popped = false;
  _BubbleStatus status = _BubbleStatus.normal;

  _Bubble({
    required this.id,
    required this.x,
    required this.y,
    required this.letter,
    required this.speed,
    required this.size,
    required this.color,
  });
}

class _BubbleWidget extends StatelessWidget {
  final _Bubble bubble;

  const _BubbleWidget({required this.bubble});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: bubble.popped ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        // When popped: scale from 1.0 to 1.5, fade from 1.0 to 0.0
        final scale = 1.0 + (value * 0.5);
        final opacity = (1.0 - value).clamp(0.0, 1.0);

        return Opacity(
          opacity: opacity,
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Bubble Body with 3D look
          Container(
            width: bubble.size,
            height: bubble.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  bubble.color.withValues(alpha: 0.85),
                  bubble.color.withValues(alpha: 0.6),
                  bubble.color.withValues(alpha: 0.3),
                ],
                stops: const [0.0, 0.7, 1.0],
                center: const Alignment(-0.3, -0.3),
                radius: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(5, 8),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 6,
                  offset: const Offset(2, 4),
                ),
              ],
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1.0,
              ),
            ),
          ),

          // Shine Highlight (More subtle and smooth)
          Positioned(
            top: bubble.size * 0.08,
            left: bubble.size * 0.18,
            child: Container(
              width: bubble.size * 0.4,
              height: bubble.size * 0.3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.35),
                    Colors.white.withValues(alpha: 0.0),
                  ],
                  stops: const [0.2, 1.0],
                ),
              ),
            ),
          ),

          // Content (Letter or Status Icon)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (bubble.status == _BubbleStatus.correct) {
      return Icon(
        Icons.check_circle,
        color: Colors.green,
        size: bubble.size * 0.7,
        shadows: const [Shadow(color: Colors.black26, blurRadius: 8)],
      );
    }
    if (bubble.status == _BubbleStatus.wrong) {
      return Icon(
        Icons.cancel,
        color: Colors.red,
        size: bubble.size * 0.7,
        shadows: const [Shadow(color: Colors.black26, blurRadius: 8)],
      );
    }

    return Text(
      bubble.letter,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: bubble.letter.length > 3
            ? bubble.size * 0.25
            : bubble.letter.length > 1
            ? bubble.size * 0.35
            : bubble.size * 0.5,
        fontWeight: FontWeight.bold,
        shadows: const [Shadow(color: Colors.black26, blurRadius: 4)],
      ),
    );
  }
}
