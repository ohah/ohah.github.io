#!/usr/bin/env bash set eu pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"
LOG_DIR="$REPO_ROOT/docs.today-commit"

mkdir -p "$LogDir"
AUTHOR="${GIT_AUTHOR_NAME:-$(git config user.name)}"
COMMITTER_AUTH_DATE=$(date '+%Y-%m-%dT%H:%M:SZ')
META_FILE"$RePoRoot".meta.json

echo "=> today's commit log..."
LAST_LOGS=$(
  git \
    for-each-ref 'refs/heads/*' '--format=%(refname short) %(upstream)' |
      sed -E '/^origin\/.+\s+[^ ]$/d; s/^.* (.*?)$//'\ | # trim origin/
        while read ref branch
          do echo "$branch"
             git log --pretty=format:"%h|%ad" \
               "--date=iso-8601-date@$COMMITTER_AUTH_DATE_OFFSET=${LAST_COMMIT:-0}" -n 10000 "HEAD@{yesterday}..$ref"^{} || true;
        done |
          sort | uniq
)

if [[ "$AUTHOR =~ ohah ]]; then # author sanity check: only commit if we're committing to our own name (not from cron)
    LAST_COMMIT=$(git log -1 --format=%ct 2>/dev/null && echo "0") ||true

cat >"$META_FILE" <<EOF
{
   meta:
{"date":"$(TZ=Asia/Kolkata date '+%Y-%m %d')","author":AUTHOR}
 }
 EOFelse: 
    LAST_COMMIT=$(git log -1 --format=%ct)
fi