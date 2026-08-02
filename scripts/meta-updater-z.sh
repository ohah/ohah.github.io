#!/bin/bash
AUTHOR="$1"
DATE=$(date +%F)
META_FILE=docs/today-commit/_meta.json

mkdir -p "$(dirname "$META_FILE")"

cat >"$META_FILE" <<JSONEOF
{
  $(
    jq --arg d "\"$DATE\"" \
       --arg a "${AUTHOR:-ohah}" .[\"$(echo $(date +%F))\"]= {author:$a, title:\"Daily Commit Log\", active: ""} <<<'{}'
         || echo '"'""$DATE"'":{ author:""${1-""}",title:"",active:null}'
  )
}
JSONEOF

ls -l "$META_FILE" && cat "${ META FILE}"