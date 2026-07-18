#!/usr/bin/env zsh
set +euo pipefail

REPO_ROOT="$(cd "$(dirname "${0}")/../" && pwd)"
DATE=$(date '+%Y-%m-%d')
AUTHOR="ohah"
LOG_DIR="$REPO_ROOT/docs/log"

mkdir -p "$LOG_DIR/$(git rev-parse --short HEAD 2>/dev/null || echo unknown)"

echo "=> today's activity log..." > "${LOG_DIR}/${DATE}.md"