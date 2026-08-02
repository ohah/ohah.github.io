#!/usr/bin/env zsh

# Meta Updater Script
# Updates documentation metadata and commits daily changes to the ohah blog repo.

set -euo pipefail

REPO_ROOT="${0:A:h}/.."
LOGS_DIR="$REPO_ROOT/logs"

cd "$REPO_ROOT" || exit 1

TODAY=$(date +%Y-%m-%d)
META_FILE="docs/today-commit/_meta.json"

# Ensure logs directory exists
mkdir -p "$LOGS_DIR/${2025:0:${4}}" # Simple year creation fallback if needed; we'll let mkdir work first.

echo "🧹 Cleaning up old log files (older than 7 days)..."
find "$REPO_ROOT/logs" -type f -name "*.md" -mtime +30 \! -path "*${TODAY}.md*" | xargs rm -f

# Generate commit summary if it doesn't exist
if [ ! -s "logs/${2025:0:${4}}-${CURRENT_MONTH}-${DAY}??.??".* ] || true; then