import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gnps_learning_hub/screens/splash_screen.dart';
import 'package:gnps_learning_hub/providers/progress_providers.dart';
import 'package:gnps_learning_hub/providers/content_providers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gnps_learning_hub/models/progress.dart';
import 'package:gnps_learning_hub/models/journey.dart';
import 'package:gnps_learning_hub/services/progress_service.dart';
import 'package:gnps_learning_hub/repositories/progress_repository.dart';
import 'package:gnps_learning_hub/services/audio_service.dart';

class MockProgressRepository extends Mock implements ProgressRepository {}

class MockAudioService extends Mock implements AudioService {}

class MockJourneySyncNotifier extends StateNotifier<JourneySyncState>
    implements JourneySyncNotifier {
  MockJourneySyncNotifier() : super(const JourneyChecking());

  @override
  final ready = Completer<Journey>().future;
}

void main() {
  setUpAll(() {
    registerFallbackValue(LocalProgress());
  });

  testWidgets('Splash screen smoke test', (WidgetTester tester) async {
    final mockProgressRepo = MockProgressRepository();
    final mockAudio = MockAudioService();
    final mockSync = MockJourneySyncNotifier();

    when(
      () => mockProgressRepo.load(),
    ).thenAnswer((_) async => LocalProgress());
    when(() => mockProgressRepo.save(any())).thenAnswer((_) async {});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          progressProvider.overrideWith(
            (ref) => ProgressNotifier(
              mockProgressRepo,
              ProgressService(mockProgressRepo),
              mockAudio,
            ),
          ),
          journeySyncProvider.overrideWith((ref) => mockSync),
        ],
        child: const MaterialApp(home: SplashScreen()),
      ),
    );

    expect(find.text('GNPS'), findsOneWidget);

    // Cleanup
    await tester.pumpWidget(Container());
  });
}
