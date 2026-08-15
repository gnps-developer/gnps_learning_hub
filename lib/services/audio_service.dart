import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';

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
    try {
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        // 1. Android Engine Selection (MUST be done first)
        // Samsung/OEM engines often have poor Punjabi support.
        try {
          final engines = await _tts.getEngines;
          if (engines.contains('com.google.android.tts')) {
            await _tts.setEngine('com.google.android.tts');
          }
        } catch (e) {
          debugPrint('TTS: Engine selection error: $e');
        }
      }

      // 2. Language & Parameters
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
    } catch (e) {
      debugPrint('TTS: Initialization error: $e');
    }

    await _sfxPlayer.setPlayerMode(PlayerMode.lowLatency);
  }

  Future<bool> isPunjabiAvailable() async {
    try {
      final result = await _tts.isLanguageAvailable('pa-IN');
      // Some engines return bool, some return int (1 = supported, 0 = unsupported, -1 = missing data)
      return result == true || result == 1;
    } catch (_) {
      return false;
    }
  }

  /// Attempts to open the system Text-to-Speech settings so the user can
  /// install the Punjabi language pack if missing.
  Future<void> openTtsSettings() async {
    if (kIsWeb) return;
    if (defaultTargetPlatform != TargetPlatform.android) return;

    // Standard Android intent action for TTS settings
    final Uri intentUri = Uri(
      scheme: 'intent',
      path: '#Intent;action=com.android.settings.TTS_SETTINGS;end',
    );

    try {
      // On Android 11+, canLaunchUrl will return false unless declared in manifest.
      // We try to launch directly for better reliability.
      await launchUrl(intentUri);
    } catch (e) {
      debugPrint('Error opening TTS settings via intent: $e');
      // Fallback to Google TTS page on Play Store
      final playStoreUri = Uri.parse(
        'https://play.google.com/store/apps/details?id=com.google.android.tts',
      );
      try {
        await launchUrl(playStoreUri, mode: LaunchMode.externalApplication);
      } catch (e2) {
        debugPrint('Error opening Play Store: $e2');
      }
    }
  }

  Future<void> speak(String text) async {
    if (!soundEnabled) return;
    await _init();
    try {
      // Explicitly stop any in-progress speech before starting new one.
      // This helps on older devices where the synthesis engine can get "stuck".
      await _tts.stop();
      
      if (kIsWeb) {
        await _tts.setLanguage('pa-IN');
      }
      
      final result = await _tts.speak(text);
      if (result == 0) {
        debugPrint('TTS: speak() returned 0 (failure). Text: $text');
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
