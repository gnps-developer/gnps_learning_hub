import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/game_config.dart';
import '../config/ui_strings.dart';
import '../providers/progress_providers.dart';
import '../providers/audio_providers.dart';
import '../widgets/common/task_speaker_button.dart';
import '../widgets/confetti/confetti_overlay.dart';

class BubbleGameScreen extends ConsumerStatefulWidget {
  final GameConfig game;

  const BubbleGameScreen({super.key, required this.game});

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

  int _lives = 3;
  int _score = 0;
  String _targetLetter = '';
  List<String> _letterPool = [];
  bool _gameOver = false;
  bool _gameWon = false;

  // Configurable parameters from game.content
  late int _spawnRateMs;
  late double _minSpeed;
  late double _maxSpeed;
  late double _baseBubbleSize;

  @override
  void initState() {
    super.initState();

    // Initialize config with defaults
    final content = widget.game.content;
    _spawnRateMs = (content['spawnRateMs'] as num? ?? 1500).toInt();
    _minSpeed = (content['minSpeed'] as num? ?? 2.0).toDouble();
    _maxSpeed = (content['maxSpeed'] as num? ?? 4.0).toDouble();
    _baseBubbleSize = (content['bubbleSize'] as num? ?? 70.0).toDouble();

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

    _gameLoop = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!_gameOver) _updateBubbles();
    });

    // Wait 2 seconds after bubbles start spawning before speaking the first word.
    await Future.delayed(const Duration(milliseconds: 2000));
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
    final letter = _random.nextDouble() > 0.7
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
    setState(() {
      for (var i = _bubbles.length - 1; i >= 0; i--) {
        _bubbles[i].y -= _bubbles[i].speed;
        if (_bubbles[i].y < -100) {
          if (_bubbles[i].letter == _targetLetter && !_bubbles[i].popped) {
            _loseLife();
          }
          _bubbles.removeAt(i);
        }
      }
    });
  }

  void _popBubble(_Bubble bubble) {
    if (bubble.popped || _gameOver) return;

    setState(() {
      bubble.popped = true;
      if (bubble.letter == _targetLetter) {
        _score += 10;
        bubble.status = _BubbleStatus.correct;
        if (_score >= 100) {
          _winGame();
        } else {
          _nextRound();
        }
      } else {
        bubble.status = _BubbleStatus.wrong;
        _loseLife();
      }
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _bubbles.removeWhere((b) => b.id == bubble.id);
      });
    });
  }

  void _loseLife() {
    setState(() {
      _lives--;
      if (_lives <= 0) {
        _handleOutOfLives();
      }
    });
  }

  void _handleOutOfLives() async {
    final progress = ref.read(progressProvider).value;
    final extraHearts =
        progress?.ownedItemQuantities['powerup_extra_life'] ?? 0;

    if (extraHearts > 0) {
      // Automatically consume an extra heart and refill lives.
      await ref
          .read(progressProvider.notifier)
          .consumeItem('powerup_extra_life');

      if (mounted) {
        setState(() {
          _lives = 3;
        });
      }
    } else {
      // No extra hearts left, game over immediately.
      setState(() => _gameOver = true);
      ref.read(audioServiceProvider).playGameOver();
    }
  }

  void _winGame() {
    setState(() {
      _gameOver = true;
      _gameWon = true;
    });
    _confettiKey.currentState?.play();
    ref.read(audioServiceProvider).playGameWon();
    ref.read(progressProvider.notifier).addPoints(50);
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
            colors: [Colors.blue.shade200, Colors.blue.shade50],
          ),
        ),
        child: Stack(
          children: [
            // Game Area
            ..._bubbles.map(
              (bubble) => Positioned(
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
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Row(
                          children: [
                            ...List.generate(
                              3,
                              (index) => Icon(
                                index < _lives
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if ((ref
                                        .watch(progressProvider)
                                        .value
                                        ?.ownedItemQuantities['powerup_extra_life'] ??
                                    0) >
                                0)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.red.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.add,
                                      size: 16,
                                      color: Colors.red,
                                    ),
                                    const Icon(
                                      Icons.favorite,
                                      size: 16,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${ref.watch(progressProvider).value?.ownedItemQuantities['powerup_extra_life']}',
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        Text(
                          'Score: $_score',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Text(
                            widget.game.id.contains('word')
                                ? 'Listen to the word:'
                                : 'Listen to the letter:',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 8),
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
                color: Colors.black.withValues(alpha: 0.7),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _gameWon ? 'VICTORY!' : 'GAME OVER',
                        style: TextStyle(
                          color: _gameWon ? Colors.yellow : Colors.red,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Final Score: $_score',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 16,
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
    if (bubble.status == _BubbleStatus.correct) {
      return Icon(Icons.check_circle, color: Colors.green, size: bubble.size);
    }
    if (bubble.status == _BubbleStatus.wrong) {
      return Icon(Icons.cancel, color: Colors.red, size: bubble.size);
    }

    return Container(
      width: bubble.size,
      height: bubble.size,
      decoration: BoxDecoration(
        color: bubble.color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
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
          ),
        ),
      ),
    );
  }
}
