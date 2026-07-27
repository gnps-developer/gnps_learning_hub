import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/avatar/avatar_slot.dart';
import '../../models/shop/shop_item.dart';

class ShopItemDisplay extends StatelessWidget {
  final ShopItem item;

  const ShopItemDisplay({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        // Maintain a square aspect ratio for the display area
        final height = width;

        if (item.imageAssetPath == null) {
          return SizedBox(
            width: width,
            height: height,
            child: Center(child: Icon(item.icon, color: item.color, size: width * 0.5)),
          );
        }

        // Determine the focus area.
        Alignment alignment;
        double scale;

        if (item.displayConfig != null) {
          alignment = Alignment(0, item.displayConfig!.alignmentY);
          scale = item.displayConfig!.scale;
        } else {
          switch (item.avatarSlot) {
            case AvatarSlot.headwear:
              alignment = const Alignment(0, -0.95);
              scale = 1.4;
              break;
            case AvatarSlot.accessory:
              alignment = const Alignment(0, -0.45);
              scale = 2.0;
              break;
            case AvatarSlot.clothes:
              alignment = const Alignment(0, 0.4);
              scale = 1.3;
              break;
            case AvatarSlot.base:
              alignment = Alignment.center;
              scale = 1.0;
              break;
            default:
              alignment = Alignment.center;
              scale = 1.0;
          }
        }

        return SizedBox(
          width: width,
          height: height,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            child: OverflowBox(
              minWidth: width,
              maxWidth: width * scale,
              minHeight: height,
              maxHeight: height * scale * (650 / 400),
              child: Transform.scale(
                scale: scale,
                alignment: alignment,
                child: SvgPicture.asset(
                  item.imageAssetPath!,
                  width: width,
                  height: width * (650 / 400),
                  fit: BoxFit.contain,
                  alignment: alignment,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
