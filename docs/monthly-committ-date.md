#!/usr/bin/env bash
# 커밋·PR을 gh로 조회해 docs/today-commit/{date}.md 생성
# 0시에 돌릴 때 "방금 지난 날" 기준으로 쓰려고 인자 없으면 어제 날짜 사용.
# 사용: ./scripts/today-activity.sh [date] [author]
#       인자 없음 → 어제 날짜, author=ohah (0시 크론용)
#       date만   → 해당 날짜, author=ohah
# 예:   ./scripts/today-activity.sh
#       ./scripts/today-activity.sh 2026-02-11

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# 메인 브랜치 최신화: fetch 후 hard reset
if [ -d "$REPO_ROOT/.git" ]; then
  (cd "$REPO_ROOT" && git fetch origin && git checkout main && git reset --hard origin/main)
fi

# 어제 날짜 (macOS: -v-1d, Linux: -d "yesterday")
YESTERDAY=$(date -v-1d +%Y-%m-%d 2>/dev/null || date -d "yesterday" +%Y-%m-%d)
