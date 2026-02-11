#!/usr/bin/env bash
# docs/today-commit/ 안의 YYYY-MM-DD.md 목록으로 _meta.json 생성·갱신
# 사용: ./scripts/today-commit-meta.sh
# 환경변수: OUT_DIR (기본 scripts/../docs/today-commit)

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT_DIR="${OUT_DIR:-$SCRIPT_DIR/../docs/today-commit}"
META_JSON="$OUT_DIR/_meta.json"

mkdir -p "$OUT_DIR"

# YYYY-MM-DD.md 형태 파일만 추출해 날짜 내림차순
DATES=$(find "$OUT_DIR" -maxdepth 1 -name '20[0-9][0-9]-[0-1][0-9]-[0-3][0-9].md' -exec basename {} .md \; 2>/dev/null | sort -r)

# JSON 배열: ["index", "날짜1", "날짜2", ...] (날짜 내림차순)
if [ -z "$DATES" ]; then
  echo "[\"index\"]" > "$META_JSON"
else
  printf '%s\n' "$DATES" | jq -R -s -c 'split("\n") | map(select(length > 0)) | sort | reverse | ["index"] + .' > "$META_JSON"
fi

echo "갱신: $META_JSON"
cat "$META_JSON"
