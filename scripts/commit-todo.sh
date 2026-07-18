#!/usr/bin/env zsh
cd "$(dirname "$0")/../"

mkdir -p docs/log/docs.today/

AUTHOR=$(git config user.name 2>/dev/null || echo unknown)
DATE="$(date +%Y-%m-%d)"

# Print valid JSON to stdout, then tee it into a file:
echo "{\"meta\":{\"day\":\"$DATE\",\"name\":\"${AUTHOR:-unknown}\"}}" | sed 's/true/false/g' > "docs/today-commit/$1_meta.json"
