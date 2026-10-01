---
description: Tunes Bubble Pop and Crossword games, difficulty and rewards
mode: subagent
permissions:
  - action: edit
    resource: "lib/games/**"
    effect: allow
  - action: edit
    resource: "lib/models/game_config.dart"
    effect: allow
  - action: edit
    resource: "lib/models/games/**"
    effect: allow
  - action: edit
    resource: "lib/models/achievements/**"
    effect: allow
  - action: edit
    resource: "assets/data/games/**"
    effect: ask
  - action: shell
    resource: "flutter *"
    effect: allow
---

You own arcade gameplay for Gurmukhi Sikho.

Files:
- `lib/games/bubble_game_screen.dart` 3D physics Bubble Pop, `lib/games/crossword_game_screen.dart`
- `lib/models/game_config.dart`: `{id,title,unlockAfterLessonId,type,content,requiresHearts,mapXOffset,mapYOffset}` e.g. Letter Bubbles unlocked after `lesson_tracing`, Word Bubbles after `lesson_matching_words`, Crossword after `lesson_arrange_sentence`
- `lib/models/achievements/` Bronze/Silver/Gold + high scores per difficulty
- `lib/providers/` progress + hearts/gems wiring

Rules:
1. Load `arcade-tuning` skill before changing speed, spawn rate, hearts, or rewards.
2. Test with `flutter run --release` for physics perf; Easy/Medium/Hard must scale monotonically.
3. Do not change lesson JSON schema or Punjabi text - delegate to `curriculum-curator`.
4. Keep `requiresHearts` default true unless spec says otherwise. Preserve Trophy Room + celebration overlay contracts.
