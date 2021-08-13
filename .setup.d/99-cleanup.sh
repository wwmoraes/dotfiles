#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

: "${SYSTEM:?unknown system}"

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

test "${SYSTEM}" = "darwin" || exit 0

printf "\e[1;33mCleanup\e[0m\n"

printf "removing broken binary links from /usr/local/bin...\n" "/usr/local/bin"
find -L /usr/local/bin/ -type l -exec rm -- {} +
