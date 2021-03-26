#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"
: "${PACKAGES_PATH:?must be set}"

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

# create temp work dir and traps cleanup
TMP=$(mktemp -d)
OLD_PWD="${PWD}"
cd "${TMP}"
trap 'cd "${OLD_PWD}"; rm -rf "${TMP}"' EXIT

# package file name
PACKAGES_FILE_NAME=helm.txt
PACKAGES_FILE_PATH="${PACKAGES_PATH}/${PACKAGES_FILE_NAME}"

# wanted packages
PACKAGES="${TMP}/packages"
mkfifo "${PACKAGES}"

# reads wanted packages
while IFS= read -r LINE; do
  printf "%s\n" "${LINE}" > "${PACKAGES}" &
done <"${PACKAGES_FILE_PATH}"

printf "\e[1;34mhelm plugins\e[0m\n"

INSTALLED="${TMP}/installed"
helm plugin list 2>/dev/null | awk 'NR != 1 {print $1}' > "${INSTALLED}"

while read -r PACKAGE; do
  printf "Checking \e[96m%s\e[0m...\n" "${PACKAGE%%|*}"
  grep -q "${PACKAGE%%|*}" "${INSTALLED}" && continue

  printf "Installing \e[96m%s\e[0m...\n" "${PACKAGE%%|*}"
  helm plugin install "${PACKAGE##*|}"
done < "${PACKAGES}"
