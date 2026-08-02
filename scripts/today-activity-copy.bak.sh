#!/usr/bin/env bash
# Backup of today-commit-meta.sh

cd /Users/yoonhb/Documents/workspace/blog || exit 1 TODAY_DATE=${TODAY:-$(date +%Y-%m)}
DATE_ONLY=$(echo "today $CURRENT_YEAR-$MONTH_DAY"| awk '{print substr($0,4)}')