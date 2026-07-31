import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/journey.dart';

class ContentRepository {
  static const _boxName = 'content_cache';
  static const _journeyKey = 'journey';

  Box? _box;

  Future<void> _ensureBox() async {
    _box ??= await Hive.openBox(_boxName);
  }

  Future<Journey> getBundledJourney() async {
    try {
      // 1. Load manifest
      final manifestStr =
          await rootBundle.loadString('assets/data/journey_manifest.json');
      final manifest = jsonDecode(manifestStr) as Map<String, dynamic>;

      if (!manifest.containsKey('version') ||
          !manifest.containsKey('lessonFiles') ||
          !manifest.containsKey('gameFiles')) {
        throw const FormatException(
          'journey_manifest.json is missing required fields (version, lessonFiles, or gameFiles)',
        );
      }

      final version = manifest['version'] as int;
      final lessonFiles = (manifest['lessonFiles'] as List).cast<String>();
      final gameFiles = (manifest['gameFiles'] as List).cast<String>();

      // 2. Load games
      final gamesJson = <Map<String, dynamic>>[];
      for (final file in gameFiles) {
        final gameStr = await rootBundle.loadString('assets/data/games/$file');
        gamesJson.add(jsonDecode(gameStr) as Map<String, dynamic>);
      }

      // 3. Load lessons
      final lessonsJson = <Map<String, dynamic>>[];
      for (final file in lessonFiles) {
        final lessonStr =
            await rootBundle.loadString('assets/data/lessons/$file');
        lessonsJson.add(jsonDecode(lessonStr) as Map<String, dynamic>);
      }

      return Journey.fromJson({
        'version': version,
        'lessons': lessonsJson,
        'games': gamesJson,
      });
    } catch (e) {
      // Re-throw with more context if it's a structural error we caught
      if (e is FormatException || e is TypeError) {
        throw Exception('Failed to load bundled content: $e');
      }
      rethrow;
    }
  }

  Future<Journey> getLocalJourney() async {
    await _ensureBox();
    final cached = _box!.get(_journeyKey) as String?;

    if (cached == null) {
      return getBundledJourney();
    }

    try {
      return Journey.fromJson(
        jsonDecode(cached) as Map<String, dynamic>,
      );
    } catch (e) {
      return getBundledJourney();
    }
  }

  Future<void> cacheJourney(Journey journey) async {
    await _ensureBox();
    await _box!.put(_journeyKey, jsonEncode(journey.toJson()));
  }

  /// Convenience wrapper for callers that just want the end result and
  /// don't care about the intermediate "checking" / "installing" steps.
  Future<Journey> checkForUpdatesAndSync() async {
    final local = await getLocalJourney();
    final bundled = await getBundledJourney();

    // If bundled data is newer than cache, use that as the new baseline.
    if (bundled.version > local.version) {
      await cacheJourney(bundled);
      return bundled;
    }

    return local;
  }

  /// Wipes the cached content, forcing the next load to fall back to
  /// bundled mock data (or re-fetch from Firestore). Used by the
  /// "Reset Progress" button so testers don't have to clear app storage.
  Future<void> clearCache() async {
    await _ensureBox();
    await _box!.delete(_journeyKey);
  }
}
