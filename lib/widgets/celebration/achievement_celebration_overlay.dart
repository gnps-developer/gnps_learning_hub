import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/progress.dart';
import '../../models/shop/shop_item.dart';
import '../../providers/progress_providers.dart';
import '../../providers/shop_providers.dart';
import '../avatar/avatar_preview.dart';

class AchievementCelebrationOverlay extends ConsumerStatefulWidget {
  final String gameTitle;
  final int difficultyIndex; // 1=Bronze, 2=Silver, 3=Gold
  final VoidCallback onDismiss;

  const AchievementCelebrationOverlay({
    super.key,
    required this.gameTitle,
    required this.difficultyIndex,
    required this.onDismiss,
  });

  @override
  ConsumerState<AchievementCelebrationOverlay> createState() =>
      _AchievementCelebrationOverlayState();
}

class _AchievementCelebrationOverlayState
    extends ConsumerState<AchievementCelebrationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _haloScale;
  late Animation<double> _trophyScale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _haloScale = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.elasticOut),
      ),
    );

    _trophyScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.bounceOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getTrophyColor() {
    switch (widget.difficultyIndex) {
      case 1:
        return const Color(0xFFCD7F32); // Bronze
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFFFD700); // Gold
      default:
        return Colors.amber;
    }
  }

  String _getTrophyName() {
    switch (widget.difficultyIndex) {
      case 1:
        return 'Bronze';
      case 2:
        return 'Silver';
      case 3:
        return 'Gold';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final progressAsync = ref.watch(progressProvider);
    final catalog = ref.watch(shopCatalogProvider);

    return Material(
      color: Colors.transparent,
      child: progressAsync.when(
        data: (progress) => Stack(
          alignment: Alignment.center,
          children: [
            // Avatar and Trophy container
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background Halo
                    AnimatedBuilder(
                      animation: _haloScale,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _haloScale.value,
                          child: Container(
                            width: 280,
                            height: 280,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  _getTrophyColor().withValues(alpha: 0.6),
                                  _getTrophyColor().withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // Avatar
                    FadeTransition(
                      opacity: _opacity,
                      child: SizedBox(
                        width: 220,
                        height: 350,
                        child: AvatarPreview(
                          equippedItemIds: progress.equippedItemIds,
                          catalog: catalog,
                        ),
                      ),
                    ),

                    // Trophy (In front of avatar, beneath face)
                    AnimatedBuilder(
                      animation: _trophyScale,
                      builder: (context, child) {
                        return Positioned(
                          bottom: 20, // Positioned near the bottom of the avatar container
                          child: Transform.scale(
                            scale: _trophyScale.value,
                            child: Icon(
                              Icons.emoji_events,
                              color: _getTrophyColor(),
                              size: 110,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  blurRadius: 15,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Text and Button
                FadeTransition(
                  opacity: _opacity,
                  child: Column(
                    children: [
                      Text(
                        '${_getTrophyName()} Trophy Unlocked!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'for ${widget.gameTitle}',
                        style: const TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                      const SizedBox(height: 48),
                      FilledButton(
                        onPressed: widget.onDismiss,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 56,
                            vertical: 18,
                          ),
                          backgroundColor: _getTrophyColor(),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'CONTINUE',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }
}
