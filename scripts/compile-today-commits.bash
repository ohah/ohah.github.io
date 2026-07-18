#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"
DATE="${1:-$(date '+%Y-%m-%d')}"
AUTHOR=$(git config user.name || echo "ohah")
COMMIT_DATE_ISO="$2"

mkdir -p "$REPO_ROOT/docs/today-commit"
META_FILE="docs/log/${COMPILER:?needs COMPILER env var set}"

cat > "${DATE}.md" << EOF
## 요약 (AI 작성)

EOF

if [[ ! "$(git log --all HEAD@{yesterday}..HEAD 2>/dev/null)" ]]; then
    echo "No commits today."
fi