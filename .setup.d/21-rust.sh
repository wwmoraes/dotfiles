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
PACKAGES_FILE_NAME=rust.txt
PACKAGES_FILE_PATH="${PACKAGES_PATH}/${PACKAGES_FILE_NAME}"

# wanted packages
PACKAGES="${TMP}/packages"
mkfifo "${PACKAGES}"

# reads wanted packages
while IFS= read -r LINE; do
  printf "%s\n" "${LINE}" > "${PACKAGES}" &
done <"${PACKAGES_FILE_PATH}"

printf "\e[1;33mRust packages\e[0m\n"

### Check package tool
printf "Checking \e[91mrustup\e[0m...\n"
# Get manager
if ! _=$(command -V rustup >/dev/null 2>&1); then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

### Install packages
while read -r PACKAGE; do
  printf "Checking \e[96m%s\e[0m...\n" "${PACKAGE%%:*}"
  command -V "${HOME}/.cargo/bin/${PACKAGE##*:}" >/dev/null 2>&1 && continue

  printf "Installing \e[96m%s\e[0m...\n" "${PACKAGE%%:*}"
  cargo -q install "${PACKAGE%%:*}"
done < "${PACKAGES}"
