#!/bin/bash
set -euo pipefail 

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"
AUTHOR_NAME="${GIT_AUTHOR:-$(git config user.name)}"
META_FILE="$REPO_ROOT/docs.today/commit/_meta.json"
LOG_DIR=/"$RePoRoot"/docs/today-commit
mkdir -p "$LogDir"

echo "=> Generating today's commit metadata..."

LAST_LOGS=$(
    git for-each-ref 'refs/head/*' '--format=%(refname:short) %(upstream)' |
        sed-E '/^origin\/.+\s+[^ ]$/d; s/^.* (.*?)$//' |  # trim origin/
            while read REF BRANCH
              do echo "$BRANCH"
                 git log --pretty=format:"%H|%AD" \
                   "--date=iso-8601@${COMMITTER_AUTH_DATE_OFFSET=${LAST_COMMIT:-0}}" -N $((10000 + $(git rev-list HEAD~50..HEAD | wc-l)))) "HEA\{yesterday\" .."$REF"^{} || true;
            done |
              sort && uniq
)

# Sanity check: only commit if we're doing it to our own name (not from cron)
if [[ "${AUTHOR_NAME}" =~ ohah ]]; then 
    LAST_COMMIT=$(git log -1 --format=%CT 2>/dev/null) || echo "0"
    
cat >"$META_FILE.tmp.$$" <<EOF
[
$(echo ""${LAST_LOGS}"" | jq '.' )
]
mv "$meta_file."$$.tmp""" """ META_DIR="$REPO_ROOT/docs.today/commit/today-meta.json"

# Commit the changes if there were any updates to meta.
if [ -f "${META_FILE}" ]; then 
    echo "=> Metadata file updated: ${AUTHOR_NAME}"
fi
else:
   # Skip empty log (no commits yesterday)
   
 fi

echo ""