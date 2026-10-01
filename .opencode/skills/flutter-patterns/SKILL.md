---
name: Flutter Patterns
description: Use for any lib/**/*.dart edit - Riverpod providers, Hive models, screens, services, widgets conventions
---

## When to use
Any Dart edit in `lib/`, new provider/model/screen, or `flutter analyze` / build_runner failure.

## Stack
`pubspec.yaml`: `flutter_riverpod ^2.5.1`, `hive ^2.2.3`, `hive_flutter`, `audioplayers ^6.8.1`, `flutter_svg`, `package_info_plus`, `url_launcher`, `crypto`. Material 3, `flutter_lints` via `analysis_options.yaml`.

## Layout - do not add new top-level dirs
- `lib/config/` constants/strings/debug
- `lib/models/lesson.dart`, `task.dart`, `task_type.dart`, `journey.dart`, `progress.dart`, `game_config.dart`, `achievements/`, `avatar/`, `shop/`, `games/`
- `lib/providers/content_providers.dart`, `progress_providers.dart`, `audio_providers.dart`, `shop_providers.dart`, `navigation_providers.dart`
- `lib/repositories/` JSON loading + Hive persistence
- `lib/screens/`, `lib/services/`, `lib/tools/`, `lib/utils/`, `lib/widgets/`

## Rules
1. State in `lib/providers/`, persistence in `lib/repositories/` + Hive. Models are type-safe with `fromJson/toJson` - see `lib/models/lesson.dart:14-29`, `lib/models/task.dart:26-33`.
2. After touching `lib/models/*.dart`: run `dart run build_runner build --delete-conflicting-outputs`.
3. `flutter analyze` must pass. No `print` in `lib/`/`test/`.
4. Reuse `lib/widgets/` atoms, `lib/config/` strings/colors. Haptics + TTS via `lib/services/`.
5. Unlock dev tools via Settings > App Version x10 only - never hardcode secret.
