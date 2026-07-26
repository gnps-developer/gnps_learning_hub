import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/reward_config.dart';
import '../models/progress.dart';
import '../models/shop_item.dart';
import '../providers/progress_providers.dart';
import '../providers/shop_providers.dart';
import '../services/progress_service.dart';
import '../widgets/shop/gem_balance.dart';
import '../widgets/shop/shop_item_card.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Shop')),
      body: SafeArea(
        child: progressAsync.when(
          data: (progress) => _ShopContent(progress: progress),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => const Center(child: Text('Could not load shop.')),
        ),
      ),
    );
  }
}

class _ShopContent extends ConsumerWidget {
  final LocalProgress progress;

  const _ShopContent({required this.progress});

  String _categoryLabel(ShopItemCategory category) {
    switch (category) {
      case ShopItemCategory.item:
        return 'Items';
      case ShopItemCategory.powerUp:
        return 'Power-ups';
    }
  }

  Future<void> _buy(BuildContext context, WidgetRef ref, ShopItem item) async {
    final result = await ref.read(progressProvider.notifier).purchaseItem(item);
    if (!context.mounted) return;

    final message = switch (result) {
      PurchaseResult.success => 'You bought ${item.name}!',
      PurchaseResult.insufficientGems =>
        'Not enough ${RewardConfig.labelPlural} yet.',
      PurchaseResult.alreadyOwned => 'You already own ${item.name}.',
    };

    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.read(progressServiceProvider);
    final catalog = ref.watch(shopCatalogProvider);

    final currentBaseId = progress.equippedItemIds[AvatarSlot.base.name];

    // Free default items (price 0) exist so every avatar slot always has
    // something equipped, but they're not meant to be "bought" — hide
    // them from the shop grid so this screen only shows real purchases.
    // Also filter by compatibility with the currently equipped base avatar.
    final purchasableCatalog = catalog.where((i) {
      final isPurchasable = i.price > 0;
      final isCompatible = i.supportedAvatarIds == null ||
          (currentBaseId != null &&
              i.supportedAvatarIds!.contains(currentBaseId));
      return isPurchasable && isCompatible;
    }).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      children: [
        GemBalance(points: progress.totalPoints),
        const SizedBox(height: 24),
        for (final category in ShopItemCategory.values)
          if (purchasableCatalog.any((i) => i.category == category)) ...[
            Text(
              _categoryLabel(category),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.64,
              children: [
                for (final item in purchasableCatalog.where(
                  (i) => i.category == category,
                ))
                  ShopItemCard(
                    item: item,
                    owned: service.isItemOwned(progress, item.id),
                    quantity: service.itemQuantity(progress, item.id),
                    canAfford: progress.totalPoints >= item.price,
                    onBuy: () => _buy(context, ref, item),
                  ),
              ],
            ),
            const SizedBox(height: 24),
          ],
      ],
    );
  }
}
