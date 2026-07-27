import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/avatar/avatar_slot.dart';
import '../../models/shop/shop_item.dart';
import '../../models/shop/default_item_ids.dart';

class AvatarPreview extends StatelessWidget {
  final Map<String, String> equippedItemIds;
  final List<ShopItem> catalog;

  const AvatarPreview({
    super.key,
    required this.equippedItemIds,
    required this.catalog,
  });

  ShopItem? _resolve(AvatarSlot slot) {
    final itemId = equippedItemIds[slot.name];
    if (itemId == null) return null;
    for (final item in catalog) {
      if (item.id == itemId) return item;
    }
    return null;
  }

  // "None" sentinel items exist so the shop/equip system always has a
  // valid default, but they shouldn't render a visible badge.
  bool _isVisible(ShopItem? item) {
    if (item == null) return false;
    return item.id != DefaultItemIds.headwearNone &&
        item.id != DefaultItemIds.accessoryNone &&
        item.id != DefaultItemIds.clothesDefault;
  }

  @override
  Widget build(BuildContext context) {
    final equippedItems = <AvatarSlot, ShopItem?>{
      for (final slot in AvatarSlot.values) slot: _resolve(slot),
    };

    final base = equippedItems[AvatarSlot.base];
    final skinTone = equippedItems[AvatarSlot.skinTone];

    // Sort slots by layerOrder to ensure correct stacking
    final sortedSlots = AvatarSlot.values.toList()
      ..sort((a, b) => a.layerOrder.compareTo(b.layerOrder));

    return LayoutBuilder(
      builder: (context, constraints) {
        const refWidth = 300.0;
        const refHeight = refWidth * 1.625; // 487.5

        final width = constraints.maxWidth;
        final height = width * 1.625; // Preserve ratio for the container

        return SizedBox(
          width: width,
          height: height,
          child: FittedBox(
            fit: BoxFit.contain,
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: refWidth,
              height: refHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  for (final slot in sortedSlots)
                    if (slot != AvatarSlot.skinTone) // skinTone is a property, not a layer
                      _buildLayer(slot, equippedItems[slot], base?.id, skinTone),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLayer(
    AvatarSlot slot,
    ShopItem? item,
    String? baseId,
    ShopItem? skinTone,
  ) {
    if (!_isVisible(item) && slot != AvatarSlot.base) {
      return const SizedBox.shrink();
    }

    if (slot == AvatarSlot.base) {
      if (item?.imageAssetPath != null) {
        return SvgPicture.asset(
          item!.imageAssetPath!,
          fit: BoxFit.contain,
          colorFilter: skinTone?.color != null
              ? ColorFilter.mode(skinTone!.color!, BlendMode.modulate)
              : null,
        );
      }
      return Center(
        child: Icon(
          item?.icon ?? Icons.person,
          size: 300 * 0.6,
          color: skinTone?.color ?? item?.color ?? Colors.grey.shade600,
        ),
      );
    }

    return _Layer(item: item!, avatarId: baseId);
  }
}

class _Layer extends StatelessWidget {
  final ShopItem item;
  final String? avatarId;

  const _Layer({required this.item, this.avatarId});

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (item.imageAssetPath != null) {
      child = SvgPicture.asset(item.imageAssetPath!, fit: BoxFit.contain);
    } else {
      // Fallback for non-SVG items (unlikely for layers, but kept for safety)
      child = Center(
        child: Icon(item.icon, size: 40, color: item.color),
      );
    }

    final transform = item.avatarTransforms?[avatarId];
    if (transform != null) {
      child = Transform.translate(
        offset: transform.offset,
        child: Transform.scale(
          scale: transform.scale,
          child: child,
        ),
      );
    }

    return child;
  }
}
