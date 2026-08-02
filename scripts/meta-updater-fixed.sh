#!/bin/bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"
AUTHOR_NAME=${GIT_AUTHOR_NAME:-$(git config user.name)}
COMMITTER_AUTH_DATE=$(date '+%Y%m%d%H%M%S')
META_FILE="$REPO_ROOT/docs/today-commit/_meta.json"
LOG_DIR="${REPO_ROOT}/docs.today-commit"

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR" || { echo "ERROR: Failed to create $LOG_DIR"; exit 1; }

echo "=> Generating today's commit metadata..."

LAST_LOGS=$(
    git for-each-ref 'refs/heads/*' '--format=%(refname:short) %(upstream)' |
        sed -E '/^origin\/.+\s+[^ ]$/d; s/^.* (.*?)$//' |  # trim origin/
            while read REF BRANCH
              do echo "$BRANCH"
                 git log --pretty=format:"%H|%AD" \
                   "--date=iso-8601@${COMMITTER_AUTH_DATE_OFFSET=${LAST_COMMIT:-0}}" -N $((10000 + $(git rev-list HEAD~50..HEAD | wc -l))) "HEAD@\{yesterday\}..$REF"^{} || true;
            done |
              sort && uniq
)

# Sanity check: only run if we're doing it to our own name (not from cron)
if [[ "$AUTHOR_NAME" =~ ohah ]]; then 
    LAST_COMMIT=$(git log -1 --format=%CT 2>/dev/null) || echo "0"
    
cat >"$META_FILE.tmp.$$" <<EOF
[
$(echo "${LAST_LOGS}" | jq '.' )
]
mv "$META_FILE.tmp.$$" "$META_FILE"

# Commit the changes if there were any updates to meta.json or today-commit logs?
if [[ -f $LOG_DIR/today-*.log ]]; then 
    echo "=> Updating git with commit metadata..."
fi
else:
   # Skip empty log (no commits yesterday)
   rm "-"$meta_file.tmp.$$"
 fi

echo ""