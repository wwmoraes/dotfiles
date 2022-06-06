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

# exit early if not on darwin
test "${SYSTEM}" = "darwin" || exit

# create temp work dir and traps cleanup
TMP=$(mktemp -d)
OLD_PWD="${PWD}"
cd "${TMP}"
trap 'cd "${OLD_PWD}"; rm -rf "${TMP}"' EXIT

# package file name
PACKAGES_FILE_NAME=cask.txt
PACKAGES_FILE_PATH="${PACKAGES_PATH}/${PACKAGES_FILE_NAME}"
HOST_PACKAGES_FILE_PATH="${PACKAGES_PATH}/${HOST}/${PACKAGES_FILE_NAME}"

# wanted packages
PACKAGES="${TMP}/packages"
mkfifo "${PACKAGES}"

# reads wanted packages
while IFS= read -r LINE; do
  echo "${LINE}" | grep -Eq "^#" && continue
  printf "%s\n" "${LINE}" > "${PACKAGES}" &
done < "${PACKAGES_FILE_PATH}"

while read -r TAG; do
  TAG_PACKAGES_FILE_PATH="${PACKAGES_PATH}/${TAG}/${PACKAGES_FILE_NAME}"

  test -f "${TAG_PACKAGES_FILE_PATH}" || continue

  while read -r LINE; do
    echo "${LINE}" | grep -Eq "^#" && continue
    printf "%s\n" "${LINE}" > "${PACKAGES}" &
  done < "${TAG_PACKAGES_FILE_PATH}"
done < "${TAGSRC}"

if [ -f "${HOST_PACKAGES_FILE_PATH}" ]; then
  while IFS= read -r LINE; do
    echo "${LINE}" | grep -Eq "^#" && continue
    printf "%s\n" "${LINE}" > "${PACKAGES}" &
  done < "${HOST_PACKAGES_FILE_PATH}"
fi

printf "Listing installed packages...\n"
INSTALLED="${TMP}/installed"
brew list -1 | grep . > "${INSTALLED}"

printf "\e[1;33mBrew cask packages\e[0m\n"

### Install packages
while read -r PACKAGE; do
  case "${PACKAGE%%|*}" in
  -*) REMOVE=1; PACKAGE=${PACKAGE#-*};;
  *) REMOVE=0;;
  esac

  case "${REMOVE}" in
    1)
      printf "[\e[91muninstall\e[m] Checking \e[96m%s\e[0m\n" "${PACKAGE%%|*}"
      grep -q "${PACKAGE%%|*}" "${INSTALLED}" || continue
      printf "[\e[91muninstall\e[m] Uninstalling \e[95m%s\e[0m\n" "${PACKAGE%%|*}"
      brew remove -q "${PACKAGE%%|*}" ||:
      ;;
    0)
      printf "[\e[92m install \e[m] Checking \e[96m%s\e[0m\n" "${PACKAGE%%|*}"
      grep -q "${PACKAGE%%|*}" "${INSTALLED}" && continue
      printf "[\e[92m install \e[m] Installing \e[96m%s\e[0m\n" "${PACKAGE%%|*}"
      brew install -qf --cask "${PACKAGE%%|*}" ||:
      ;;
  esac

done < "${PACKAGES}"

printf "Removing extra attributes of \e[96m%s\e[0m contents...\n" "${HOME}/Applications"
sudo xattr -r -c "${HOME}/Applications" 2>&1 | grep -v "No such file"

printf "Changing ownership of \e[96m%s\e[0m contents...\n" "${HOME}/Applications"
sudo chown -R "$(id -un):$(id -gn)" "${HOME}/Applications"
