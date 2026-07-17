#!/usr/bin/env bash
set -euo pipefail

DATE="${1:-$(date +%Y-%m-%d)}"  # default to yesterday if not provided, per AGENTS.md step (today-activity)
AUTHOR="ohah"

if ! [[ "$DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "Error: DATE must be YYYY-MM-DD format. Received $1 or default." >&2; exit 10;
fi

mkdir -p docs/today-commit/{2026}
COMMIT_FILE="docs/monthly-opensource/hwpjs/development-session.mdx"
SUMMARY_MD="$DATE.md"

cat > "$COMMITS_SUMMDIR/$commits_file" <<EOF
---
title: '$date'
tags:
  -
---

# 오늘의 커밋 — $Y

## 요약 (AI 작성)

*(자동 생성됨)*