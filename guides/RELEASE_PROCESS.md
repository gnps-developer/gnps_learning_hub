# Release Process Guide - Gurmukhi Sikho

This guide defines the streamlined workflow for publishing new versions to the Google Play and App Store using Git tagging.

## Prerequisites
- You must be on the `develop` branch.
- All changes for the release must be committed and pushed to `develop`.

---

## 🚀 The Release Workflow

### 1. Prepare and Tag the Release
Run the preparation script with your desired version tag (e.g., `v1.0.20`).

```bash
./tools/prepare_release.sh v1.0.20
```

**What this script does:**
1. Verifies you are on `develop`.
2. Runs the **Curriculum Integrity Audit** (automated tests).
3. Generates a draft of release notes in `exports/release_notes_draft.txt` based on your commit history since the last tag.
4. Creates a local Git tag `v1.0.20`.
5. Pushes the tag to your remote repository.

### 2. Finalize the Release
Once you are ready to update the production record in Git:

```bash
./tools/finish_release.sh
```

**What this script does:**
1. Switches to the `main` branch.
2. Performs a fast-forward merge of `develop`.
3. Pushes `main` to the remote repository.
4. Switches back to `develop` for continued work.

---

## 🎙️ Release Notes Best Practices
The script generates a draft in `exports/release_notes_draft.txt`. You should:
1. Review the generated list of commits.
2. Format them for parents/teachers (e.g., "Updated 35 letters with phonetic hints" rather than "Updated tracing.json").
3. Paste these into the **Google Play Console** and **App Store Connect** "What's New" sections.

---

## 🛠️ Troubleshooting
- **Integrity Test Fails**: If the preparation script stops, fix the JSON data errors in your curriculum and try again.
- **Wrong Tag**: If you tag the wrong version, delete it locally and remotely before running the script again:
  ```bash
  git tag -d v1.0.20
  git push --delete origin v1.0.20
  ```
