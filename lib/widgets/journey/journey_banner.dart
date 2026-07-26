import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/reward_config.dart';

import '../../providers/progress_providers.dart';
import '../../providers/shop_providers.dart';
import '../../screens/streak_screen.dart';
import '../../widgets/avatar/avatar_preview.dart';

/// A compact strip on the Journey screen: a profile avatar + friendly
/// greeting on the left, streak + points at a glance on the right.
class JourneyBanner extends ConsumerWidget {
  final int streak;
  final int points;
  final int hearts;

  const JourneyBanner({
    super.key,
    required this.streak,
    required this.points,
    required this.hearts,
  });

  void _openStreakScreen(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const StreakScreen()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressProvider);
    final catalog = ref.watch(shopCatalogProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                progressAsync.when(
                  data: (progress) => CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey.shade200,
                    child: ClipOval(
                      child: SizedBox(
                        width: 36,
                        height: 36,
                        child: AvatarPreview(
                          equippedItemIds: progress.equippedItemIds,
                          catalog: catalog,
                        ),
                      ),
                    ),
                  ),
                  loading: () => const CircleAvatar(radius: 18),
                  error: (_, _) => const CircleAvatar(
                    radius: 18,
                    child: Icon(Icons.person, size: 18),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: progressAsync.when(
                    data: (progress) => Text(
                      'Hi${progress.userName != null && progress.userName!.isNotEmpty ? ', ${progress.userName}' : ' there'}! 👋',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const Text('Hi there! 👋'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              _StatPill(
                icon: Icons.favorite,
                color: Colors.red,
                value: '$hearts',
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _openStreakScreen(context),
                child: _StatPill(
                  icon: Icons.local_fire_department,
                  color: Colors.orange,
                  value: '$streak',
                ),
              ),
              const SizedBox(width: 10),
              _StatPill(
                icon: RewardConfig.icon,
                color: RewardConfig.color,
                value: '$points',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;

  const _StatPill({
    required this.icon,
    required this.color,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 6),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
