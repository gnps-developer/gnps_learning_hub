import 'package:flutter_test/flutter_test.dart';
import 'package:gnps_learning_hub/models/progress.dart';

void main() {
  group('LocalProgress', () {
    test('should initialize with default values', () {
      final progress = LocalProgress();
      
      expect(progress.totalPoints, 0);
      expect(progress.currentStreak, 0);
      expect(progress.soundEnabled, true);
      expect(progress.hapticsEnabled, true);
      expect(progress.hasCompletedOnboarding, false);
      expect(progress.ownedItemQuantities.isNotEmpty, true);
      expect(progress.equippedItemIds.isNotEmpty, true);
    });

    test('should support deep cloning via clone()', () {
      final original = LocalProgress(
        userName: 'Test',
        totalPoints: 100,
        unlockedLessonIds: {'l1'},
      );
      
      final cloned = original.clone();
      
      expect(cloned.userName, original.userName);
      expect(cloned.totalPoints, original.totalPoints);
      expect(cloned.unlockedLessonIds, contains('l1'));
      
      // Verify independence
      cloned.totalPoints = 200;
      cloned.unlockedLessonIds.add('l2');
      
      expect(original.totalPoints, 100);
      expect(original.unlockedLessonIds, isNot(contains('l2')));
    });

    test('should serialize to and from JSON correctly', () {
      final date = DateTime(2024, 1, 1);
      final original = LocalProgress(
        userName: 'JSON Test',
        totalPoints: 50,
        lastActiveDate: date,
      );
      
      final json = original.toJson();
      final fromJson = LocalProgress.fromJson(json);
      
      expect(fromJson.userName, 'JSON Test');
      expect(fromJson.totalPoints, 50);
      expect(fromJson.lastActiveDate, date);
    });
  });
}
