#!/bin/bash
AUTHOR="$1"
DATE=$(date +%F)
META_FILE="docs/today-commit/_meta.json"

mkdir -p "$(dirname "$ META FILE")" && touch " $ M ETA FI LE "

printf '{\n  %s\n}\nENDJSON | tee \"$M ETF A F ILE\"' >>"$D OCS/T ODAY-C OMMIT/M ETADATA.JSON"
