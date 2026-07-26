import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/journey.dart';
import '../models/progress.dart';
import '../models/shop_item.dart';
import '../repositories/progress_repository.dart';
import '../services/audio_service.dart';
import '../services/progress_service.dart';
import 'audio_providers.dart';

final progressRepositoryProvider = Provider((ref) => ProgressRepository());

final progressServiceProvider = Provider((ref) {
  return ProgressService(ref.read(progressRepositoryProvider));
});

class ProgressNotifier extends StateNotifier<AsyncValue<LocalProgress>> {
  final ProgressRepository _repository;
  final ProgressService _service;
  final AudioService _audioService;
  late final Future<void> _initialLoad;

  ProgressNotifier(this._repository, this._service, this._audioService)
    : super(const AsyncValue.loading()) {
    _initialLoad = _load();
  }

  Future<void> _load() async {
    try {
      final progress = await _repository.load();
      _audioService.soundEnabled = progress.soundEnabled;
      _audioService.hapticsEnabled = progress.hapticsEnabled;
      state = AsyncValue.data(progress);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> registerAppOpen() async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return;
    final updated = await _service.registerAppOpen(current);
    state = AsyncValue.data(updated);
  }

  Future<void> ensureFirstLessonUnlocked(Journey journey) async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return;
    final updated = await _service.ensureFirstLessonUnlocked(current, journey);
    state = AsyncValue.data(updated);
  }

  Future<void> completeSection({
    required Journey journey,
    required String lessonId,
    required String sectionId,
    required int points,
  }) async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return;
    final updated = await _service.completeSection(
      progress: current,
      journey: journey,
      lessonId: lessonId,
      sectionId: sectionId,
      pointsEarned: points,
    );
    state = AsyncValue.data(updated);
  }

  /// DEBUG ONLY. See ProgressService.debugCompleteAllLessons.
  Future<void> debugCompleteAllLessons(Journey journey) async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return;
    final updated = await _service.debugCompleteAllLessons(
      progress: current,
      journey: journey,
    );
    state = AsyncValue.data(updated);
  }

  /// DEBUG ONLY. Manually updates progress for a specific lesson.
  Future<void> debugUpdateLessonProgress({
    required Journey journey,
    required String lessonId,
    required double percent,
  }) async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return;
    final updated = await _service.debugUpdateLessonProgress(
      progress: current,
      journey: journey,
      lessonId: lessonId,
      percent: percent,
    );
    state = AsyncValue.data(updated);
  }

  Future<PurchaseResult> purchaseItem(ShopItem item) async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return PurchaseResult.insufficientGems;
    final (updated, result) = await _service.purchaseItem(
      progress: current,
      item: item,
    );
    state = AsyncValue.data(updated);
    return result;
  }

  Future<void> equipItem(ShopItem item) async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return;
    final updated = await _service.equipItem(current, item);
    state = AsyncValue.data(updated);
  }

  Future<void> reset() async {
    await _initialLoad;
    await _repository.clear();
    final fresh = LocalProgress();
    await _repository.save(fresh);
    state = AsyncValue.data(fresh);
  }

  Future<void> updateUserName(String name) async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return;
    final updated = await _service.updateUserName(current, name);
    state = AsyncValue.data(updated);
  }

  Future<void> updateSoundEnabled(bool enabled) async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return;
    final updated = await _service.updateSoundEnabled(current, enabled);
    _audioService.soundEnabled = enabled;
    state = AsyncValue.data(updated);
  }

  Future<void> updateHapticsEnabled(bool enabled) async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return;
    final updated = await _service.updateHapticsEnabled(current, enabled);
    _audioService.hapticsEnabled = enabled;
    state = AsyncValue.data(updated);
  }

  Future<void> updateThemeSeedColor(int colorValue) async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return;
    final updated = await _service.updateThemeSeedColor(current, colorValue);
    state = AsyncValue.data(updated);
  }

  Future<void> updateDailyGoal(int minutes) async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return;
    final updated = await _service.updateDailyGoal(current, minutes);
    state = AsyncValue.data(updated);
  }

  Future<void> addPoints(int points) async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return;
    final updated = await _service.addPoints(current, points);
    state = AsyncValue.data(updated);
  }

  Future<void> consumeItem(String itemId) async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return;
    final updated = await _service.consumeItem(current, itemId);
    state = AsyncValue.data(updated);
  }

  Future<void> completeOnboarding() async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return;
    final updated = await _service.completeOnboarding(current);
    state = AsyncValue.data(updated);
  }

  Future<void> updateDeveloperMode(bool enabled) async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return;
    final updated = await _service.updateDeveloperMode(current, enabled);
    state = AsyncValue.data(updated);
  }
}

final progressProvider =
    StateNotifierProvider<ProgressNotifier, AsyncValue<LocalProgress>>((ref) {
      return ProgressNotifier(
        ref.read(progressRepositoryProvider),
        ref.read(progressServiceProvider),
        ref.read(audioServiceProvider),
      );
    });
