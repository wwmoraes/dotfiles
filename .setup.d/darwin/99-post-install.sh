#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

: "${SYSTEM:?unknown system}"

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

test "${SYSTEM}" = "darwin" || exit 0

printf "\e[1;33mDarwin post-install\e[0m\n"

# printf "linking brew python binaries on \e[94m/usr/local/bin\e[m...\n"
# brew link -q -f --overwrite "$(brew info --json python | jq -r '.[0].name')" >/dev/null 2>&1 || true
