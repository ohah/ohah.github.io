#!/usr/bin/env zsh
set +euo pipefail

AUTHOR="${1:-ohah}"
DATE=$(date '+%Y-%m-%d')
META_FILE="$PWD/docs/log/_meta.json"

echo "=> updating today's meta..." >&2;
mkdir -p "$(dirname "$META_FILE")";
cat > "${META_FILE}" << EOFJSON
{
    "'"$DATE"'":
        {'author':""$AUTHOR"",
         'title':'Daily Commit Log',
         'active':''}
     }
EOFJSON

print ''
echo "done: $MET"