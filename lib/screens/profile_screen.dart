import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/reward_config.dart';
import '../models/shop_item.dart';
import '../providers/progress_providers.dart';
import '../providers/shop_providers.dart';
import 'avatar_customization_screen.dart';
import 'settings_screen.dart';
import 'streak_screen.dart';
import 'shop_screen.dart';
import '../widgets/avatar/avatar_preview.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _openStreakScreen(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const StreakScreen()));
  }

  void _openShopScreen(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ShopScreen()));
  }

  void _openSettingsScreen(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressProvider);
    final catalog = ref.watch(shopCatalogProvider); // List<ShopItem>, sync

    return progressAsync.when(
      data: (progress) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profile',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  IconButton(
                    onPressed: () => _openSettingsScreen(context),
                    icon: const Icon(Icons.settings, size: 40),
                    tooltip: 'Settings',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: _AvatarWithEditBadge(
                  equippedItemIds: progress.equippedItemIds,
                  catalog: catalog,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AvatarCustomizationScreen(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _NameField(currentName: progress.userName),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _openStreakScreen(context),
                      child: _StatCard(
                        icon: Icons.local_fire_department,
                        color: Colors.orange,
                        label: 'Streak',
                        value:
                            '${progress.currentStreak} day${progress.currentStreak == 1 ? '' : 's'}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _openShopScreen(context),
                      child: _StatCard(
                        icon: RewardConfig.icon,
                        color: RewardConfig.color,
                        label:
                            RewardConfig.labelPlural[0].toUpperCase() +
                            RewardConfig.labelPlural.substring(1),
                        value: '${progress.totalPoints}',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Lessons completed: ${progress.completedLessonIds.length}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error loading profile: $e')),
    );
  }
}

class _AvatarWithEditBadge extends StatelessWidget {
  final Map<String, String> equippedItemIds;
  final List<ShopItem> catalog;
  final VoidCallback onTap;

  const _AvatarWithEditBadge({
    required this.equippedItemIds,
    required this.catalog,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.grey.shade200,
            child: ClipOval(
              child: SizedBox(
                width: 96,
                height: 96,
                child: AvatarPreview(
                  equippedItemIds: equippedItemIds,
                  catalog: catalog,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -2,
            right: -2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.edit, size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _NameField extends ConsumerStatefulWidget {
  final String? currentName;

  const _NameField({required this.currentName});

  @override
  ConsumerState<_NameField> createState() => _NameFieldState();
}

class _NameFieldState extends ConsumerState<_NameField> {
  bool _isEditing = false;
  late final TextEditingController _controller = TextEditingController(
    text: widget.currentName ?? '',
  );
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() => _isEditing = true);
    FocusScope.of(context).requestFocus(_focusNode);
  }

  void _save() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      ref.read(progressProvider.notifier).updateUserName(name);
    } else {
      _controller.text = widget.currentName ?? '';
    }
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing) {
      return TextField(
        controller: _controller,
        focusNode: _focusNode,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        maxLength: 20,
        decoration: const InputDecoration(
          labelText: 'Your name',
          border: OutlineInputBorder(),
          isDense: true,
          counterText: "",
        ),
        onSubmitted: (_) => _save(),
        onTapOutside: (_) => _save(),
      );
    }

    final hasName =
        widget.currentName != null && widget.currentName!.isNotEmpty;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            hasName ? widget.currentName! : 'Add your name',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: hasName ? null : Theme.of(context).colorScheme.outline,
            ),
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: _startEditing,
          child: Icon(
            Icons.edit,
            size: 18,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
