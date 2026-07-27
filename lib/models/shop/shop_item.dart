import 'package:flutter/material.dart';
import '../avatar/avatar_slot.dart';
import '../avatar/avatar_transform.dart';
import 'shop_item_category.dart';
import 'shop_item_display_config.dart';

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
