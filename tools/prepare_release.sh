#!/bin/bash

# Release Preparation Script
# Usage: ./tools/prepare_release.sh <version_tag>

VERSION=$1

if [ -z "$VERSION" ]; then
    echo "Usage: ./tools/prepare_release.sh <vX.Y.Z>"
    exit 1
fi

# 1. Ensure we are on develop
BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$BRANCH" != "develop" ]; then
    echo "❌ Error: You must be on the 'develop' branch to prepare a release."
    exit 1
fi

# 2. Run Curriculum Integrity Tests
echo "🔍 Running Curriculum Integrity Audit..."
flutter test test/curriculum_integrity_test.dart
if [ $? -ne 0 ]; then
    echo "❌ Error: Integrity tests failed. Fix the data before releasing."
    exit 1
fi
echo "✅ Integrity tests passed."

# 3. Generate a draft of release notes from git logs
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "HEAD")
echo "📝 Generating draft release notes since $LAST_TAG..."
LOGS=$(git log $LAST_TAG..HEAD --oneline --pretty=format:"- %s")

echo "--- DRAFT RELEASE NOTES ---" > exports/release_notes_draft.txt
echo "# Release $VERSION" >> exports/release_notes_draft.txt
echo "Date: $(date +%Y-%m-%d)" >> exports/release_notes_draft.txt
echo "" >> exports/release_notes_draft.txt
echo "## Changes" >> exports/release_notes_draft.txt
echo "$LOGS" >> exports/release_notes_draft.txt
echo "---------------------------"

# 4. Tag and Push
echo "🏷️  Tagging version $VERSION..."
git tag -a "$VERSION" -m "Release $VERSION"
git push origin "$VERSION"

echo ""
echo "🚀 Tag $VERSION pushed!"
echo "📄 Draft release notes saved to: exports/release_notes_draft.txt"
echo ""
echo "Next Steps:"
echo "1. Once published, run: ./tools/finish_release.sh"
