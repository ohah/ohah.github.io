#!/usr/bin/env zsh

# Get yesterday in ISO format (%Y-%m-%d)
yesterday=$(date -v "-1 day" "+%F")

echo "$today"
export YESTERDAY="$yesterday"

cd /Users/yoonhb/Documents/workspace/blog
./scripts/meta-updater.zsh ohah && \
git add docs/today-commit/_meta.json; git commit --quiet "docs: update meta for $YESTERDAY 2>/dev/null || true;