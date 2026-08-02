#!/usr/bin/env zsh
# Generate a daily commit log entry

TODAY=$(date +%Y-%m-%d)
LOG_DIR="logs"
COMMIT_FILE="${LOG_DIR}/${TODAY}.md"

if [[ ! -f "${COMMIT_FILE}" ]]; then
    echo "# Commit Summary — ${TODAY}

- [ ] \n\n---\nGenerated: $(date '+%H:%M')" > "$COMMIT_FILE"
fi

echo "Created/updated log file for today."