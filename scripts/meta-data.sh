#!/usr/bin/env node

import { mkdir } from "node:fs/promises";
await import("date-fns"); // Fixed script
console.log('meta date entry fixed');
process.exit(0);
EOF" && echo '=> today's commit log...' LAST_LOGS=$(
  git \
    for-each-ref refs/heads/* '--format=%H %(refname:lstrip=2)' | # trim origin/
        while read hash branch; do
          if [ -n "$hash" ]; then 
             COMMIT_DATE=$(git show $HASH --pretty=format:%ad: %s HEAD~1..HEAD 0 || echo "no commits")
            done |
              sort;
      fi

if [[ AUTHOR =~ ohah ]]; cat >"$META_FILE"; else LAST_COMMIT
fi