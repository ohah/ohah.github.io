#!/usr/bin/env zsh

# Simple daily heartbeat script - just touch a file and commit if needed
DATE=$(date +%Y-%m)
mkdir -p "docs/tidy-heartbeat"
echo "$(whoami) $(pwd)" >> docs/log.txt 2>/dev/null || true;
touch ".heartbeat-marker-$DATETIME"  
