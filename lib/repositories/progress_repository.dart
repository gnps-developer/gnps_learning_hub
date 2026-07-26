import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/progress.dart';

/// Reads/writes the user's local progress (points, streak, unlock state).
/// Stored entirely on-device via Hive — no auth, no cloud sync. If the
/// app is uninstalled, this data is gone by design.
class ProgressRepository {
  static const _boxName = 'progress';
  static const _progressKey = 'local_progress';

  Box? _box;

  Future<void> _ensureBox() async {
    _box ??= await Hive.openBox(_boxName);
  }

  Future<LocalProgress> load() async {
    await _ensureBox();
    final raw = _box!.get(_progressKey) as String?;
    if (raw == null) {
      final fresh = LocalProgress();
      await save(fresh);
      return fresh;
    }
    return LocalProgress.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> save(LocalProgress progress) async {
    await _ensureBox();
    await _box!.put(_progressKey, jsonEncode(progress.toJson()));
  }

  /// Wipes all saved progress. Used by the "Reset Progress" button.
  Future<void> clear() async {
    await _ensureBox();
    await _box!.delete(_progressKey);
  }
}
