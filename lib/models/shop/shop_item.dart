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

  factory ShopItem.fromJson(Map<String, dynamic> json) {
    return ShopItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] != null ? _iconMapping[json['icon'] as String] : null,
      color: json['color'] != null ? Color(json['color'] as int) : null,
      imageAssetPath: json['imageAssetPath'] as String?,
      price: json['price'] as int,
      category: ShopItemCategory.values.firstWhere(
        (e) => e.name == json['category'],
      ),
      stackable: json['stackable'] as bool? ?? false,
      avatarSlot:
          json['avatarSlot'] != null
              ? AvatarSlot.values.firstWhere((e) => e.name == json['avatarSlot'])
              : null,
      supportedAvatarIds: (json['supportedAvatarIds'] as List?)?.cast<String>(),
      avatarTransforms:
          json['avatarTransforms'] != null
              ? (json['avatarTransforms'] as Map<String, dynamic>).map(
                (key, value) => MapEntry(
                  key,
                  AvatarTransform.fromJson(value as Map<String, dynamic>),
                ),
              )
              : null,
      displayConfig:
          json['displayConfig'] != null
              ? ShopItemDisplayConfig.fromJson(
                json['displayConfig'] as Map<String, dynamic>,
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'icon': _reverseIconMapping[icon],
    'color': color?.toARGB32(),
    'imageAssetPath': imageAssetPath,
    'price': price,
    'category': category.name,
    'stackable': stackable,
    'avatarSlot': avatarSlot?.name,
    'supportedAvatarIds': supportedAvatarIds,
    'avatarTransforms': avatarTransforms?.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
    'displayConfig': displayConfig?.toJson(),
  };

  static const Map<String, IconData> _iconMapping = {
    'ac_unit': Icons.ac_unit,
    'favorite': Icons.favorite,
    'circle': Icons.circle,
    'circle_outlined': Icons.circle_outlined,
  };

  static final Map<IconData?, String?> _reverseIconMapping =
      _iconMapping.map((key, value) => MapEntry(value, key));
}
