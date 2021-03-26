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
PACKAGES_FILE_NAME=rustup.txt
PACKAGES_FILE_PATH="${PACKAGES_PATH}/${PACKAGES_FILE_NAME}"

# wanted packages
PACKAGES="${TMP}/packages"
mkfifo "${PACKAGES}"

# reads wanted packages
while IFS= read -r LINE; do
  printf "%s\n" "${LINE}" > "${PACKAGES}" &
done <"${PACKAGES_FILE_PATH}"

printf "\e[1;33mRustup components\e[0m\n"

### Check package tool
printf "Checking \e[91mrustup\e[0m...\n"
# Get manager
if ! _=$(command -V rustup >/dev/null 2>&1); then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

TARGET=$(rustup target list 2>&1 | awk '/(installed)/ {print $1}' | head -n1)
INSTALLED="${TMP}/installed"
rustup component list 2>&1 | awk '/(installed)/ {print $1}' | sed "s/-${TARGET}//" > "${INSTALLED}"

### Install packages
while read -r PACKAGE; do
  printf "Checking \e[96m%s\e[0m...\n" "${PACKAGE%%:*}"
  grep -q "${PACKAGE}" "${INSTALLED}" && continue

  printf "Installing \e[96m%s\e[0m...\n" "${PACKAGE}"
  rustup component add "${PACKAGE}" --target "${TARGET}"
done < "${PACKAGES}"
