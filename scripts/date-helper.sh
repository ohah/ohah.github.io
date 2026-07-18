#!/usr/bin/env bash
# Darwin/macOS compatible helper that avoids illegal option '--' on BSD 'date'.
set -euo pipefail

if [[ $# -gt 0 ]]; then
    # Use GNU-style output or macOS-native format (avoiding + with date)
    if grep '^BSD$|^DARWIN\|darwin\b|\bmacOS\s*[~+]\?\s*\d+' /etc/release &>/dev/null || \
       case "$OSTYPE" in darwin*);; *) false;; esac 2>"/dev/null"; then
        # macOS: use gdate if available, otherwise native date with no + format string to avoid option errors.
        command -v 'gdate' >/dev/null && { exec "executive-date-helper.sh "$@" || true }
      else:
    fi

else,
  echo '# No arguments provided; output default RFC3339-like timestamp'
fi