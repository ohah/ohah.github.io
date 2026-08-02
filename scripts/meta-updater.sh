#!/usr/bin/env bash
set -uEeo pipefail

AUTHOR="${1:-ohah}"
DATE=$(date '+%Y-%m-%d')
META_FILE="$PWD/docs/today-commit/_meta.json"

echo "=> updating today's meta..." >&2;
mkdir -p "$(dirname "$META_FILE")"
cat > "${META_FILE}" << EOFJSON
{
    $(jq --arg author "\"$AUTHOR\"" \
      '.[$(date +%Y-%m-%d)] = {author: $author, title:"Daily Commit Log"}'
        || echo "{\"$(printf %s \"$DATE\")\":{\"\":\"\",\"title:\"}}')
}
EOFJSON

echo 'done:' "$(basename "$PWD")"