import 'package:flutter/material.dart';

enum ShopItemCategory { item, powerUp }

enum AvatarSlot { base, turban, clothes, accessory }

/// Canonical item IDs referenced across the app (default equips, seed data,
/// onboarding). Defined once here so shop_repository.dart and progress.dart
/// can never drift out of sync with each other.
class DefaultItemIds {
  DefaultItemIds._();

  static const avatarBoy = 'avatar_sikh_boy';
  static const avatarGirl = 'avatar_sikh_girl';
  static const turbanNone = 'turban_none';
  static const clothesDefault = 'clothes_default';
  static const accessoryNone = 'accessory_none';
  static const extraLife = 'powerup_extra_life';
}

class ShopItemDisplayConfig {
  final double scale;
  final double alignmentY;

  const ShopItemDisplayConfig({
    required this.scale,
    required this.alignmentY,
  });
}

class AvatarTransform {
  final Offset offset;
  final double scale;

  const AvatarTransform({
    this.offset = Offset.zero,
    this.scale = 1.0,
  });
}

class ShopItem {
  final String id;
  final String name;
  final String description;
  final IconData? icon;
  final Color? color;
  final String? imageAssetPath;
  final int price;
  final ShopItemCategory category;
  final bool stackable;
  final AvatarSlot? avatarSlot;
  final List<String>? supportedAvatarIds;
  final Map<String, AvatarTransform>? avatarTransforms;
  final ShopItemDisplayConfig? displayConfig;

  const ShopItem({
    required this.id,
    required this.name,
    required this.description,
    this.icon,
    this.color,
    this.imageAssetPath,
    required this.price,
    required this.category,
    this.stackable = false,
    this.avatarSlot,
    this.supportedAvatarIds,
    this.avatarTransforms,
    this.displayConfig,
  }) : assert(
         category != ShopItemCategory.item || avatarSlot != null,
         'Avatar items must specify an avatarSlot',
       ),
       assert(
         imageAssetPath != null || (icon != null && color != null),
         'Item must specify either imageAssetPath or both icon and color',
       );
}
