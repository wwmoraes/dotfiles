#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"
: "${PACKAGES_PATH:?must be set}"
: "${WORK:?unknown if on a work machine}"
: "${PERSONAL:?unknown if on a personal machine}"

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
PERSONAL_PACKAGES_FILE_PATH="${PACKAGES_PATH}/personal/${PACKAGES_FILE_NAME}"
WORK_PACKAGES_FILE_PATH="${PACKAGES_PATH}/work/${PACKAGES_FILE_NAME}"
HOST_PACKAGES_FILE_PATH="${PACKAGES_PATH}/${HOST}/${PACKAGES_FILE_NAME}"

# wanted packages
PACKAGES="${TMP}/packages"
mkfifo "${PACKAGES}"

# reads wanted packages
while IFS= read -r LINE; do
  echo "${LINE}" | grep -Eq "^#" && continue
  printf "%s\n" "${LINE}" > "${PACKAGES}" &
done < "${PACKAGES_FILE_PATH}"

if [ "${PERSONAL}" = "1" ] && [ -f "${PERSONAL_PACKAGES_FILE_PATH}" ]; then
  while IFS= read -r LINE; do
    echo "${LINE}" | grep -Eq "^#" && continue
    printf "%s\n" "${LINE}" > "${PACKAGES}" &
  done < "${PERSONAL_PACKAGES_FILE_PATH}"
fi

if [ "${WORK}" = "1" ] && [ -f "${WORK_PACKAGES_FILE_PATH}" ]; then
  while IFS= read -r LINE; do
    echo "${LINE}" | grep -Eq "^#" && continue
    printf "%s\n" "${LINE}" > "${PACKAGES}" &
  done < "${WORK_PACKAGES_FILE_PATH}"
fi

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

if [ "${MANAGER}" = "" ]; then
  printf "Unable to detect a OS package manager\n"
  exit 1
fi

### Install packages
while read -r PACKAGE; do
  printf "Checking \e[96m%s\e[0m...\n" "$(basename "${PACKAGE%%:*}")"
  command -V "${PACKAGE##*:}" >/dev/null 2>&1 && continue

  printf "Installing \e[96m%s\e[0m...\n" "${PACKAGE%%:*}"
  "${MANAGER}" "${PACKAGE%%:*}" 2> /dev/null
done < "${PACKAGES}"

if [ "${SYSTEM}" = "darwin" ]; then
  printf "linking brew python binaries on \e[94m/usr/local/bin\e[m...\n"
  brew link -q -f --overwrite "$(brew info --json python | jq -r '.[0].name')" || true

  for SOURCE in /usr/local/opt/python/bin/*; do
    TARGET=/usr/local/bin/$(basename "${SOURCE}")
    test -e "${TARGET}" && unlink "${TARGET}"
    ln -sf "${SOURCE}" "${TARGET}"
  done
fi
