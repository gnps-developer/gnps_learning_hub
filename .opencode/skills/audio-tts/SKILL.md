---
name: Audio TTS
description: Use when lesson or game JSON needs new audioFile mp3 - generates via tools/appaudio
---

## When to use
New `letter`, `targetWord`, `word`, `fullSentence`, or `itemPool` entry without existing mp3, or `--force` regeneration.

## How it works
`tools/appaudio/generate_audio.dart:19-135` scans `assets/data/lessons/*.json` + `assets/data/games/*.json` for explicit `audioFile` fields, extracts text via `_extractExplicitAudio` (`tools/appaudio/generate_audio.dart:137-176`):
- `audioFile` + `letter` / `targetWord` / `correctLetter` / `word` / `fullSentence`
- `content.itemPool` map entries `{punjabi: audioPath}` or `{punjabi: {audio: path}}`
Downloads via Google TTS `tl=pa`, 700ms throttle, skips existing unless `--force`. Output under `assets/<audioFile>` e.g. `assets/audio/lessons/words/cat.mp3`, `assets/audio/lessons/alphabets/ura.mp3`.

Assets are embedded + pubspec-declared (`pubspec.yaml:50-59`): `assets/audio/lessons/alphabets/`, `words/`, `sentences/`, `assets/sounds/`.

## Workflow
1. Ensure JSON has correct `audioFile` path first (lowercase, no spaces).
2. Generate all missing: `dart tools/appaudio/generate_audio.dart`
3. Specific lesson: `dart tools/appaudio/generate_audio.dart lesson_tracing lesson_spelling` (IDs from `json['id']`).
4. Manual word: `dart tools/appaudio/generate_audio.dart --word "ਸਤਿਨਾਮ" --path "audio/lessons/words/satnam.mp3"`
5. Verify file exists in `assets/audio/lessons/`, run `flutter pub get` if pubspec changed. Never commit missing mp3 with JSON referencing it.
