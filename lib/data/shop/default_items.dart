import 'package:flutter/material.dart';
import '../../models/shop/shop_item.dart';
import '../../models/shop/shop_item_category.dart';
import '../../models/shop/default_item_ids.dart';
import '../../models/avatar/avatar_slot.dart';

const List<ShopItem> defaultItems = [
  ShopItem(
    id: DefaultItemIds.avatarBoy,
    name: 'Boy',
    description: 'Boy',
    imageAssetPath: 'assets/avatars/boy.svg',
    price: 0,
    category: ShopItemCategory.item,
    avatarSlot: AvatarSlot.base,
  ),
  ShopItem(
    id: DefaultItemIds.avatarGirl,
    name: 'Girl',
    description: 'Girl',
    imageAssetPath: 'assets/avatars/girl.svg',
    price: 0,
    category: ShopItemCategory.item,
    avatarSlot: AvatarSlot.base,
  ),
  ShopItem(
    id: DefaultItemIds.skinToneFair,
    name: 'Fair',
    description: 'Fair skin tone.',
    icon: Icons.circle,
    color: Color(0xFFFFDBAC),
    price: 0,
    category: ShopItemCategory.item,
    avatarSlot: AvatarSlot.skinTone,
  ),
  ShopItem(
    id: 'skin_tone_tan',
    name: 'Tan',
    description: 'Tan skin tone.',
    icon: Icons.circle,
    color: Color(0xFFE0AC69),
    price: 0,
    category: ShopItemCategory.item,
    avatarSlot: AvatarSlot.skinTone,
  ),
  ShopItem(
    id: DefaultItemIds.headwearNone,
    name: 'No Headwear',
    description: 'Bare-headed.',
    icon: Icons.circle_outlined,
    color: Colors.grey,
    price: 0,
    category: ShopItemCategory.item,
    avatarSlot: AvatarSlot.headwear,
  ),
  ShopItem(
    id: DefaultItemIds.clothesDefault,
    name: 'Casual Fit',
    description: 'Comfortable everyday clothes.',
    icon: Icons.circle_outlined,
    color: Colors.grey,
    price: 0,
    category: ShopItemCategory.item,
    avatarSlot: AvatarSlot.clothes,
  ),
  ShopItem(
    id: DefaultItemIds.accessoryNone,
    name: 'No Accessory',
    description: 'Keep it simple.',
    icon: Icons.circle_outlined,
    color: Colors.grey,
    price: 0,
    category: ShopItemCategory.item,
    avatarSlot: AvatarSlot.accessory,
  ),
];
