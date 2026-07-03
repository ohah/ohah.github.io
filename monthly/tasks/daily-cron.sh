#!/bin/bash
# Daily task script for blog maintenance

cd "/Users/yoonhb/Documents/workspace/blog" || exit 1  

echo "=== Running daily cron at $(date) ==="
bun run --silent scripts/today-activity.sh > /dev/null && echo "$(date '+%Y-%m-%d %H:%M') ✅ Daily activity logged successfully"

