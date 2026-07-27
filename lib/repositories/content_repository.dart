import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/journey_data.dart';
import '../models/journey.dart';

class ContentRepository {
  static const _boxName = 'content_cache';
  static const _journeyKey = 'journey';

  Box? _box;

  Future<void> _ensureBox() async {
    _box ??= await Hive.openBox(_boxName);
  }

  Future<Journey> getLocalJourney() async {
    await _ensureBox();
    final cached = _box!.get(_journeyKey) as String?;

    if (cached == null) {
      return journeyData;
    }

    try {
      return Journey.fromJson(
        jsonDecode(cached) as Map<String, dynamic>,
      );
    } catch (e) {
      return journeyData;
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

    // If bundled data is newer than cache, use that as the new baseline.
    if (journeyData.version > local.version) {
      await cacheJourney(journeyData);
      return journeyData;
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
