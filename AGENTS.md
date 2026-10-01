# AGENTS.md - Gurmukhi Sikho

Flutter (stable) + Riverpod 2.x + Hive. Entry `lib/main.dart`: `ProviderScope`, portrait-only, `Hive.initFlutter()`, web wrapper max 800px.

## Commands (order matters)
- `flutter pub get`
- After any `lib/models/*.dart` change: `dart run build_runner build --delete-conflicting-outputs`
- Verify: `flutter analyze` then `flutter test test/curriculum_integrity_test.dart` then full `flutter test`
- Single widget test: `flutter test test/widgets/tasks/spelling_task_widget_test.dart`
- Physics perf: `flutter run --release` (Bubble Pop stutters in debug)
- Curriculum docs: `dart tools/appcontent/generate_curriculum.dart` (updates `guides/CURRICULUM.md`); shop: `dart tools/appcontent/generate_shop_catalog.dart`
- Audio (embedded, Google TTS `tl=pa`): `dart tools/appaudio/generate_audio.dart` / `dart tools/appaudio/generate_audio.dart lesson_tracing lesson_spelling` / `dart tools/appaudio/generate_audio.dart --word "ਸਤਿਨਾਮ" --path "audio/lessons/words/satnam.mp3"` / add `--force` to overwrite
- Brochure (requires Chrome): `dart tools/brochure/generate_full_brochure.dart`, `dart tools/brochure/generate_one_pager.dart` -> `exports/brochure/`
- Release: must be on `develop`; `./tools/release/prepare_release.sh v1.0.X` (runs integrity test, tags); after store live `./tools/release/finish_release.sh` (ff-only `develop` -> `main`). Codemagic triggers on `develop` push: analyze + test + AAB/APK/IPA + web (`--base-href /gurmukhi-sikho-webapp/`).

## Architecture
- `lib/providers/` (Riverpod) + `lib/repositories/` (Hive + JSON loading) + `lib/models/` (`lesson.dart`, `task.dart`, `task_type.dart`, `journey.dart`, `progress.dart`, `game_config.dart`). No new top-level `lib/` dirs.
- Content: `assets/data/lessons/*.json` (7 files), `assets/data/games/*.json`. `TaskType`: `trace, letterSelection, spelling, matchingPictures, matchingWords, fillInBlank, arrangeSentence` (`lib/models/task_type.dart`).
- Games: `lib/games/bubble_game_screen.dart`, `crossword_game_screen.dart`; unlocks via `GameConfig.unlockAfterLessonId` (Letter Bubbles after `lesson_tracing`, Word Bubbles after `lesson_matching_words`, Crossword after `lesson_arrange_sentence`).
- Economy: `lib/models/avatar/`, `shop/`, `shop_providers.dart`; SVG via `flutter_svg`; power-ups stackable, cosmetics not.

## Content invariants (enforced by tests - do not bypass)
- `test/curriculum_integrity_test.dart`: every task needs `audioFile` except `matchingWords` which needs `itemPool`; no null/empty/whitespace-padded strings; `spelling.targetWord` must be buildable from `letterBank` (longest-tile-first); distractors must not contain answer; `fillInBlank.options` must contain `correctWord`; `arrangeSentence.words.length == correctOrder.length`.
- `test/audio_assets_test.dart`: strict 1:1 - no missing mp3, no extra mp3 in `assets/audio/`, every audio dir must be listed in `pubspec.yaml`, `assets/sounds/` must contain exactly the 6 system sounds.
- Punjabi: Gurmukhi U+0A00-U+0A7F only; trace needs `letter` + `transliteration`; `audioFile` paths lowercase e.g. `audio/lessons/words/cat.mp3`.

## OpenCode
- Default agent `gurmukhi-builder` (`.opencode/opencode.jsonc`). Subagents: `curriculum-curator`, `bubble-pop-tuner`, `crossword-tuner`, `qa-reviewer` (read-only), `release-manager`.
- Skills in `.opencode/skills/`: `flutter-patterns`, `lesson-authoring`, `punjabi-qa`, `audio-tts`, `bubble-pop-tuner`, `avatar-shop`, `release-brochure`. Load before touching that domain.
