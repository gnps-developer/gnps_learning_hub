---
name: Lesson Authoring
description: Use when creating or editing assets/data/lessons/*.json or games/*.json tasks and sections
---

## When to use
New lesson, section, task, or changing `pointsAwarded`, `order`, `visible`, `shuffleSections/Tasks`.

## Schema
`Lesson{id,title,order,sections}` per `lib/models/lesson.dart:32-58`. `Task{id,type,pointsAwarded,content}` per `lib/models/task.dart:13-24`. Types per `lib/models/task_type.dart:1-9`: `trace, letterSelection, spelling, matchingPictures, matchingWords, fillInBlank, arrangeSentence`.

Examples from repo:
- trace (`assets/data/lessons/tracing.json:10-108`): `{letter: "ੳ", transliteration: "oorhaa", checkpoints: [[{x,y}...]], audioFile: "audio/lessons/alphabets/ura.mp3"}`
- spelling (`assets/data/lessons/spelling.json:10-26`): `{emoji: "🐱", targetWord: "ਬਿੱਲੀ", letterBank: ["ਬਿ","ੱ","ਲੀ","ਮ","ਅ"], audioFile: "audio/lessons/words/cat.mp3"}`

## Workflow
1. Load `punjabi-qa` skill for all Punjabi strings. Load `audio-tts` if new `audioFile` needed.
2. Keep IDs stable (`lesson_tracing`, `trace_01`), `order` unique sequential, section IDs `section_*`.
3. `pointsAwarded`: trace 10, spelling 15 (follow existing file unless told otherwise).
4. Validate: parse JSON, check `taskTypeFromString` names exact, `letterBank` must assemble `targetWord`.
5. Run `dart tools/appcontent/generate_curriculum.dart` to refresh `guides/CURRICULUM.md` (7 lessons / 532 tasks baseline).
6. Run `flutter test test/curriculum_integrity_test.dart`.
