import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnps_learning_hub/providers/progress_providers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Enable edge-to-edge support on Android
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    statusBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  ));

  await Hive.initFlutter();

  runApp(const ProviderScope(child: LearningHubApp()));
}

class LearningHubApp extends ConsumerWidget {
  const LearningHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressProvider);
    final seedColor = progressAsync.maybeWhen(
      data: (progress) => Color(progress.themeSeedColor),
      orElse: () => Colors.deepOrange,
    );

    return MaterialApp(
      title: 'Gurmukhi Sikho',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        useMaterial3: true,
      ),
      builder: (context, child) {
        if (!kIsWeb) return child!;
        
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        
        // Use a background color derived from the theme
        final outerBackground = isDark 
            ? theme.colorScheme.surfaceContainerLow
            : theme.colorScheme.primaryContainer.withValues(alpha: 0.3);

        return Container(
          color: outerBackground,
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobileWidth = constraints.maxWidth < 600;
                
                // 100% width on mobile, 95% on tablets, max 800px on desktop
                final width = isMobileWidth 
                    ? constraints.maxWidth 
                    : (constraints.maxWidth < 840 
                        ? constraints.maxWidth * 0.95 
                        : 800.0);

                return Container(
                  width: width,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: isMobileWidth ? null : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRect(
                    child: child!,
                  ),
                );
              },
            ),
          ),
        );
      },
      home: const SplashScreen(),
    );
  }
}
