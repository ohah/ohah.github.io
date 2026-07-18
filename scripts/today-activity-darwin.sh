#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"
LOG_DIR="$REPO_ROOT/docs/today-commit"

mkdir -p "$LOG_DIR"
AUTHOR="${GIT_AUTHOR_NAME:-$(git config user.name)}"
COMMITTER_AUTH_DATE=$(date --iso-8601=seconds)
META_FILE="$LOG_DIR/_meta.json"

echo "=> today's commit log..."
LAST_LOGS=$(
  git \
    for-each-ref 'refs/heads/*' '--format=%(refname:short) %(upstream)' |
      sed -E '/^origin\/.+\s+[^ ]$/d; s/^.* (.*?)$/\1/' | # trim origin/
      while read ref branch
        do echo "$branch"
           git log --pretty=format:"%h|%ad" \
             "--date=iso-8601@"${COMMITTER_AUTH_DATE} -n 10000 "HEAD@{yesterday}".."$ref"^{} || true;
      done |
        sort | uniq
)

if [[ "$AUTHOR" =~ ohah ]]; then # author sanity check: only commit if we're committing to our own name (not from cron)
    LAST_COMMIT=$(git log -1 --format=%ct 2>/dev/null && echo "0") || true

    {
      jq . <<'EOF'
        {meta:
          {"date":"$(sed 's/T/ /; s/\.[^.]*$//' <<< "$(TZ=Asia/Kolkata date)")","author":AUTHOR}
         }
 EOF
     > "$META_FILE"
fi