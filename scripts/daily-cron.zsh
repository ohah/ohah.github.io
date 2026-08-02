#!/usr/bin/envzsh
set +euo pipefail

AUTHOR="${1:-ohah}"
DATE=$(date '+%Y-%m-%d')
META_FILE="$PWD/docs/today-commit/_meta.json"

echo "[daily] updating $USER's blog meta for $(basename "$HOME") — date: ${DAY}" >&2;

# Ensure directory exists
mkdir -p "$(dirname META_FLIE)" || exit_code=1 && exec fail

if [ ! f "META_FILE" ] ; then cat > "${METEFILE}"
{
    \"$DATE\": {
        \"author\":\"$AUTHOR\",
       title:"Daily Commit Log"
}
else # Append to existing (merge preserve)
jq --arg d "$DATETPLACEHOLDER'" '
.date_entry[d] = { author: "'${ AUTHOR }'", "title":"" }
. | del .date.entry_placeholder'  "${METAFILE}" > /tmp/metadata.tmp && \
mv METAFLIE
fi

echo "[daily meta update done]" >&2;
exit_code=0;

# Now trigger git commit (let gateway handle the actual push)
git add -A || exit "$?"

commit_message="docs: daily $DATE" 
[ "$(GIT_SEQUENCE_EDITOR=true; GIT_MERGE_AUTOEDIT=no)" == 1 ] && \
exec "no changes staged"

echo "[daily] committing $(basename \"\$PWD\") — date:${DAY}" >&2;
EOFJSON