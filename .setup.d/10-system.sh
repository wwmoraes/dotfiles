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
MANAGER=
MANAGER_PRE_EXEC=
MANAGER_POST_EXEC=
if [ -x "$(which apt-get 2> /dev/null)" ]; then
  MANAGER="sudo apt-get"
  MANAGER_INSTALL_ARGS="install --no-install-recommends --no-install-suggests"
  MANAGER_REMOVE_ARGS="remove"
elif [ -x "$(which yay 2> /dev/null)" ]; then
  MANAGER="sudo yay"
  MANAGER_INSTALL_ARGS="-S"
  MANAGER_REMOVE_ARGS="-Rs"
elif [ -x "$(which pacman 2> /dev/null)" ]; then
  MANAGER="sudo pacman"
  MANAGER_INSTALL_ARGS="-S"
  MANAGER_REMOVE_ARGS="-Rs"
elif [ -x "$(which brew 2> /dev/null)" ]; then
  MANAGER="brew"
  MANAGER_INSTALL_ARGS="install"
  MANAGER_REMOVE_ARGS="remove"
  MANAGER_PRE_EXEC="brew update --preinstall"
  MANAGER_POST_EXEC="brew cleanup"
fi

if [ -z "${MANAGER}" ]; then
  printf "Unable to detect a OS package manager\n"
  exit 1
fi

### Install packages
if [ -n "${MANAGER_PRE_EXEC}" ]; then
  printf "Running pre-install hook \e[95m%s\e[0m...\n" "${MANAGER_PRE_EXEC}"
  ${MANAGER_PRE_EXEC}
fi

while read -r PACKAGE; do
  case "${PACKAGE%%:*}" in
    -*) REMOVE=1; PACKAGE=${PACKAGE#-*};;
    *) REMOVE=0;;
  esac

  printf "Checking \e[96m%s\e[0m...\n" "$(basename "${PACKAGE%%:*}")"
  case "${REMOVE}" in
    1)
      command -V "${PACKAGE##*:}" >/dev/null 2>&1 || continue
      printf "Uninstalling \e[96m%s\e[0m...\n" "${PACKAGE%%:*}"
      ${MANAGER} ${MANAGER_REMOVE_ARGS} "${PACKAGE%%:*}" || true
    ;;
    0)
      command -V "${PACKAGE##*:}" >/dev/null 2>&1 && continue
      printf "Installing \e[96m%s\e[0m...\n" "${PACKAGE%%:*}"
      ${MANAGER} ${MANAGER_INSTALL_ARGS} "${PACKAGE%%:*}" || true
    ;;
  esac

done < "${PACKAGES}"

if [ -n "${MANAGER_POST_EXEC}" ]; then
  printf "Running post-install hook \e[95m%s\e[0m...\n" "${MANAGER_POST_EXEC}"
  ${MANAGER_POST_EXEC}
fi
