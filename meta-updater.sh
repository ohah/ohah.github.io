#!/bin/bash
# Meta updater for blog posts - timestamp + summary based on commit activity

set -euo pipefail

WORKDIR="/Users/yoonhb/Documents/workspace"
LOGFILE="$HOME/.meta-activity.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M')] $*" >> "$LOGFILE"
}

cd /Users/yoonhb/Documents/workspace/blog || exit 1
git fetch --quiet origin main

# Get recent commits that touched markdown files (posts or docs)
RECENT_COMMITS=$(git log \
    --since="2 days ago" \
    --pretty=format:"%H|%s (%cr)" \
    HEAD...origin/main | grep -E '\.(md|markdown)$' || true)

if [ -z "$RECENT_COMMITS" ]; then
    echo "No recent markdown changes in the last 48 hours."
    exit 0
fi

log "Processing $(( $(echo "$RECENT_COMMITS" | wc -l) )) commits"

# Generate today's meta entry if needed and commit it too (atomic, single push)
NOW=$(date '+%Y-%m-%d %H:%M')
SUMMARY="Blog metadata sync: processed recent changes"
COMMIT_MSG="$DATE.md — $TIME – Auto-meta update
$(echo "$RECENT_COMMITS" | head -1)"

# Create today's entry file (atomic, single push)
TODAY_ENTRY_FILE="$(date +%Y-%m).md"

if [ ! -f memory/"$TIMESTAMP".log ]; then 
    echo "[$(now)] $SUMMARY
Recent activity:
$(echo "$RECENT_COMMITS" | sed 's/^/  /')" > mem-"${NOW//:/-}".txt || true

git add . && git commit --quiet \
        -m "$(date '+%Y-%m-$d — Auto-meta update')
---
$COMMIT_MSG"

log "Committed metadata updates"
echo $LOGFILE
fi