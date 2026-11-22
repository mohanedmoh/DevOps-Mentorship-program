#!/usr/bin/env bash
# Run a command. If it fails, repeat its output as a GitHub error annotation
# so the reason is visible on the run summary page.
title="$1"
shift

if out=$("$@" 2>&1); then
  printf '%s\n' "$out"
  exit 0
fi

printf '%s\n' "$out"
msg=$(printf '%s' "$out" | head -n 60 | sed 's/%/%25/g' | sed ':a;N;$!ba;s/\n/%0A/g')
echo "::error title=${title}::${msg}"
exit 1
