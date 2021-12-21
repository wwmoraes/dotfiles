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

# exit early if not on darwin
test "${SYSTEM}" = "darwin" || exit

# create temp work dir and traps cleanup
TMP=$(mktemp -d)
OLD_PWD="${PWD}"
cd "${TMP}"
trap 'cd "${OLD_PWD}"; rm -rf "${TMP}"' EXIT

# package file name
PACKAGES_FILE_NAME=tap.txt
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

printf "\e[1;33mBrew tap repositories\e[0m\n"

TAPS="${TMP}/taps"
brew tap > "${TAPS}"

### Add repository
while read -r PACKAGE; do
  case "${PACKAGE%%:*}" in
    -*) REMOVE=1; PACKAGE=${PACKAGE#-*};;
    *) REMOVE=0;;
  esac

  printf "Checking \e[96m%s\e[0m...\n" "${PACKAGE}"
  case "${REMOVE}" in
    1)
      grep -qFx "${PACKAGE}" "${TAPS}" || continue

      printf "Untapping \e[96m%s\e[0m...\n" "${PACKAGE}"
      brew untap -q "${PACKAGE}" 2> /dev/null || true
      ;;
    0)
      grep -qFx "${PACKAGE}" "${TAPS}" && continue

      printf "Tapping \e[96m%s\e[0m...\n" "${PACKAGE}"
      brew tap -q "${PACKAGE}" 2> /dev/null || true
      ;;
  esac
done < "${PACKAGES}"
