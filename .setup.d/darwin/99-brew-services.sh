#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

: "${SYSTEM:?unknown system}"

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

# exit early if not on darwin
test "${SYSTEM}" = "darwin" || exit

printf "\e[1;33mBrew services\e[0m\n"

# create temp work dir and traps cleanup
TMP=$(mktemp -d)
OLD_PWD="${PWD}"
cd "${TMP}"
trap 'cd "${OLD_PWD}"; rm -rf "${TMP}"' EXIT

# space-separated service names
PACKAGES="skhd"

for PACKAGE in ${PACKAGES}; do
  printf "checking \e[91m%s\e[0m...\n" "${PACKAGE}"
  if ! brew services list | awk '$1 == "'"${PACKAGE}"'" {print $2}' | grep -qFx "started"; then
    printf "starting \e[91m%s\e[0m...\n" "${PACKAGE}"
    brew services restart "${PACKAGE}" || true
  fi
done
