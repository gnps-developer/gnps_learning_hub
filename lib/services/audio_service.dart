import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';

/// Availability state of the Punjabi (Gurmukhi) TTS voice on this device.
enum TtsAvailability { checking, available, unavailable }

/// Speaks Punjabi (Gurmukhi) text aloud and plays feedback sounds.
class AudioService {
  final FlutterTts _tts = FlutterTts();

  // Small round-robin pool of players so overlapping SFX (e.g. a gem sound
  // firing right after a success sound) don't cut each other off, which
  // happened with a single shared AudioPlayer.
  static const int _sfxPoolSize = 3;
  final List<AudioPlayer> _sfxPool = List.generate(
    _sfxPoolSize,
        (_) => AudioPlayer(),
  );
  int _sfxPoolIndex = 0;

  Future<void>? _initFuture;

  bool soundEnabled = true;
  bool hapticsEnabled = true;

  /// Reactive Punjabi availability status. UI should listen to this instead
  /// of calling isPunjabiAvailable() from inside build() / FutureBuilder,
  /// which re-queries the engine on every rebuild.
  final ValueNotifier<TtsAvailability> ttsAvailability = ValueNotifier(
    TtsAvailability.checking,
  );

  /// True while speech is actively being synthesized/played.
  final ValueNotifier<bool> isSpeaking = ValueNotifier(false);

  Future<void> _init() {
    // Don't permanently cache a failed init - a transient failure (or a
    // device where the TTS service takes a moment to bind) shouldn't break
    // audio for the rest of the app session.
    _initFuture ??= _doInit().catchError((Object e, StackTrace st) {
      debugPrint('TTS: Initialization error: $e');
      _initFuture = null; // allow retry on next call
    });
    return _initFuture!;
  }

  Future<void> _doInit() async {
    _tts.setStartHandler(() => isSpeaking.value = true);
    _tts.setCompletionHandler(() => isSpeaking.value = false);
    _tts.setCancelHandler(() => isSpeaking.value = false);
    _tts.setErrorHandler((msg) {
      debugPrint('TTS: Engine error: $msg');
      isSpeaking.value = false;
    });

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      await _selectBestAndroidEngine();
    }

    await _tts.setLanguage('pa-IN');
    // Web rate is often faster by default, so we use a higher value or the engine default
    await _tts.setSpeechRate(kIsWeb ? 0.9 : 0.4);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);

    if (kIsWeb) {
      // On web, ensuring the engine is ready and waiting for completion can help stability
      await _tts.awaitSpeakCompletion(true);
      try {
        final voices = await _tts.getVoices;
        debugPrint('Web TTS: Available voices: $voices');
      } catch (e) {
        debugPrint('Web TTS: Could not query voices: $e');
      }
    }

    // Verify availability AFTER engine selection, since availability can
    // differ per-engine (e.g. Google TTS may have the pack, OEM may not).
    await _refreshAvailability();

    for (final player in _sfxPool) {
      await player.setPlayerMode(PlayerMode.lowLatency);
    }
  }

  /// Samsung/OEM TTS engines often have poor or missing Gurmukhi support.
  /// Prefer Google's engine when it's installed on the device. Requires the
  /// android.intent.action.TTS_SERVICE entry in queries (manifest) for
  /// getEngines() to see it on Android 11+.
  Future<void> _selectBestAndroidEngine() async {
    try {
      final engines = await _tts.getEngines;
      debugPrint('TTS: Available engines: $engines');
      if (engines is List && engines.contains('com.google.android.tts')) {
        await _tts.setEngine('com.google.android.tts');
      } else {
        debugPrint('TTS: Google TTS engine not found, using default engine');
      }
    } catch (e) {
      debugPrint('TTS: Engine selection error: $e');
    }
  }

  Future<void> _refreshAvailability() async {
    try {
      final result = await _tts.isLanguageAvailable('pa-IN');
      // Some engines return bool, some return int (1 = supported, 0 = unsupported, -1 = missing data)
      final available = result == true || result == 1;
      ttsAvailability.value = available
          ? TtsAvailability.available
          : TtsAvailability.unavailable;
    } catch (e) {
      debugPrint('TTS: Availability check error: $e');
      ttsAvailability.value = TtsAvailability.unavailable;
    }
  }

  /// Re-checks Punjabi availability. Call this when the app resumes (e.g.
  /// after the user returns from the system TTS settings screen having
  /// installed a language pack) so the settings UI reflects the new state.
  Future<void> recheckAvailability() async {
    await _init();
    await _refreshAvailability();
  }

  /// One-shot check, kept for backward compatibility. Prefer listening to
  /// [ttsAvailability] in UI instead of calling this from build().
  Future<bool> isPunjabiAvailable() async {
    await _init();
    return ttsAvailability.value == TtsAvailability.available;
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
        isSpeaking.value = false;
      }
    } catch (e) {
      debugPrint('TTS Error: $e');
      isSpeaking.value = false;
    }
  }

  Future<void> stop() async {
    await _tts.stop();
    isSpeaking.value = false;
  }

  /// Attempts to open the system Text-to-Speech settings so the user can
  /// install the Punjabi language pack if missing.
  Future<void> openTtsSettings() async {
    if (kIsWeb) return;
    if (defaultTargetPlatform != TargetPlatform.android) return;

    final Uri intentUri = Uri(
      scheme: 'intent',
      path: '#Intent;action=com.android.settings.TTS_SETTINGS;end',
    );

    try {
      await launchUrl(intentUri);
    } catch (e) {
      debugPrint('Error opening TTS settings via intent: $e');
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

  /// Success SFX
  Future<void> playSuccess() => _playSfx(
    'sounds/success.mp3',
    onError: () async {
      if (!kIsWeb) await SystemSound.play(SystemSoundType.click);
    },
    haptic: () => HapticFeedback.mediumImpact(),
  );

  /// Failure SFX
  Future<void> playFailure() => _playSfx(
    'sounds/failure.mp3',
    onError: () async {
      if (!kIsWeb) await HapticFeedback.heavyImpact();
    },
    haptic: () => HapticFeedback.selectionClick(),
  );

  /// Gem-earned SFX. Call whenever the user is awarded gems (e.g. on task
  /// completion, alongside `pointsAwarded`).
  Future<void> playGemEarned() => _playSfx(
    'sounds/gem_earned.mp3',
    onError: () async {
      if (!kIsWeb) await SystemSound.play(SystemSoundType.click);
    },
    haptic: () => HapticFeedback.lightImpact(),
  );

  /// Lesson-completed SFX. Call when the final section of a lesson is
  /// finished, alongside the confetti celebration.
  Future<void> playLessonCompleted() => _playSfx(
    'sounds/lesson-completed.mp3',
    onError: () async {
      if (!kIsWeb) await SystemSound.play(SystemSoundType.click);
    },
    haptic: () => HapticFeedback.mediumImpact(),
  );

  /// Game won SFX
  Future<void> playGameWon() => _playSfx(
    'sounds/game_won.mp3',
    onError: () async {},
    haptic: () => HapticFeedback.mediumImpact(),
  );

  /// Game over SFX
  Future<void> playGameOver() => _playSfx(
    'sounds/game_over.mp3',
    onError: () async {},
    haptic: () => HapticFeedback.heavyImpact(),
  );

  /// Call from provider dispose to release resources.
  void dispose() {
    for (final player in _sfxPool) {
      player.dispose();
    }
    _tts.stop();
    ttsAvailability.dispose();
    isSpeaking.dispose();
  }
}