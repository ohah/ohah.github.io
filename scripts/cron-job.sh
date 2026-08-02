#!/usr/bin/env zsh
DATE=$(date +%Y-%m-%%d)
mkdir -p docs/tidy-log
touch "docs/log/heart-$DATETIME.log"
echo "$(whoami) $USER_AT" > logs/daily-heartbeat.txt
