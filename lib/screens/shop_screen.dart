import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/reward_config.dart';
import '../models/progress.dart';
import '../models/avatar/avatar_slot.dart';
import '../models/shop/shop_item.dart';
import '../models/shop/shop_item_category.dart';
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

    return progressAsync.when(
      data: (progress) => _ShopContent(progress: progress),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => const Center(child: Text('Could not load shop.')),
    );
  }
}

class _ShopContent extends ConsumerStatefulWidget {
  final LocalProgress progress;

  const _ShopContent({required this.progress});

  @override
  ConsumerState<_ShopContent> createState() => _ShopContentState();
}

class _ShopContentState extends ConsumerState<_ShopContent> {
  String _selectedFilter = 'All';

  Future<void> _buy(BuildContext context, ShopItem item) async {
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
  Widget build(BuildContext context) {
    final service = ref.read(progressServiceProvider);
    final catalog = ref.watch(shopCatalogProvider);

    final currentBaseId = widget.progress.equippedItemIds[AvatarSlot.base.name];

    final purchasableCatalog = catalog.where((i) {
      final isPurchasable = i.price > 0;
      final isCompatible = i.supportedAvatarIds == null ||
          (currentBaseId != null &&
              i.supportedAvatarIds!.contains(currentBaseId));
      return isPurchasable && isCompatible;
    }).toList();

    // Determine available filters based on content
    final List<String> filters = ['All'];
    if (purchasableCatalog.any((i) => i.category == ShopItemCategory.powerUp)) {
      filters.add('Power-ups');
    }
    for (final slot in AvatarSlot.values) {
      if (slot == AvatarSlot.base || slot == AvatarSlot.skinTone) continue;
      if (purchasableCatalog.any((i) => i.avatarSlot == slot)) {
        filters.add(slot.displayName);
      }
    }

    final filteredItems = purchasableCatalog.where((i) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Power-ups') {
        return i.category == ShopItemCategory.powerUp;
      }
      return i.avatarSlot?.displayName == _selectedFilter;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shop',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              GemBalance(points: widget.progress.totalPoints),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 44,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: filters.length,
            itemBuilder: (context, index) {
              final filter = filters[index];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(filter),
                  selected: _selectedFilter == filter,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedFilter = filter);
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: filteredItems.isEmpty
              ? const Center(child: Text('No items found.'))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return ShopItemCard(
                      item: item,
                      owned: service.isItemOwned(widget.progress, item.id),
                      quantity: service.itemQuantity(widget.progress, item.id),
                      canAfford: widget.progress.totalPoints >= item.price,
                      onBuy: () => _buy(context, item),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
