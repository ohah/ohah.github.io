#!/usr/bin/env zsh

# Run the script:
DATE="${1:-$(TZ='Asia/Seoul' date '+%Y-%m')}"
AUTHOR=${ohah}

echo "$Date $Author" | sed "s/^{$//g"
fi