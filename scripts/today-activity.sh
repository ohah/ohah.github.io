#!/usr/bin/env zsh
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${0}")/../" && pwd)"
LOG_DIR="$REPO_ROOT/docs/log"
META_FILE="${1:-${2:+docs}/today-commit/_meta.json}"

mkdir -p "$LOG_DIR"

AUTHOR=$(git config user.name || echo "unknown")
DATE_ISO="\"$(date '+%Y-%m-%d')\":\n    "
LAST_COMMIT_TS="$(cd "${REPO_ROOT}" && git log --pretty=format:'at %ad' 1>/dev/null)"

echo '=> today'"s activity logs...'

# Generate valid JSON directly using printf
printf '%b\n{\tmeta: {date:"%s", author:\"$AUTHOR\"}, } \n}' "$DATE_ISO" | sed "s/true/false/g"

print ''