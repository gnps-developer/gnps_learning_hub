import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/ui_config.dart';
import '../../config/ui_strings.dart';
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
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _rotationController;
  late Animation<double> _haloScale;
  late Animation<double> _trophyScale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.celebration,
    );

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

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
    _rotationController.dispose();
    super.dispose();
  }

  Color _getTrophyColor() {
    switch (widget.difficultyIndex) {
      case 1:
        return AppColors.bronze;
      case 2:
        return AppColors.silver;
      case 3:
        return AppColors.gold;
      default:
        return AppColors.gold;
    }
  }

  String _getTrophyName() {
    switch (widget.difficultyIndex) {
      case 1:
        return UIStrings.trophyBronze;
      case 2:
        return UIStrings.trophySilver;
      case 3:
        return UIStrings.trophyGold;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final progressAsync = ref.watch(progressProvider);
    final catalogAsync = ref.watch(shopCatalogProvider);

    return Material(
      color: Colors.transparent,
      child: progressAsync.when(
        data: (progress) => catalogAsync.when(
          data: (catalogItems) => Stack(
            alignment: Alignment.center,
            children: [
              // Light Rays (Rotating in the background)
              FadeTransition(
                opacity: _opacity,
                child: AnimatedBuilder(
                  animation: _rotationController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationController.value * 2 * pi,
                      child: CustomPaint(
                        painter: _LightRaysPainter(
                          color: _getTrophyColor().withValues(alpha: 0.15),
                          rayCount: 16,
                        ),
                        size: const Size(600, 600),
                      ),
                    );
                  },
                ),
              ),

              // Avatar and Trophy container
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background Halo (Enhanced)
                      AnimatedBuilder(
                        animation: _haloScale,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _haloScale.value,
                            child: Container(
                              width: 320,
                              height: 320,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    _getTrophyColor().withValues(alpha: 0.7),
                                    _getTrophyColor().withValues(alpha: 0.2),
                                    _getTrophyColor().withValues(alpha: 0.0),
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
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
                            catalog: catalogItems,
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
                  const SizedBox(height: AppSpacing.xxl),
                  // Text and Button
                  FadeTransition(
                    opacity: _opacity,
                    child: Column(
                      children: [
                        Text(
                          UIStrings.trophyUnlocked(_getTrophyName()),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          UIStrings.forGame(widget.gameTitle),
                          style: const TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
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
                              borderRadius: BorderRadius.circular(AppSpacing.md),
                            ),
                          ),
                          child: const Text(
                            UIStrings.continueCapsLabel,
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
          error: (_, _) => const SizedBox.shrink(),
        ),
        loading: () => const SizedBox.shrink(),
        error: (_, _) => const SizedBox.shrink(),
      ),
    );
  }
}

class _LightRaysPainter extends CustomPainter {
  final Color color;
  final int rayCount;

  _LightRaysPainter({required this.color, required this.rayCount});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = max(size.width, size.height) * 1.5;
    final angleStep = (2 * pi) / rayCount;

    for (int i = 0; i < rayCount; i++) {
      final startAngle = i * angleStep;
      final path = Path();
      path.moveTo(center.dx, center.dy);
      
      // Draw a thin triangle/ray
      path.lineTo(
        center.dx + radius * cos(startAngle - angleStep / 4),
        center.dy + radius * sin(startAngle - angleStep / 4),
      );
      path.lineTo(
        center.dx + radius * cos(startAngle + angleStep / 4),
        center.dy + radius * sin(startAngle + angleStep / 4),
      );
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
