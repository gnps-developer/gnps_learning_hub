import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/progress.dart';
import '../models/avatar/avatar_slot.dart';
import '../models/shop/shop_item.dart';
import '../models/shop/shop_item_category.dart';
import '../providers/progress_providers.dart';
import '../providers/shop_providers.dart';
import '../widgets/avatar/avatar_preview.dart';

class AvatarCustomizationScreen extends ConsumerStatefulWidget {
  const AvatarCustomizationScreen({super.key});

  @override
  ConsumerState<AvatarCustomizationScreen> createState() =>
      _AvatarCustomizationScreenState();
}

class _AvatarCustomizationScreenState
    extends ConsumerState<AvatarCustomizationScreen> {
  AvatarSlot _selectedSlot = AvatarSlot.base;
  Map<String, String>? _preview;

  bool get _hasChanges {
    final progress = ref.read(progressProvider).value;
    if (progress == null || _preview == null) return false;
    final original = progress.equippedItemIds;
    for (final slot in AvatarSlot.values) {
      if (_preview![slot.name] != original[slot.name]) return true;
    }
    return false;
  }

  bool _isOwned(LocalProgress progress, ShopItem item) {
    return item.price == 0 || (progress.ownedItemQuantities[item.id] ?? 0) > 0;
  }

  Future<void> _confirm(LocalProgress progress, List<ShopItem> catalog) async {
    if (_preview == null) return;
    final notifier = ref.read(progressProvider.notifier);

    for (final slot in AvatarSlot.values) {
      final chosenId = _preview![slot.name];
      final originalId = progress.equippedItemIds[slot.name];
      if (chosenId == null || chosenId == originalId) continue;

      final item = catalog.firstWhere((i) => i.id == chosenId);
      await notifier.equipItem(item);
    }

    if (mounted) Navigator.of(context).pop();
  }

  Future<bool> _confirmDiscard() async {
    if (!_hasChanges) return true;
    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('You haven\'t saved your new look yet.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep editing'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return discard ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final progressAsync = ref.watch(progressProvider);
    final catalog = ref.watch(
      shopCatalogProvider,
    ); // now a plain List<ShopItem>

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmDiscard() && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Customize Avatar')),
        body: progressAsync.when(
          data: (progress) {
            _preview ??= Map<String, String>.from(progress.equippedItemIds);
            final currentBaseId = _preview![AvatarSlot.base.name];

            final avatarItems = catalog
                .where((i) => i.category == ShopItemCategory.item)
                .toList();

            final visibleSlots = AvatarSlot.values.where((slot) {
              if (slot == AvatarSlot.base) return true;
              return avatarItems.any((i) =>
                  i.avatarSlot == slot &&
                  (i.price == 0 || _isOwned(progress, i)) &&
                  (i.supportedAvatarIds == null ||
                      (currentBaseId != null &&
                          i.supportedAvatarIds!.contains(currentBaseId))));
            }).toList();

            // If selected slot is no longer visible (due to base change), revert to base
            if (!visibleSlots.contains(_selectedSlot)) {
              _selectedSlot = AvatarSlot.base;
            }

            final slotItems = avatarItems
                .where((i) => i.avatarSlot == _selectedSlot)
                .where((i) => i.price == 0 || _isOwned(progress, i))
                .where((i) =>
                    i.supportedAvatarIds == null ||
                    (currentBaseId != null &&
                        i.supportedAvatarIds!.contains(currentBaseId)))
                .toList();

            return Column(
              children: [
                const SizedBox(height: 16),
                SizedBox(
                  width: 300,
                  height: 375,
                  child: AvatarPreview(
                    equippedItemIds: _preview!,
                    catalog: catalog,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 44,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: visibleSlots.map((slot) {
                      final selected = slot == _selectedSlot;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(slot.displayName),
                          selected: selected,
                          onSelected: (_) =>
                              setState(() => _selectedSlot = slot),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: slotItems.isEmpty
                      ? Center(
                          child: Text(
                            'No owned items in this category yet.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                              ),
                          itemCount: slotItems.length,
                          itemBuilder: (context, index) {
                            final item = slotItems[index];
                            final selected =
                                _preview![_selectedSlot.name] == item.id;
                            return _ItemTile(
                              item: item,
                              selected: selected,
                              onTap: () => setState(() {
                                final newId = item.id;
                                _preview![_selectedSlot.name] = newId;

                                // If base changed, reset incompatible items in other slots
                                if (_selectedSlot == AvatarSlot.base) {
                                  for (final s in AvatarSlot.values) {
                                    if (s == AvatarSlot.base) continue;
                                    final eqId = _preview![s.name];
                                    if (eqId == null) continue;

                                    final eqItem = catalog.firstWhere(
                                      (i) => i.id == eqId,
                                      orElse: () => avatarItems.first,
                                    );

                                    if (eqItem.supportedAvatarIds != null &&
                                        !eqItem.supportedAvatarIds!
                                            .contains(newId)) {
                                      // Revert to slot default compatible with new base
                                      final fallback = avatarItems.firstWhere(
                                        (i) =>
                                            i.avatarSlot == s &&
                                            i.price == 0 &&
                                            (i.supportedAvatarIds == null ||
                                                i.supportedAvatarIds!
                                                    .contains(newId)),
                                        orElse: () => avatarItems.firstWhere(
                                            (i) => i.avatarSlot == s),
                                      );
                                      _preview![s.name] = fallback.id;
                                    }
                                  }
                                }
                              }),
                            );
                          },
                        ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: FilledButton(
                      onPressed: _hasChanges
                          ? () => _confirm(progress, catalog)
                          : null,
                      child: const Text('Confirm'),
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error loading progress: $e')),
        ),
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  final ShopItem item;
  final bool selected;
  final VoidCallback onTap;

  const _ItemTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tileColor = item.color ?? Colors.grey;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: item.imageAssetPath != null
              ? Colors.grey.withValues(alpha: 0.08)
              : tileColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: item.imageAssetPath != null
            ? Padding(
                padding: const EdgeInsets.all(4),
                child: SvgPicture.asset(item.imageAssetPath!),
              )
            : Icon(item.icon, color: tileColor, size: 28),
      ),
    );
  }
}
