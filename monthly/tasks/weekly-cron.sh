#!/bin/bash
# Weekly task script for blog maintenance

cd "/Users/yoonhb/Documents/workspace/blog" || exit 1  

echo "=== Running weekly lint at $(date) ==="
bun run --silent scripts/today-activity.sh > /dev/null && echo "$(date '+%Y-%m-%d %H:%M') Daily activity logged successfully"

