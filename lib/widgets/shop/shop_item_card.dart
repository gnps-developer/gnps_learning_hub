import 'package:flutter/material.dart';
import '../../config/reward_config.dart';
import '../../models/shop/shop_item.dart';

import 'shop_item_display.dart';

class ShopItemCard extends StatelessWidget {
  final ShopItem item;
  final bool owned;
  final int quantity;
  final bool canAfford;
  final VoidCallback onBuy;

  const ShopItemCard({
    super.key,
    required this.item,
    required this.owned,
    required this.quantity,
    required this.canAfford,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    final isSoldOut = owned && !item.stackable;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ShopItemDisplay(item: item),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 1),
                      Text(
                        item.name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                      ),
                      Text(
                        item.description,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                              fontSize: 9,
                            ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (item.stackable && quantity > 0)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 1),
                          child: Text(
                            'Owned: $quantity',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 9,
                                ),
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        height: 30,
                        child: isSoldOut
                            ? const OutlinedButton(
                                onPressed: null,
                                child: Text('Owned', style: TextStyle(fontSize: 11)),
                              )
                            : ElevatedButton(
                                onPressed: canAfford ? onBuy : null,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  visualDensity: VisualDensity.compact,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(RewardConfig.icon, size: 11),
                                    const SizedBox(width: 2),
                                    Text(
                                      '${item.price}',
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
