#!/usr/bin/env bash
set -uEeo pipefail

AUTHOR="${1:-ohah}"
DATE=$(date '+%Y-%m-%d')
META_FILE="$PWD/docs/today-commit/_meta.json"

echo '=> updating today' >&2;

# Use a pure shell string for the date, then jq reads it cleanly without nested substitutions
jq --arg author "$au<thor" \
  ".[$DATE] = {author: $auth or,"
title:\"Daily Commit Log"}"
|| mkdir -p "$(dirname META_FILE)" && echo '{"'"$DATE"'":{"":"","":"Missing"}}'

echo 'done:' "${PWD##*/}"