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
DATE="${1:-$YESTERDAY}"
AUTHOR="${2:-ohah}"
COMMIT_LIMIT="${COMMIT_LIMIT:-50}"
PR_LIMIT="${PR_LIMIT:-50}"
OUT_DIR="${OUT_DIR:-$SCRIPT_DIR/../docs/today-commit}"
OUT_FILE="${OUT_FILE:-$OUT_DIR/$DATE.md}"

# 해당 날짜 하루만: 범위 지정. API가 다른 날짜를 섞을 수 있으므로 출력 단계에서 committer.date로 한 번 더 필터.
# (긴 JSON을 변수에 넣으면 이스케이프 등으로 jq 파싱이 깨질 수 있어 임시 파일 사용)
COMMITS_TMP=$(mktemp)
trap 'rm -f "$COMMITS_TMP"' EXIT
gh search commits --author="$AUTHOR" --committer-date="${DATE}..${DATE}" --limit="$COMMIT_LIMIT" --json repository,commit,url 2>/dev/null > "$COMMITS_TMP" || echo "[]" > "$COMMITS_TMP"
PRS=$(gh search prs --author="$AUTHOR" --limit="$PR_LIMIT" --json repository,number,state,title,url,createdAt 2>/dev/null || echo "[]")

# PR 중 해당일 생성된 것만 (createdAt이 DATE로 시작)
PRS_TODAY=$(echo "$PRS" | jq --arg d "$DATE" '[.[] | select(.createdAt | startswith($d))]')

mkdir -p "$OUT_DIR"

{
  echo "---"
  echo "title: \"$DATE\""
  echo "date: $DATE"
  echo "description: $AUTHOR $DATE 커밋·PR 요약"
  echo "---"
  echo ""
  echo "# $DATE"
  echo ""
  echo "## 요약 (AI 작성)"
  echo ""
  echo "<!-- 아래 커밋·PR 목록을 보고 1~3문단으로 오늘 활동 요약을 채운다. 목록은 수정하지 않는다. -->"
  echo ""
  echo "## 커밋"
  echo ""

  if [ ! -s "$COMMITS_TMP" ] || [ "$(cat "$COMMITS_TMP")" = "[]" ]; then
    echo "(없음)"
  else
    # 해당 날짜(committer.date)만 남긴 뒤 repo별로 그룹해 ### repo + 리스트 출력 (메시지 첫 줄만, | 이스케이프)
    jq -r --arg d "$DATE" '
      [.[] | select(.commit.committer.date | startswith($d))] |
      group_by(.repository.fullName) | .[] |
      "### " + (.[0].repository.fullName) + "\n\n" +
      ([.[] | "- [" + (.commit.message | split("\n")[0] | gsub("\\|"; "&#124;") | gsub("]"; "&#93;")) + "](" + .url + ")\n"] | add)
    ' "$COMMITS_TMP"
  fi

  echo ""
  echo "## PR (해당일 생성/머지)"
  echo ""

  PR_COUNT=$(echo "$PRS_TODAY" | jq 'length')
  if [ "$PR_COUNT" = "0" ]; then
    echo "(없음)"
  else
    echo "| repo | # | 상태 | 제목 |"
    echo "|------|---|------|------|"
    echo "$PRS_TODAY" | jq -r '.[] |
      .repository.nameWithOwner as $repo |
      .url as $url |
      (.title | gsub("\\|"; "&#124;")) as $title |
      "| [\($repo)](https://github.com/\($repo)) | [#\(.number)](\($url)) | \(.state) | \($title) |"
    '
  fi
  echo ""
} > "$OUT_FILE"

META_JSON="$OUT_DIR/_meta.json"
if [ -f "$META_JSON" ]; then
  # 이미 있으면 추가 안 함. 없으면 추가 후 index 먼저, 나머지 날짜 내림차순
  if ! jq -e --arg d "$DATE" 'index($d) // false' "$META_JSON" >/dev/null 2>&1; then
    jq -c --arg d "$DATE" '
      (. + [$d] | unique) |
      ["index"] + (map(select(. != "index")) | sort | reverse)
    ' "$META_JSON" > "$META_JSON.tmp" && mv "$META_JSON.tmp" "$META_JSON"
    echo "갱신: $META_JSON (${DATE} 추가)"
  fi
else
  echo "[\"index\", \"$DATE\"]" > "$META_JSON"
  echo "생성: $META_JSON"
fi

echo "생성: $OUT_FILE"
