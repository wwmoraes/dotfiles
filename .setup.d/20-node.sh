#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"
: "${PACKAGES_PATH:?must be set}"
: "${TAGSRC:=${HOME}/.tagsrc}"

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
SYSTEM_PACKAGES_FILE_PATH="${PACKAGES_PATH}/${SYSTEM}/${PACKAGES_FILE_NAME}"
HOST_PACKAGES_FILE_PATH="${PACKAGES_PATH}/${HOST}/${PACKAGES_FILE_NAME}"

# wanted packages
PACKAGES="${TMP}/packages"
mkfifo "${PACKAGES}"

# reads global packages
while IFS= read -r LINE; do
  echo "${LINE}" | grep -Eq "^#" && continue
  printf "%s\n" "${LINE}" > "${PACKAGES}" &
done < "${PACKAGES_FILE_PATH}"

# reads system-specific packages
if [ -f "${SYSTEM_PACKAGES_FILE_PATH}" ]; then
  while IFS= read -r LINE; do
    echo "${LINE}" | grep -Eq "^#" && continue
    printf "%s\n" "${LINE}" > "${PACKAGES}" &
  done < "${SYSTEM_PACKAGES_FILE_PATH}"
fi

# reads tag-specific packages
while IFS= read -r TAG; do
  TAG_PACKAGES_FILE_PATH="${PACKAGES_PATH}/${TAG}/${PACKAGES_FILE_NAME}"

  test -f "${TAG_PACKAGES_FILE_PATH}" || continue

  while IFS= read -r LINE; do
    echo "${LINE}" | grep -Eq "^#" && continue
    printf "%s\n" "${LINE}" > "${PACKAGES}" &
  done < "${TAG_PACKAGES_FILE_PATH}"
done < "${TAGSRC}"

# reads host-specific packages
if [ -f "${HOST_PACKAGES_FILE_PATH}" ]; then
  while IFS= read -r LINE; do
    echo "${LINE}" | grep -Eq "^#" && continue
    printf "%s\n" "${LINE}" > "${PACKAGES}" &
  done < "${HOST_PACKAGES_FILE_PATH}"
fi

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
  case "${PACKAGE%%:*}" in
    -*) REMOVE=1; PACKAGE=${PACKAGE#-*};;
    *) REMOVE=0;;
  esac


  case "${REMOVE}" in
    1)
      printf "[\e[92muninstall\e[m] Checking \e[96m%s\e[0m...\n" "${PACKAGE%%:*}"
      grep -q "${PACKAGE%%|*}" "${INSTALLED}" || continue
      printf "[\e[92muninstall\e[m] Installing \e[96m%s\e[0m...\n" "${PACKAGE%%:*}"
      yarn global remove "${PACKAGE%%:*}" > /dev/null
    ;;
    0)
      printf "[\e[92m install \e[m] Checking \e[96m%s\e[0m...\n" "${PACKAGE%%:*}"
      grep -q "${PACKAGE%%|*}" "${INSTALLED}" && continue
      printf "[\e[92m install \e[m] Installing \e[96m%s\e[0m...\n" "${PACKAGE%%:*}"
      yarn global add "${PACKAGE%%:*}" > /dev/null
    ;;
  esac
done < "${PACKAGES}"
