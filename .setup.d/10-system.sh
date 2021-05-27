#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"
: "${PACKAGES_PATH:?must be set}"
: "${WORK:?unknown if on a work machine}"
: "${PERSONAL:?unknown if on a personal machine}"
: "${TAGSRC:=${HOME}/.tagsrc}"

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

# create temp work dir and traps cleanup
TMP=$(mktemp -d)
OLD_PWD="${PWD}"
cd "${TMP}"
trap 'cd "${OLD_PWD}"; rm -rf "${TMP}"' EXIT

# package file name
PACKAGES_FILE_NAME=system.txt
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

printf "\e[1;33mSystem packages\e[0m\n"

### Check package tool
printf "Checking system manager...\n"
# Manager options
if [ -x "$(which apt-get 2> /dev/null)" ]; then
  MANAGER="sudo apt-get install --no-install-recommends --no-install-suggests"
elif [ -x "$(which yay 2> /dev/null)" ]; then
  MANAGER="sudo yay -S"
elif [ -x "$(which pacman 2> /dev/null)" ]; then
  MANAGER="sudo pacman -S"
elif [ -x "$(which brew 2> /dev/null)" ]; then
  MANAGER="brew install"
else
  # empty manager
  MANAGER=
fi

if [ -z "${MANAGER}" ]; then
  printf "Unable to detect a OS package manager\n"
  exit 1
fi

### Install packages
while read -r PACKAGE; do
  printf "Checking \e[96m%s\e[0m...\n" "$(basename "${PACKAGE%%:*}")"
  command -V "${PACKAGE##*:}" >/dev/null 2>&1 && continue

  printf "Installing \e[96m%s\e[0m...\n" "${PACKAGE%%:*}"
  ${MANAGER} "${PACKAGE%%:*}" 2> /dev/null || true
done < "${PACKAGES}"

if [ "${SYSTEM}" = "darwin" ]; then
  printf "linking brew python binaries on \e[94m/usr/local/bin\e[m...\n"
  brew link -q -f --overwrite "$(brew info --json python | jq -r '.[0].name')" >/dev/null 2>&1 || true

  for SOURCE in /usr/local/opt/python/bin/*; do
    TARGET=/usr/local/bin/$(basename "${SOURCE}")
    test -e "${TARGET}" && unlink "${TARGET}"
    ln -sf "${SOURCE}" "${TARGET}"
  done
fi
