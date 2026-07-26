import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Speaks Punjabi (Gurmukhi) text aloud and plays feedback sounds.
class AudioService {
  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  Future<void>? _initFuture;

  bool soundEnabled = true;
  bool hapticsEnabled = true;

  Future<void> _init() async {
    _initFuture ??= _doInit();
    return _initFuture;
  }

  Future<void> _doInit() async {
    // Basic config
    await _tts.setLanguage('pa-IN');
    // Web rate is often faster by default, so we use a higher value or the engine default
    await _tts.setSpeechRate(kIsWeb ? 0.9 : 0.4);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);

    if (kIsWeb) {
      // On web, ensuring the engine is ready and waiting for completion can help stability
      await _tts.awaitSpeakCompletion(true);

      // Log available voices to help debug missing language packs
      try {
        final voices = await _tts.getVoices;
        debugPrint('Web TTS: Available voices: $voices');
        final isPaAvailable = await _tts.isLanguageAvailable('pa-IN');
        debugPrint('Web TTS: Punjabi (pa-IN) available: $isPaAvailable');
      } catch (e) {
        debugPrint('Web TTS: Could not query voices: $e');
      }
    }

    await _sfxPlayer.setPlayerMode(PlayerMode.lowLatency);
  }

  Future<bool> isPunjabiAvailable() async {
    try {
      final result = await _tts.isLanguageAvailable('pa-IN');
      return result == true || result == 1;
    } catch (_) {
      return false;
    }
  }

  Future<void> speak(String text) async {
    if (!soundEnabled) return;
    await _init();
    try {
      if (kIsWeb) {
        // On web, explicit stop helps reset the synthesis state if it was stuck.
        // We also re-verify the language right before speaking for better stability.
        await _tts.stop();
        await _tts.setLanguage('pa-IN');
      }
      final result = await _tts.speak(text);
      if (result == 0 && kIsWeb) {
        debugPrint('Web TTS: speak() returned 0 (failure)');
      }
    } catch (e) {
      debugPrint('TTS Error: $e');
    }
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  /// Success SFX
  Future<void> playSuccess() async {
    if (!soundEnabled) return;
    await _init();
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.play(AssetSource('sounds/success.mp3'));
    } catch (e) {
      debugPrint('SFX Error: $e');
      if (!kIsWeb) {
        await SystemSound.play(SystemSoundType.click);
      }
    }
    if (hapticsEnabled) await HapticFeedback.mediumImpact();
  }

  /// Failure SFX
  Future<void> playFailure() async {
    if (!soundEnabled) return;
    await _init();
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.play(AssetSource('sounds/failure.mp3'));
    } catch (e) {
      debugPrint('SFX Error: $e');
      if (!kIsWeb) {
        await HapticFeedback.heavyImpact();
      }
    }
    if (hapticsEnabled) await HapticFeedback.selectionClick();
  }

  /// Gem-earned SFX. Call whenever the user is awarded gems (e.g. on task
  /// completion, alongside `pointsAwarded`).
  Future<void> playGemEarned() async {
    if (!soundEnabled) return;
    await _init();
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.play(AssetSource('sounds/gem_earned.mp3'));
    } catch (e) {
      debugPrint('SFX Error: $e');
      if (!kIsWeb) {
        await SystemSound.play(SystemSoundType.click);
      }
    }
    if (hapticsEnabled) await HapticFeedback.lightImpact();
  }

  /// Lesson-completed SFX. Call when the final section of a lesson is
  /// finished, alongside the confetti celebration.
  Future<void> playLessonCompleted() async {
    if (!soundEnabled) return;
    await _init();
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.play(AssetSource('sounds/lesson-completed.mp3'));
    } catch (e) {
      debugPrint('SFX Error: $e');
      if (!kIsWeb) {
        await SystemSound.play(SystemSoundType.click);
      }
    }
    if (hapticsEnabled) await HapticFeedback.mediumImpact();
  }

  /// Game won SFX
  Future<void> playGameWon() async {
    if (!soundEnabled) return;
    await _init();
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.play(AssetSource('sounds/game_won.mp3'));
    } catch (e) {
      debugPrint('SFX Error: $e');
    }
    if (hapticsEnabled) await HapticFeedback.mediumImpact();
  }

  /// Game over SFX
  Future<void> playGameOver() async {
    if (!soundEnabled) return;
    await _init();
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.play(AssetSource('sounds/game_over.mp3'));
    } catch (e) {
      debugPrint('SFX Error: $e');
    }
    if (hapticsEnabled) await HapticFeedback.heavyImpact();
  }

  /// Call from provider dispose to release resources.
  void dispose() {
    _sfxPlayer.dispose();
    _tts.stop();
  }
}
