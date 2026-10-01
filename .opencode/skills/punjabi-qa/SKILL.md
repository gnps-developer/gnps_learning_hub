---
name: Punjabi QA
description: Use for any new or changed Gurmukhi text - letters, words, sentences, transliterations
---

## When to use
Any `letter`, `targetWord`, `word`, `sentenceParts`, `transliteration` edit. Strict mode: block on linguistic error.

## Rules
1. Gurmukhi Unicode U+0A00-U+0A7F only. Reject Devanagari/Hindi lookalikes, Latin in Punjabi fields, stray ASCII spaces (e.g. `" "` in `letterBank` as seen in weather data is a bug - flag it).
2. Every trace task needs `letter` + lowercase `transliteration` (e.g. `ੳ` / `oorhaa`, `ਕ` / `kakkaa`).
3. Every spelling/matching task needs `targetWord` + `audioFile` + `letterBank` that can actually build the word. Distractors must be same script.
4. Cross-check against existing vocab in `assets/data/lessons/spelling.json`, `matching_words.json`, `matching_images.json` for consistent spelling (e.g. `ਬਿੱਲੀ` not `बिल्ली`).
5. TTS-safe: no emoji in Punjabi fields, no mixed punctuation. `emoji` stays in its own field.
6. If unsure, flag as blocker with `path:line` and do not auto-correct - ask for native review.

## Check command
`python3 -c "import json,sys,re; d=json.load(open(sys.argv[1])); print('parsed')"` for quick parse, plus manual Unicode scan for `[਀-૷]`.
