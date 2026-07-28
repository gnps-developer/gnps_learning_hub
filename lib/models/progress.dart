import 'avatar/avatar_slot.dart';
import 'shop/default_item_ids.dart';

class LocalProgress {
  String? userName;
  int totalPoints;
  int currentStreak;
  DateTime? lastActiveDate;
  Set<String> completedLessonIds;
  Set<String> completedSectionIds;
  Set<String> unlockedLessonIds;
  Set<String> frozenDates;
  Map<String, int> ownedItemQuantities;
  Map<String, String> equippedItemIds;
  Map<String, Map<String, int>> gameHighScores;
  Map<String, int> unlockedGameDifficulties;
  bool soundEnabled;
  bool hapticsEnabled;
  int themeSeedColor;
  bool hasCompletedOnboarding;
  int dailyGoalMinutes;
  bool isDeveloperModeEnabled;

  static const Map<AvatarSlot, String> defaultEquippedItemIds = {
    AvatarSlot.base: DefaultItemIds.avatarBoy,
    AvatarSlot.skinTone: DefaultItemIds.skinToneFair,
    AvatarSlot.headwear: DefaultItemIds.headwearNone,
    AvatarSlot.clothes: DefaultItemIds.clothesDefault,
    AvatarSlot.accessory: DefaultItemIds.accessoryNone,
  };

  static const Map<String, int> defaultOwnedItemQuantities = {
    DefaultItemIds.extraLife: 3,
  };

  LocalProgress({
    this.userName,
    this.totalPoints = 0,
    this.currentStreak = 0,
    this.lastActiveDate,
    Set<String>? completedLessonIds,
    Set<String>? completedSectionIds,
    Set<String>? unlockedLessonIds,
    Set<String>? frozenDates,
    Map<String, int>? ownedItemQuantities,
    Map<String, String>? equippedItemIds,
    Map<String, Map<String, int>>? gameHighScores,
    Map<String, int>? unlockedGameDifficulties,
    this.soundEnabled = true,
    this.hapticsEnabled = true,
    this.themeSeedColor = 0xFF2196F3, // Colors.blue
    this.hasCompletedOnboarding = false,
    this.dailyGoalMinutes = 10,
    this.isDeveloperModeEnabled = false,
  }) : completedLessonIds = completedLessonIds ?? {},
       completedSectionIds = completedSectionIds ?? {},
       unlockedLessonIds = unlockedLessonIds ?? {},
       frozenDates = frozenDates ?? {},
       ownedItemQuantities = {
         ...defaultOwnedItemQuantities,
         ...(ownedItemQuantities ?? {}),
       },
       equippedItemIds =
           equippedItemIds ??
           defaultEquippedItemIds.map(
             (slot, itemId) => MapEntry(slot.name, itemId),
           ),
       gameHighScores = gameHighScores ?? {},
       unlockedGameDifficulties = unlockedGameDifficulties ?? {};

  factory LocalProgress.fromJson(Map<String, dynamic> json) {
    return LocalProgress(
      userName: json['userName'] as String?,
      totalPoints: (json['totalPoints'] as num?)?.toInt() ?? 0,
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      lastActiveDate: json['lastActiveDate'] != null
          ? DateTime.tryParse(json['lastActiveDate'] as String)
          : null,
      completedLessonIds: Set<String>.from(
        json['completedLessonIds'] as List? ?? [],
      ),
      completedSectionIds: Set<String>.from(
        json['completedSectionIds'] as List? ?? [],
      ),
      unlockedLessonIds: Set<String>.from(
        json['unlockedLessonIds'] as List? ?? [],
      ),
      frozenDates: Set<String>.from(
        json['frozenDates'] as List? ?? [],
      ),
      ownedItemQuantities: {
        ...defaultOwnedItemQuantities,
        ...Map<String, int>.from(
          (json['ownedItemQuantities'] as Map?)?.map(
                (key, value) => MapEntry(key as String, (value as num).toInt()),
              ) ??
              {},
        ),
      },
      gameHighScores: (json['gameHighScores'] as Map?)?.map(
            (k, v) => MapEntry(
              k as String,
              Map<String, int>.from(
                (v as Map).map(
                  (kd, vd) => MapEntry(kd as String, (vd as num).toInt()),
                ),
              ),
            ),
          ) ??
          {},
      unlockedGameDifficulties: Map<String, int>.from(
        (json['unlockedGameDifficulties'] as Map?)?.map(
              (key, value) => MapEntry(key as String, (value as num).toInt()),
            ) ??
            {},
      ),
      equippedItemIds: {
        ...defaultEquippedItemIds.map(
          (slot, itemId) => MapEntry(slot.name, itemId),
        ),
        ...Map<String, String>.from(
          (json['equippedItemIds'] as Map?)?.map(
                (key, value) => MapEntry(key as String, value as String),
              ) ??
              {},
        ),
      },
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      hapticsEnabled: json['hapticsEnabled'] as bool? ?? true,
      themeSeedColor: (json['themeSeedColor'] as num?)?.toInt() ?? 0xFF2196F3,
      hasCompletedOnboarding: json['hasCompletedOnboarding'] as bool? ?? false,
      dailyGoalMinutes: (json['dailyGoalMinutes'] as num?)?.toInt() ?? 10,
      isDeveloperModeEnabled: json['isDeveloperModeEnabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'userName': userName,
    'totalPoints': totalPoints,
    'currentStreak': currentStreak,
    'lastActiveDate': lastActiveDate?.toIso8601String(),
    'completedLessonIds': completedLessonIds.toList(),
    'completedSectionIds': completedSectionIds.toList(),
    'unlockedLessonIds': unlockedLessonIds.toList(),
    'frozenDates': frozenDates.toList(),
    'ownedItemQuantities': ownedItemQuantities,
    'equippedItemIds': equippedItemIds,
    'gameHighScores': gameHighScores,
    'unlockedGameDifficulties': unlockedGameDifficulties,
    'soundEnabled': soundEnabled,
    'hapticsEnabled': hapticsEnabled,
    'themeSeedColor': themeSeedColor,
    'hasCompletedOnboarding': hasCompletedOnboarding,
    'dailyGoalMinutes': dailyGoalMinutes,
    'isDeveloperModeEnabled': isDeveloperModeEnabled,
  };

  LocalProgress clone() => LocalProgress.fromJson(toJson());
}
