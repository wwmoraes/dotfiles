#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

: "${SYSTEM:?unknown system}"
: "${PACKAGES_PATH:?must be set}"
: "${TAGSRC:=${HOME}/.tagsrc}"

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

# package file name
PACKAGES_FILE_NAME=brew-services.txt
PACKAGES_FILE_PATH="${PACKAGES_PATH}/${PACKAGES_FILE_NAME}"
SYSTEM_PACKAGES_FILE_PATH="${PACKAGES_PATH}/${SYSTEM}/${PACKAGES_FILE_NAME}"
HOST_PACKAGES_FILE_PATH="${PACKAGES_PATH}/${HOST}/${PACKAGES_FILE_NAME}"

# wanted packages
PACKAGES="${TMP}/packages"
mkfifo "${PACKAGES}"

# reads global packages
if [ -f "${PACKAGES_FILE_PATH}" ]; then
  while IFS= read -r LINE; do
    echo "${LINE}" | grep -Eq "^#" && continue
    printf "%s\n" "${LINE}" > "${PACKAGES}" &
  done < "${PACKAGES_FILE_PATH}"
fi

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

while read -r PACKAGE; do
  printf "checking \e[91m%s\e[0m...\n" "${PACKAGE}"
  if ! brew services list | awk '$1 == "'"${PACKAGE}"'" {print $2}' | grep -qFx "started"; then
    printf "starting \e[91m%s\e[0m...\n" "${PACKAGE}"
    brew services restart "${PACKAGE}" || true
  fi
done < "${PACKAGES}"
