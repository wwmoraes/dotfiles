#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

# create temp work dir and traps cleanup
TMP=$(mktemp -d)
OLD_PWD="${PWD}"
cd "${TMP}"
trap 'cd "${OLD_PWD}"; rm -rf "${TMP}"' EXIT

printf "\e[1;34mTest tools\e[0m\n"

printf "Checking \e[96mcc-test-reporter\e[0m...\n"
if ! _=$(command -V cc-test-reporter >/dev/null 2>&1); then
  curl -Lo cc-test-reporter "https://codeclimate.com/downloads/test-reporter/test-reporter-latest-darwin-amd64"
  install -g "$(id -g)" -o "$(id -u)" -m 0750 cc-test-reporter "${HOME}/.local/bin/cc-test-reporter"
fi
