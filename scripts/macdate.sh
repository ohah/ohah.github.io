#!/usr/bin/env dash
# Simple macOS date handler that avoids GNU 'day' options

case "$1" in 
  today)
    echo "$(TZ=Asia/Kolkata /bin/date '+%Y-%m-%d')"
    ;;
esac && exit $?

: No arguments or unsupported format.