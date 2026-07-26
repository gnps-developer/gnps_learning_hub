import 'shop_item.dart';

class LocalProgress {
  String? userName;
  int totalPoints;
  int currentStreak;
  DateTime? lastActiveDate;
  Set<String> completedLessonIds;
  Set<String> completedSectionIds;
  Set<String> unlockedLessonIds;
  Map<String, int> ownedItemQuantities;
  Map<String, String> equippedItemIds;
  bool soundEnabled;
  bool hapticsEnabled;
  int themeSeedColor;
  bool hasCompletedOnboarding;
  int dailyGoalMinutes;
  bool isDeveloperModeEnabled;

  static const Map<AvatarSlot, String> defaultEquippedItemIds = {
    AvatarSlot.base: DefaultItemIds.avatarBoy,
    AvatarSlot.turban: DefaultItemIds.turbanNone,
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
    Map<String, int>? ownedItemQuantities,
    Map<String, String>? equippedItemIds,
    this.soundEnabled = true,
    this.hapticsEnabled = true,
    this.themeSeedColor = 0xFF2196F3, // Colors.blue
    this.hasCompletedOnboarding = false,
    this.dailyGoalMinutes = 10,
    this.isDeveloperModeEnabled = false,
  }) : completedLessonIds = completedLessonIds ?? {},
       completedSectionIds = completedSectionIds ?? {},
       unlockedLessonIds = unlockedLessonIds ?? {},
       ownedItemQuantities = {
         ...defaultOwnedItemQuantities,
         ...(ownedItemQuantities ?? {}),
       },
       equippedItemIds =
           equippedItemIds ??
           defaultEquippedItemIds.map(
             (slot, itemId) => MapEntry(slot.name, itemId),
           );

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
      ownedItemQuantities: {
        ...defaultOwnedItemQuantities,
        ...Map<String, int>.from(
          (json['ownedItemQuantities'] as Map?)?.map(
                (key, value) => MapEntry(key as String, (value as num).toInt()),
              ) ??
              {},
        ),
      },
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
    'ownedItemQuantities': ownedItemQuantities,
    'equippedItemIds': equippedItemIds,
    'soundEnabled': soundEnabled,
    'hapticsEnabled': hapticsEnabled,
    'themeSeedColor': themeSeedColor,
    'hasCompletedOnboarding': hasCompletedOnboarding,
    'dailyGoalMinutes': dailyGoalMinutes,
    'isDeveloperModeEnabled': isDeveloperModeEnabled,
  };

  LocalProgress clone() => LocalProgress.fromJson(toJson());
}
