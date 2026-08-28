#!/bin/bash

# GNPS Learning Hub - Finish Release Script
# Merges develop into main and pushes.

echo "🚢 Finalizing release: Merging develop into main..."

git checkout main
git pull origin main
git merge --ff-only develop
git push origin main
git checkout develop

echo "✅ Release finalized. 'main' is now up to date with the latest release."
