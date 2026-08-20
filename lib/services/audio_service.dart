import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Speaks Punjabi (Gurmukhi) text using pre-recorded local audio assets.
/// All audio mapping is defined explicitly in the lesson JSON data.
class AudioService {
  // Pool of players to handle rapid/overlapping sounds
  static const int _sfxPoolSize = 4;
  final List<AudioPlayer> _sfxPool = List.generate(
    _sfxPoolSize,
    (_) => AudioPlayer(),
  );
  int _sfxPoolIndex = 0;

  Future<void>? _initFuture;

  bool soundEnabled = true;
  bool hapticsEnabled = true;

  /// Internal flag to track if any player in the pool is currently active.
  final ValueNotifier<bool> isSpeaking = ValueNotifier(false);

  Future<void> _init() {
    _initFuture ??= _doInit().catchError((Object e, StackTrace st) {
      debugPrint('Audio: Initialization error: $e');
      _initFuture = null;
    });
    return _initFuture!;
  }

  Future<void> _doInit() async {
    for (final player in _sfxPool) {
      await player.setPlayerMode(PlayerMode.lowLatency);
    }
  }

  /// Plays a pre-recorded audio file specified by [assetPath].
  /// [assetPath] should be the full path relative to assets/,
  /// e.g. "audio/lessons/alphabet/ura.mp3".
  Future<void> speak(String assetPath) async {
    if (!soundEnabled || assetPath.isEmpty) return;
    await _init();

    try {
      final player = _nextSfxPlayer();
      await player.stop();
      await player.play(AssetSource(assetPath));

      debugPrint('Audio: Playing $assetPath');
      isSpeaking.value = true;
      // Reset speaking state after a conservative delay
      Future.delayed(const Duration(seconds: 2), () {
        isSpeaking.value = false;
      });
    } catch (e) {
      debugPrint('Audio: Could not play asset at path: $assetPath');
    }
  }

  AudioPlayer _nextSfxPlayer() {
    final player = _sfxPool[_sfxPoolIndex];
    _sfxPoolIndex = (_sfxPoolIndex + 1) % _sfxPool.length;
    return player;
  }

  Future<void> _playSfx(
    String asset, {
    required Future<void> Function() onError,
    required Future<void> Function() haptic,
  }) async {
    if (!soundEnabled) return;
    await _init();
    try {
      final player = _nextSfxPlayer();
      await player.stop();
      await player.play(AssetSource(asset));
    } catch (e) {
      debugPrint('SFX Error: $e');
      await onError();
    }
    if (hapticsEnabled) await haptic();
  }

  Future<void> playSuccess() => _playSfx(
        'sounds/success.mp3',
        onError: () async {
          if (!kIsWeb) await SystemSound.play(SystemSoundType.click);
        },
        haptic: () => HapticFeedback.mediumImpact(),
      );

  Future<void> playFailure() => _playSfx(
        'sounds/failure.mp3',
        onError: () async {
          if (!kIsWeb) await HapticFeedback.heavyImpact();
        },
        haptic: () => HapticFeedback.selectionClick(),
      );

  Future<void> playGemEarned() => _playSfx(
        'sounds/gem_earned.mp3',
        onError: () async {
          if (!kIsWeb) await SystemSound.play(SystemSoundType.click);
        },
        haptic: () => HapticFeedback.lightImpact(),
      );

  Future<void> playLessonCompleted() => _playSfx(
        'sounds/lesson-completed.mp3',
        onError: () async {
          if (!kIsWeb) await SystemSound.play(SystemSoundType.click);
        },
        haptic: () => HapticFeedback.mediumImpact(),
      );

  Future<void> playGameWon() => _playSfx(
        'sounds/game_won.mp3',
        onError: () async {},
        haptic: () => HapticFeedback.mediumImpact(),
      );

  Future<void> playGameOver() => _playSfx(
        'sounds/game_over.mp3',
        onError: () async {},
        haptic: () => HapticFeedback.heavyImpact(),
      );

  void dispose() {
    for (final player in _sfxPool) {
      player.dispose();
    }
    isSpeaking.dispose();
  }
}
