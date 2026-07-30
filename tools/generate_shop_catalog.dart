// ignore_for_file: avoid_print
import 'dart:io';
import 'package:gnps_learning_hub/data/shop/shop_items.dart';
import 'package:gnps_learning_hub/models/avatar/avatar_slot.dart';
import 'package:gnps_learning_hub/models/shop/shop_item.dart';
import 'package:gnps_learning_hub/models/shop/shop_item_category.dart';
import 'package:gnps_learning_hub/models/shop/default_item_ids.dart';

/// Automatically generates SHOP_ITEMS.md from the app's shop data.
///
/// To run this tool, use:
/// ```bash
/// flutter test tool/generate_shop_catalog.dart
/// ```
void main() {
  final buffer = StringBuffer();
  buffer.writeln('# Shop Items Catalog - GNPS Learning Hub');
  buffer.writeln();
  buffer.writeln(
    'This document is automatically generated from the app\'s shop data.',
  );
  buffer.writeln();

  // Headwear
  _writeSection(
    buffer,
    '👳 Headwear',
    'Available for the Boy avatar.',
    purchasableItems.where((i) => i.avatarSlot == AvatarSlot.headwear).toList(),
  );

  // Clothes
  _writeSection(
    buffer,
    '👕 Clothes',
    'Traditional and formal outfits for both avatars.',
    purchasableItems.where((i) => i.avatarSlot == AvatarSlot.clothes).toList(),
  );

  // Accessories
  _writeSection(
    buffer,
    '🕶️ Accessories',
    'Eyewear to customize your character\'s look.',
    purchasableItems
        .where((i) => i.avatarSlot == AvatarSlot.accessory)
        .toList(),
  );

  // Power-ups
  _writeSection(
    buffer,
    '⚡ Power-ups',
    'Consumable items to help you on your learning journey.',
    purchasableItems
        .where((i) => i.category == ShopItemCategory.powerUp)
        .toList(),
    includeStackableColumn: true,
  );

  buffer.writeln();
  buffer.writeln('---');
  buffer.writeln('*Last Updated: ${DateTime.now().toString().split(' ')[0]}*');

  final file = File('SHOP_ITEMS.md');
  file.writeAsStringSync(buffer.toString());

  print('✅ SHOP_ITEMS.md has been refreshed!');
}

void _writeSection(
  StringBuffer buffer,
  String title,
  String description,
  List<ShopItem> items, {
  bool includeStackableColumn = false,
}) {
  if (items.isEmpty) return;

  buffer.writeln('## $title');
  buffer.writeln(description);
  buffer.writeln();

  if (includeStackableColumn) {
    buffer.writeln('| Item Name | Description | Avatar | Stackable | Price |');
    buffer.writeln('| :--- | :--- | :--- | :--- | :--- |');
  } else {
    buffer.writeln('| Item Name | Description | Avatar | Price |');
    buffer.writeln('| :--- | :--- | :--- | :--- |');
  }

  for (final item in items) {
    final name = '**${item.name}**';
    final price = '${item.price} 💎';

    final supportsBoy =
        item.supportedAvatarIds?.contains(DefaultItemIds.avatarBoy) ?? true;
    final supportsGirl =
        item.supportedAvatarIds?.contains(DefaultItemIds.avatarGirl) ?? true;

    String avatar = 'Both';
    if (supportsBoy && !supportsGirl) {
      avatar = 'Boy';
    } else if (!supportsBoy && supportsGirl) {
      avatar = 'Girl';
    }

    if (includeStackableColumn) {
      final stackable = item.stackable ? 'Yes' : 'No';
      buffer.writeln(
        '| $name | ${item.description} | $avatar | $stackable | $price |',
      );
    } else {
      buffer.writeln('| $name | ${item.description} | $avatar | $price |');
    }
  }
  buffer.writeln();
}
