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
PACKAGES_FILE_NAME=node.txt
PACKAGES_FILE_PATH="${PACKAGES_PATH}/${PACKAGES_FILE_NAME}"

# wanted packages
PACKAGES="${TMP}/packages"
mkfifo "${PACKAGES}"

# reads wanted packages
while IFS= read -r LINE; do
  printf "%s\n" "${LINE}" > "${PACKAGES}" &
done <"${PACKAGES_FILE_PATH}"

printf "\e[1;33mNode\e[0m\n"

printf "Checking \e[91mnode\e[0m...\n"
if ! _=$(command -V node >/dev/null 2>&1); then
  echo "node not found"
  exit 1
fi

printf "Checking \e[91mnpm\e[0m...\n"
if ! _=$(command -V npm >/dev/null 2>&1); then
  echo "npm not found"
  exit 1
fi

printf "Checking \e[91myarn\e[0m...\n"
if ! _=$(command -V yarn >/dev/null 2>&1); then
  npm i -g yarn
fi

printf "\e[1;33mYarn global packages\e[0m\n"

INSTALLED="${TMP}/installed"
jq -r '.dependencies | keys[]' "$(yarn global dir)/package.json" > "${INSTALLED}"

### Install packages
while read -r PACKAGE; do
  printf "Checking \e[96m%s\e[0m...\n" "${PACKAGE%%:*}"
  grep -q "${PACKAGE%%|*}" "${INSTALLED}" && continue

  printf "Installing \e[96m%s\e[0m...\n" "${PACKAGE%%:*}"
  yarn global add "${PACKAGE%%:*}" > /dev/null
done < "${PACKAGES}"
