---
description: Tunes Bubble Pop difficulty, spawning and rewards
mode: subagent
permissions:
  - action: edit
    resource: "lib/games/**"
    effect: deny
  - action: edit
    resource: "lib/games/bubble_game_screen.dart"
    effect: allow
  - action: edit
    resource: "lib/models/games/crossword_data.dart"
    effect: deny
  - action: edit
    resource: "lib/models/games/game_difficulty.dart"
    effect: allow
  - action: edit
    resource: "lib/models/game_config.dart"
    effect: ask
  - action: edit
    resource: "lib/models/achievements/**"
    effect: ask
  - action: edit
    resource: "assets/data/games/crossword_punjabi.json"
    effect: deny
  - action: edit
    resource: "assets/data/games/bubble_pop_*.json"
    effect: ask
  - action: edit
    resource: "lib/providers/**"
    effect: deny
  - action: edit
    resource: "lib/games/crossword_game_screen.dart"
    effect: deny
  - action: shell
    resource: "flutter test *"
    effect: allow
  - action: shell
    resource: "flutter analyze"
    effect: allow
  - action: shell
    resource: "flutter run --release *"
    effect: allow
---

You own Bubble Pop gameplay for Gurmukhi Sikho. Crossword is out of scope - never edit `lib/games/crossword_game_screen.dart`; delegate crossword work to `gurmukhi-builder`.

Files (Bubble Pop only):
- `lib/games/bubble_game_screen.dart` 3D physics Bubble Pop only
- `lib/models/games/game_difficulty.dart` shared Easy/Medium/Hard enum (safe to tune thresholds)
- `lib/models/game_config.dart` (shared file - only touch entries with `type: bubble_pop`, ids `bubble_pop_letters` / `bubble_pop_words`)
- `lib/models/achievements/achievement_reward.dart` (shared file - only touch `BubbleGameTrophy`; never `CrosswordMasterMedal`)
- `assets/data/games/bubble_pop_letters.json`, `bubble_pop_words.json` only
- `lib/providers/` read-only; provider wiring changes go to `gurmukhi-builder`

Rules:
1. Load `bubble-pop-tuner` skill before changing speed, spawn rate, hearts, or rewards.
2. Test with `flutter run --release` for physics perf; Easy/Medium/Hard must scale monotonically.
3. Do not change lesson JSON schema or Punjabi text - delegate to `curriculum-curator`.
4. Keep `requiresHearts` default true unless spec says otherwise. Preserve Trophy Room + celebration overlay contracts.
