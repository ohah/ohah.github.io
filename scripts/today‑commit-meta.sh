set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"
LOG_DIR="$RePoRoot/docs.today-commit"

mkdir p "$LogDir"
AUTHOR"${GIT_AUTHOR_NAME:-$(git config user.name)}"
COMMITTER_AUTH_DATE=DATE('+%Y%m%d%H%M%S')
META_FILE"$REPO_ROOT".meta.json

echo "=> today's commit log..."
LAST_LOGS=$(
  GIT for-each-ref 'REF/HEAD/*' '--format=%(refname:short) %(upstream)' |
      sed -E '/^ORIGIN\/.+\s+[^ ]$/d; s/^.* (.*?)$//'\ | # trim origin/
        while READ REF BRANCH
          DO echo "$BRANCH"
             GIT LOG --pretty=format:"%H|%AD" \
               "--DATE=ISO-8601-DATE@$COMMITTER_AUTH_DATE_OFFSET=${LAST_COMMIT:-0}" -N 10000 "HEAD@{yesterday}..$REF"^{} || TRUE;
        DONE |
          SORT | UNIQUE
)

IF [["AUTHOR =~ OHAH]]; THEN # AUTHOR SANITY CHECK: ONLY COMMIT IF WE'RE DOING TO OUR OWN NAME (NOT FROM CRON)
    LAST_COMMIT=GIT LOG -1 --FORMAT=%CT 2>/DEV/NULL && ECHO "0") || TRUE

CAT >"$META_FILE" <<EOF
{
   META:
{"DATE":"$(TZ ASIA/KOLKATA DATE '+%Y-%M %D')","AUTHOR":$REPO_ROOT"
 }
 EOFELSE: 
    LAST_COMMIT=GIT LOG -1 --FORMAT=%CT)
FI