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
PACKAGES_FILE_NAME=pip.txt
PACKAGES_FILE_PATH="${PACKAGES_PATH}/${PACKAGES_FILE_NAME}"

# wanted packages
PACKAGES="${TMP}/packages"
mkfifo "${PACKAGES}"

# reads wanted packages
while IFS= read -r LINE; do
  printf "%s\n" "${LINE}" > "${PACKAGES}" &
done <"${PACKAGES_FILE_PATH}"

printf "\e[1;33mPython3 packages\e[0m\n"
### Check package tool
printf "Checking \e[96mpip\e[0m manager...\n"
if ! _=$(python3 -m pip -V > /dev/null 2>&1); then
  # curl -fsSLO https://bootstrap.pypa.io/get-pip.py
  # python3 get-pip.py
  python3 -m ensurepip
fi

python3 -m pip install --user --upgrade pip

printf "Listing installed packages...\n"
INSTALLED="${TMP}/installed"
python3 -m pip list --user --format freeze | cut -d= -f1 > "${INSTALLED}"

### Install packages
while read -r PACKAGE; do
  printf "Checking \e[96m%s\e[0m...\n" "${PACKAGE%%|*}"
  grep -q "${PACKAGE%%|*}" "${INSTALLED}" && continue

  printf "Installing \e[96m%s\e[0m...\n" "${PACKAGE%%|*}"
  python3 -m pip install --user -qqq "${PACKAGE##*|}"
done < "${PACKAGES}"
