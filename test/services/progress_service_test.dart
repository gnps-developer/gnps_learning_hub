import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gnps_learning_hub/models/progress.dart';
import 'package:gnps_learning_hub/models/games/game_difficulty.dart';
import 'package:gnps_learning_hub/models/shop/default_item_ids.dart';
import 'package:gnps_learning_hub/models/shop/shop_item.dart';
import 'package:gnps_learning_hub/models/shop/shop_item_category.dart';
import 'package:gnps_learning_hub/repositories/progress_repository.dart';
import 'package:gnps_learning_hub/services/progress_service.dart';
import 'package:mocktail/mocktail.dart';

class MockProgressRepository extends Mock implements ProgressRepository {}

void main() {
  late ProgressService service;
  late MockProgressRepository mockRepository;

  setUp(() {
    mockRepository = MockProgressRepository();
    service = ProgressService(mockRepository);
    
    registerFallbackValue(LocalProgress());
    when(() => mockRepository.save(any())).thenAnswer((_) async {});
  });

  group('ProgressService', () {
    test('registerAppOpen should increment streak on consecutive days', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final progress = LocalProgress(
        currentStreak: 5,
        lastActiveDate: DateTime(yesterday.year, yesterday.month, yesterday.day),
      );
      
      final result = await service.registerAppOpen(progress);
      
      expect(result.currentStreak, 6);
      verify(() => mockRepository.save(any())).called(1);
    });

    test('registerAppOpen should reset streak if day was missed', () async {
      final longAgo = DateTime.now().subtract(const Duration(days: 3));
      final progress = LocalProgress(
        currentStreak: 5,
        lastActiveDate: DateTime(longAgo.year, longAgo.month, longAgo.day),
      );
      
      final result = await service.registerAppOpen(progress);
      
      expect(result.currentStreak, 1);
    });

    test('registerAppOpen should use Streak Freezes for multi-day gaps', () async {
      final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
      final progress = LocalProgress(
        currentStreak: 10,
        lastActiveDate: DateTime(threeDaysAgo.year, threeDaysAgo.month, threeDaysAgo.day),
        ownedItemQuantities: {DefaultItemIds.streakFreeze: 5},
      );

      final result = await service.registerAppOpen(progress);

      // 3 days ago -> gap of 2 days (Day 2, Day 1 missed).
      // Today is Day 0.
      // Gap = dayDiff - 1 = 3 - 1 = 2 days.
      expect(result.currentStreak, 13); // 10 (orig) + 2 (frozen) + 1 (today)
      expect(result.ownedItemQuantities[DefaultItemIds.streakFreeze], 3);
      expect(result.frozenDates.length, 2);
    });

    test('registerAppOpen should reset if not enough Streak Freezes', () async {
      final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
      final progress = LocalProgress(
        currentStreak: 10,
        lastActiveDate: DateTime(threeDaysAgo.year, threeDaysAgo.month, threeDaysAgo.day),
        ownedItemQuantities: {DefaultItemIds.streakFreeze: 1},
      );

      final result = await service.registerAppOpen(progress);

      expect(result.currentStreak, 1);
      expect(result.ownedItemQuantities[DefaultItemIds.streakFreeze], 1); // Not consumed
      expect(result.frozenDates.isEmpty, true);
    });

    test('purchaseItem should award item and deduct points on success', () async {
      final progress = LocalProgress(totalPoints: 200);
      const item = ShopItem(
        id: 'test_item',
        name: 'Test',
        description: 'D',
        price: 50,
        category: ShopItemCategory.powerUp,
        stackable: true,
        icon: Icons.star,
        color: Colors.blue,
      );
      
      final (updated, result) = await service.purchaseItem(
        progress: progress,
        item: item,
      );
      
      expect(result, PurchaseResult.success);
      expect(updated.totalPoints, 150);
      expect(updated.ownedItemQuantities['test_item'], 1);
    });

    test('purchaseItem should fail if insufficient points', () async {
      final progress = LocalProgress(totalPoints: 10);
      const item = ShopItem(
        id: 'expensive',
        name: 'T',
        description: 'D',
        price: 50,
        category: ShopItemCategory.powerUp,
        icon: Icons.star,
        color: Colors.blue,
      );
      
      final (_, result) = await service.purchaseItem(
        progress: progress,
        item: item,
      );
      
      expect(result, PurchaseResult.insufficientGems);
    });

    test('recordGameScore should update high score and unlock next level',
        () async {
      final progress = LocalProgress(
        gameHighScores: {
          'game1': {'easy': 100}
        },
        unlockedGameDifficulties: {'game1': 0},
      );

      final result = await service.recordGameScore(
        progress: progress,
        gameId: 'game1',
        score: 150,
        difficulty: GameDifficulty.easy,
        won: true,
      );

      expect(result.gameHighScores['game1']!['easy'], 150);
      expect(result.unlockedGameDifficulties['game1'], 1); // Unlocked Medium
    });
  });
}
