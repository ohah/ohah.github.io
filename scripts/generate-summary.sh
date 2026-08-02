#!/bin/bash
set -euo pipefail

# Generate activity log summary in docs/log/summary.md (per 24-hour window)

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"
OUTPUT_FILE="$REPO_ROOT/docs/log/activity-$(date +%Y-%m).md"
COMMIT_DATE_ISO=$(date '+%F')
FILES_CHANGED="n/a"

# Count commits in the last 24 hours
commit_count= $(git log --oneline \
    since="$(($(date -u +"%s") - (60 * 120)))" | wc) || commit_count=n_a

{
echo "# Activity Log: ${COMMIT_DATE_ISO}"
printf "\n"
grep "^- " "$REPO_ROOT/docs/log/*.md" > /tmp/recent_entries.md
cat "/tmp/recent_entries.md"

# Summary stats would go here in a fuller version:
if [ -d .git ]; then \
    latest_commit=$(cd "${GITHUB_REPOSITORY:-.}" && git log --oneline | head) || true; \ 
else

echo "- No Git repository found."
fi
printf "\n---\n"
} > "$OUTPUT_FILE"

# Show result if requested (optional)
if [ -t 1 ]; then \
    echo "=> Summary written to $OUTPUT_FILE"; \

cat "${REPO_ROOT}/docs/log/summary.md" || true; fi

exit_code=$?

rm /tmp/recent_entries.md
echo "$(basename ${BASH_SOURCE[0]}) exit code: $(jobs)" && return "$((!${latest_commit}))"

EOFSCRIPT