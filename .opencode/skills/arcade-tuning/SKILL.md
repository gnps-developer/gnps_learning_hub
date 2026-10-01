---
name: Arcade Tuning
description: Use when tuning Bubble Pop / Crossword difficulty, spawn, hearts, trophies, high scores
---

## When to use
Changes to `lib/games/`, `lib/models/game_config.dart`, `lib/models/games/`, `lib/models/achievements/`, or `assets/data/games/*.json`.

## Config
`GameConfig{id,title,unlockAfterLessonId,type,content,requiresHearts,mapXOffset,mapYOffset}` per `lib/models/game_config.dart:3-26`. Current unlocks (`guides/CURRICULUM.md:119-121`): Letter Bubbles after `lesson_tracing`, Word Bubbles after `lesson_matching_words`, Crossword after `lesson_arrange_sentence`. `type: bubble_pop`, `requiresHearts` default true.

## Rules
1. Easy < Medium < Hard monotonically for speed, spawn rate, probability. Keep 3 tiers - do not add fourth without product approval.
2. Preserve Bronze/Silver/Gold thresholds + per-difficulty high scores in Trophy Room. Celebration overlay + halo/rays + avatar must still trigger.
3. Test physics with `flutter run --release` - debug mode stutters on Bubble Pop.
4. Hearts/gems wiring via `lib/providers/progress_providers.dart` + `shop_providers.dart`. Extra Heart 100 gems, Streak Freeze 250 gems (see `guides/SHOP_ITEMS.md:37-42`).
5. Game JSON `itemPool` audio handled by `audio-tts` skill - coordinate if adding words.
