import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gnps_learning_hub/models/progress.dart';
import 'package:gnps_learning_hub/models/shop_item.dart';
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
  });
}
