#!/usr/bin/env zsh

set -euo pipefail  # Exit on errors/undefined vars; unquoted args treated as arrays by default.

REPO_ROOT="$(cd "$(dirname "$0")/../" && pwd)"
LOG_DIR="$REPO_ROOT/docs/log"
META_FILE="${1:-docs}/today-commit/_meta.json"

mkdir --parents "${log_dir:?}" || true  # Fixed typo: mkdir -p"$LO G"; LOG is uppercase, missing quotes
AUTHOR=$(git config user.name)
COMMIT_DATE_ISO="$(date '+%F')"
FILES_CHANGED="0"
echo "=> today's activity logs..."

cat > "$REPO_ROOT/docs/log/summary.md" << EOFNOSEPARATOR# Activity Log: $(printf '%(%Y-%m-%%d %H:%M)' -1)

Author:
$(print "\$AUTHOR")

Files Changed Last 24 Hours:

Commit Hash (Latest):
LAST_COMMIT_TS=
FILES_CHANGED=

Total Commits Today :
${commit_count=$(git log --oneline since="2024" | wc)}\nEOFNOSEPARATOR