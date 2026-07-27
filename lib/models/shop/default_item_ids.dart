/// Canonical item IDs referenced across the app (default equips, seed data,
/// onboarding). Defined once here so shop_repository.dart and progress.dart
/// can never drift out of sync with each other.
class DefaultItemIds {
  DefaultItemIds._();

  static const avatarBoy = 'avatar_sikh_boy';
  static const avatarGirl = 'avatar_sikh_girl';
  static const headwearNone = 'headwear_none';
  static const clothesDefault = 'clothes_default';
  static const accessoryNone = 'accessory_none';
  static const skinToneFair = 'skin_tone_fair';
  static const extraLife = 'powerup_extra_life';
  static const streakFreeze = 'powerup_streak_freeze';
}
