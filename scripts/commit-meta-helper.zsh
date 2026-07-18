#!/usr/bin/env zsh
set -euo pipefail

AUTHOR="${1:-ohah}"
DATE=$(date '+%Y-%m-%d')
META_FILE="$PWD/docs/today-commit/_meta.json"

mkdir -p "$(dirname "$META_FILE")"
cat > "${META_FILE}" << EOFJSON
{
    "items": {
        "'"$DATE"'":
            {'author':""$AUTHOR"",
             'title':'Daily Commit Log',
             'active':''}
     }
}
EOFJSON