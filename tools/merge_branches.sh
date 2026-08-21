#!/bin/bash

# GNPS Learning Hub - Branch Merge Utility
# Automates the fast-forward merge from a source branch to a target branch.

SOURCE_BRANCH=$1
TARGET_BRANCH=$2

if [ -z "$SOURCE_BRANCH" ] || [ -z "$TARGET_BRANCH" ]; then
    echo "Usage: ./tools/merge_branches.sh <source_branch> <target_branch>"
    echo "Example: ./tools/merge_branches.sh develop main"
    exit 1
fi

# Ensure we are in the project root
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: This script must be run from the project root."
    exit 1
fi

echo "🔄 Starting merge: $SOURCE_BRANCH -> $TARGET_BRANCH"

# 1. Update target branch
echo "📥 Updating $TARGET_BRANCH..."
git checkout "$TARGET_BRANCH" && git pull origin "$TARGET_BRANCH"
if [ $? -ne 0 ]; then
    echo "❌ Failed to update $TARGET_BRANCH."
    exit 1
fi

# 2. Merge source branch
echo "🔀 Merging $SOURCE_BRANCH into $TARGET_BRANCH (FF-only)..."
git merge --ff-only "$SOURCE_BRANCH"
if [ $? -ne 0 ]; then
    echo "❌ Merge failed. Ensure $SOURCE_BRANCH is fully up-to-date and compatible with $TARGET_BRANCH for a fast-forward merge."
    exit 1
fi

# 3. Push to origin
echo "📤 Pushing $TARGET_BRANCH to origin..."
git push origin "$TARGET_BRANCH"
if [ $? -ne 0 ]; then
    echo "❌ Push failed."
    exit 1
fi

# 4. Return to source branch
echo "🔙 Returning to $SOURCE_BRANCH..."
git checkout "$SOURCE_BRANCH"

echo "✅ Successfully merged $SOURCE_BRANCH into $TARGET_BRANCH and pushed changes."
