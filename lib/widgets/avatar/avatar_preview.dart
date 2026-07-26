import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/shop_item.dart';

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
    return item.id != DefaultItemIds.turbanNone &&
        item.id != DefaultItemIds.accessoryNone &&
        item.id != DefaultItemIds.clothesDefault;
  }

  @override
  Widget build(BuildContext context) {
    final base = _resolve(AvatarSlot.base);
    final turban = _resolve(AvatarSlot.turban);
    final clothes = _resolve(AvatarSlot.clothes);
    final accessory = _resolve(AvatarSlot.accessory);

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
                  // 1. Base Body
                  if (base?.imageAssetPath != null)
                    SvgPicture.asset(base!.imageAssetPath!, fit: BoxFit.contain)
                  else
                    Center(
                      child: Icon(
                        base?.icon ?? Icons.person,
                        size: refWidth * 0.6,
                        color: base?.color ?? Colors.grey.shade600,
                      ),
                    ),

                  // 2. Clothes
                  if (_isVisible(clothes))
                    _Layer(item: clothes!, avatarId: base?.id),

                  // 3. Accessory (Glasses, etc.)
                  if (_isVisible(accessory))
                    _Layer(item: accessory!, avatarId: base?.id),

                  // 4. Turban (On top)
                  if (_isVisible(turban))
                    _Layer(item: turban!, avatarId: base?.id),
                ],
              ),
            ),
          ),
        );
      },
    );
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
