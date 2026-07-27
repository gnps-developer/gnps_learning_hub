// ignore_for_file: avoid_print
import 'dart:io';
import 'package:gnps_learning_hub/data/shop/shop_items.dart';
import 'package:gnps_learning_hub/models/shop_item.dart';

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

  // Turbans
  _writeSection(
    buffer,
    '👳 Turbans',
    'Available for the Boy avatar.',
    purchasableItems.where((i) => i.avatarSlot == AvatarSlot.turban).toList(),
  );

  // Clothes
  _writeSection(
    buffer,
    '👕 Clothes',
    'Traditional and formal outfits for both avatars.',
    purchasableItems.where((i) => i.avatarSlot == AvatarSlot.clothes).toList(),
    includeAvatarColumn: true,
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

  buffer.writeln('---');
  buffer.writeln();
  buffer.writeln('### 🛠️ Maintenance');
  buffer.writeln('To refresh this document after modifying shop data, run:');
  buffer.writeln('```bash');
  buffer.writeln('flutter test tool/generate_shop_catalog.dart');
  buffer.writeln('```');
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
  bool includeAvatarColumn = false,
  bool includeStackableColumn = false,
}) {
  if (items.isEmpty) return;

  buffer.writeln('## $title');
  buffer.writeln(description);
  buffer.writeln();

  if (includeAvatarColumn) {
    buffer.writeln('| Item Name | Description | Avatar | Price |');
    buffer.writeln('| :--- | :--- | :--- | :--- |');
  } else if (includeStackableColumn) {
    buffer.writeln('| Item Name | Description | Stackable | Price |');
    buffer.writeln('| :--- | :--- | :--- | :--- |');
  } else {
    buffer.writeln('| Item Name | Description | Price |');
    buffer.writeln('| :--- | :--- | :--- |');
  }

  for (final item in items) {
    final name = '**${item.name}**';
    final price = '${item.price} 💎';
    
    if (includeAvatarColumn) {
      String avatar = 'Both';
      if (item.supportedAvatarIds?.contains(DefaultItemIds.avatarBoy) ?? false) {
        avatar = 'Boy';
      } else if (item.supportedAvatarIds?.contains(DefaultItemIds.avatarGirl) ?? false) {
        avatar = 'Girl';
      }
      buffer.writeln('| $name | ${item.description} | $avatar | $price |');
    } else if (includeStackableColumn) {
      final stackable = item.stackable ? 'Yes' : 'No';
      buffer.writeln('| $name | ${item.description} | $stackable | $price |');
    } else {
      buffer.writeln('| $name | ${item.description} | $price |');
    }
  }
  buffer.writeln();
}
