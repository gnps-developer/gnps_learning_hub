import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/content_providers.dart';
import '../providers/progress_providers.dart';
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
    await ref.read(progressProvider.notifier).registerAppOpen();

    final journey = await journeyFuture;
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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'GNPS',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: onPrimary,
                letterSpacing: 4,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                'assets/logo/logo.jpg',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'ਪੰਜਾਬੀ ਸਿੱਖੋ',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(color: onPrimary),
            ),
            const SizedBox(height: 32),
            CircularProgressIndicator(color: onPrimary),
            const SizedBox(height: 16),
            Text(
              _statusText(syncState),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: onPrimary.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
