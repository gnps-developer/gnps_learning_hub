---
name: Release Brochure
description: Use for version tags, Codemagic builds, release notes, brochure PDFs
---

## When to use
`./tools/release/*.sh`, `codemagic.yaml`, `exports/`, `tools/brochure/*.dart`, store metadata.

## Release flow
Per `tools/release/prepare_release.sh:1-52` + `guides/RELEASE_PROCESS.md`:
1. Be on `develop` or script exits 1.
2. `flutter test test/curriculum_integrity_test.dart` must pass.
3. `./tools/release/prepare_release.sh v1.0.X` creates annotated tag, pushes, writes `exports/release_notes_draft.txt` from `git log`.
4. Codemagic builds AAB/IPA for tag. Verify artifacts.
5. `./tools/release/finish_release.sh` after live (merge to `main`, back to `develop`).

## Brochure flow
Per `tools/brochure/`: `brochure_engine.dart`, `generate_full_brochure.dart`, `generate_one_pager.dart`, `style.css`, `data/`, `screenshots/`.
Requires Chrome/Chromium + `assets/data/brochure_content.json` + `tools/brochure/style.css`.
- Full: `dart tools/brochure/generate_full_brochure.dart` -> `exports/brochure/`
- One-pager: `dart tools/brochure/generate_one_pager.dart` -> `exports/brochure/`

Never push tags without user approval. Always report tag, artifacts location, next step.
