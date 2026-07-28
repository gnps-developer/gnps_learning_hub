import 'package:flutter/material.dart';
import '../../config/reward_config.dart';
import '../../config/ui_config.dart';
import '../../config/ui_strings.dart';

import '../../models/progress.dart';
import '../../models/shop/shop_item.dart';
import '../../screens/streak_screen.dart';
import '../../widgets/avatar/avatar_preview.dart';

/// A compact strip on the Journey screen: a profile avatar + friendly
/// greeting on the left, streak + points at a glance on the right.
class JourneyBanner extends StatelessWidget {
  final LocalProgress progress;
  final List<ShopItem> catalog;
  final VoidCallback? onTapGems;
  final VoidCallback? onTapAchievements;

  const JourneyBanner({
    super.key,
    required this.progress,
    required this.catalog,
    this.onTapGems,
    this.onTapAchievements,
  });

  void _openStreakScreen(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const StreakScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.ms,
        AppSpacing.ms,
        AppSpacing.ms,
        AppSpacing.xs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                CircleAvatar(
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
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    UIStrings.greeting(progress.userName),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Row(
            children: [
              _StatPill(
                icon: Icons.favorite,
                color: AppColors.heart,
                value:
                    '${progress.ownedItemQuantities['powerup_extra_life'] ?? 0}',
              ),
              const SizedBox(width: AppSpacing.xs),
              GestureDetector(
                onTap: () => _openStreakScreen(context),
                child: _StatPill(
                  icon: Icons.local_fire_department,
                  color: AppColors.streak,
                  value: '${progress.currentStreak}',
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              GestureDetector(
                onTap: onTapAchievements,
                child: _StatPill(
                  icon: Icons.emoji_events,
                  color: AppColors.gold,
                  value:
                      '${progress.unlockedGameDifficulties.values.fold<int>(0, (sum, val) => sum + val)}',
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              GestureDetector(
                onTap: onTapGems,
                child: _StatPill(
                  icon: RewardConfig.icon,
                  color: RewardConfig.color,
                  value: '${progress.totalPoints}',
                ),
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 3),
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
