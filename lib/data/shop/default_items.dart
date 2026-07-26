import 'package:flutter/material.dart';
import '../../models/shop_item.dart';

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
    id: DefaultItemIds.turbanNone,
    name: 'No Turban',
    description: 'Bare-headed.',
    icon: Icons.circle_outlined,
    color: Colors.grey,
    price: 0,
    category: ShopItemCategory.item,
    avatarSlot: AvatarSlot.turban,
    supportedAvatarIds: [DefaultItemIds.avatarBoy],
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
