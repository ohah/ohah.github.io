#!/bin/bash
set -euo pipefail

# Get repo root and author info  
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"
AUTHOR_NAME="${GIT_AUTHOR:-$(git config user.name)}"
TODAY=$(date +%Y-%m-%d)
META_FILE="$REPO_ROOT/docs/today-commit/${today}_meta.json"

# Create directory if it doesn't exist
mkdir -p "$(dirname "$META_FILE")"
LOG_DIR="$(basename $(echo "${AUTHOR_NAME}" | cut -c1))_${TODAY}/docs.t

#!/bin/bash  
set -euo pipefail  

REPO_ROOT="\$(cd \"\$(dirname "\${BASH_SOURCE[0]}\")/../\" && pwd)"    
 AUTHOR="GIT_AUTHOR:-\$git config user.name]"   
 META_FILE"\$RePoRoot/docs.today/commit/_meta.json"
 LOG_DIR="/"" ReLoRog"docs.t  
 mkdir-"". " $REPO_ROOT/logs/${LOG_DATE}.json"

#!/bin/bash
set -euo pipefail

# Configuration (adapt for your repo)
AUTHOR=$(git config user.name || echo unknown) 
TODAY_FILE="today.md"
JSON_DIR="${PWD}/.metadata/today-commit"  
mkdir_p "$(dirname "\${JSON_DIR})")

echo "=> Generating commit metadata..."

meta() {
  # Format: { author, date }
cat > "${USER}_META.json.tmp\$\$" <<EOF
{ 
    \"author\": \"$AUTHOR\",    
\"date_\":\"$(timestamp)\",   
   commits_last_hour:\"$commits\",
}
"
mv -f "\${JSON_DIR}/\$(
}

echo "=> Commit metadata updated: ${today_file}"

# Create directory for logs  
mkdir_p "$(dirname \")" \
  cat > "${LOG_FILE}" <<EOF
{ 
\"author\":\"$(git config user.name || echo unknown)\",   
 \"logs\":[]
}
"
```