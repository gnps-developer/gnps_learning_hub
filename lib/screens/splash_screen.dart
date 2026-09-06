import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/ui_strings.dart';
import '../models/journey.dart';
import '../providers/content_providers.dart';
import '../providers/progress_providers.dart';
import '../providers/shop_providers.dart';
import 'intro_screen.dart';
import 'journey_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // Kick off content sync + progress loading in parallel.
    final journeyFuture = ref.read(journeySyncProvider.notifier).ready;
    final shopFuture = ref.read(shopCatalogProvider.future);
    await ref.read(progressProvider.notifier).registerAppOpen();

    final results = await Future.wait([journeyFuture, shopFuture]);
    final journey = results[0] as Journey;

    await ref
        .read(progressProvider.notifier)
        .ensureFirstLessonUnlocked(journey);

    // After "Ready!" is shown (via JourneyReady state), wait a brief moment before transitioning.
    await Future.delayed(const Duration(milliseconds: 400));

    if (mounted) {
      final progress = ref.read(progressProvider).value;
      final nextScreen = (progress?.hasCompletedOnboarding ?? false)
          ? const JourneyScreen()
          : const IntroScreen();

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => nextScreen));
    }
  }

  String _statusText(JourneySyncState syncState) {
    return switch (syncState) {
      JourneyChecking() => 'Checking for updates…',
      JourneyInstallingUpdate(:final toVersion) =>
        'Installing new content (v$toVersion)…',
      JourneyReady() => 'Ready!',
    };
  }

  @override
  Widget build(BuildContext context) {
    final syncState = ref.watch(journeySyncProvider);
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  UIStrings.appNameCaps,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: onPrimary,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 24),
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.asset(
                    'assets/logo/logo.jpg',
                    width: 240,
                    height: 240,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  UIStrings.appNameGurmukhi,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: onPrimary, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: onPrimary,
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _statusText(syncState),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: onPrimary.withValues(alpha: 0.7),
                      ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  UIStrings.byGNPS,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: onPrimary.withValues(alpha: 0.7),
                        letterSpacing: 5,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
