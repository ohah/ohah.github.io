#!/usr/bin/env zsh
cd "$(dirname "$0")/../"
pwd > /dev/null

mkdir -p docs/log/docs.today-commit/

AUTHOR=$(git config user.name 2>/dev/null || echo unknown)
DATE="$(date +%Y-%m-%d)"

cat << 'EOF'
{"meta":{"day":"'"$DATE"'","name":"'"$AUTHOR"'"}}
' | tee "docs/today-commit/$1_meta.json"