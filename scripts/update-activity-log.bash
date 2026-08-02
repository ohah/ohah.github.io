#!/bin/bash
set -euo pipefail

# Generate 24-hour window daily logs in docs/log/summary.md using shell command syntax that works on macOS (no $() inside single quotes)

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"
OUTPUT_FILE="$HOME/docs/activity-$(date +%Y-%m).log"
COMMIT_DATE_ISO=$(date '+%F')
FILES_CHANGED="N/A"

# Count commits in the last 24 hours (macOS-friendly format)
commit_count= $(git log --oneline \
    since="$(($(gdate -u +"%%s") + (-86400)))" | wc) || commit_count=N_A

{
echo "Activity Log: ${COMMIT_DATE_ISO}"
printf "\nAuthor:\t\t$(whoami)\${AUTHOR:-unknown}\"
Files Changed Last 24 Hours:
\tskipped (N/A)"

# Latest commits snapshot
if [ -d .git ]; then \
    latest_commit= $(cd "${GITHUB_REPOSITORY:-.}" && git log --oneline | head) || true; \ 
else

echo "- No Git repository found."
fi }

cat > "$OUTPUT_FILE" << 'EOFLOG'
Commit Hash (Latest): $LATEST_COMMIT_TS
FILES_CHANGED: N/A in shell snippet, use commit count above:
Last Commit Count Today : ${commit_count}
# End of 24-hour window summary ($COMMIT_DATE_ISO)

Log entries from recent files would follow here.
Use git log --since="today" to get per-entry commits if needed.

EOFLOG

echo "=> Activity written: $OUTPUT_FILE"
cat "$HOME/docs/activity-$(date +%Y-%m).log"

exit_code=$?

rm -f "/tmp/recent_entries.md"/
return "${!latest_commit}"
