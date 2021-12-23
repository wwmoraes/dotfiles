#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"
: "${PACKAGES_PATH:?must be set}"
: "${GOPATH:=${HOME}/go}"

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

# create temp work dir and traps cleanup
TMP=$(mktemp -d)
OLD_PWD="${PWD}"
cd "${TMP}"
trap 'cd "${OLD_PWD}"; rm -rf "${TMP}"' EXIT

# package file name
PACKAGES_FILE_NAME=golang.txt
PACKAGES_FILE_PATH="${PACKAGES_PATH}/${PACKAGES_FILE_NAME}"

# wanted packages
PACKAGES="${TMP}/packages"
mkfifo "${PACKAGES}"

# reads wanted packages
while IFS= read -r LINE; do
  printf "%s\n" "${LINE}" > "${PACKAGES}" &
done <"${PACKAGES_FILE_PATH}"

printf "\e[1;33mGolang packages\e[0m\n"

### Check package tool
printf "Checking \e[91mgo\e[0m...\n"
# Get manager
if ! _=$(command -V go >/dev/null 2>&1); then
  GOINSTALL=
  case "${SYSTEM}" in
    "darwin")
      GOINSTALL=--darwin
      ;;
    "linux")
      if [ "${ARCH}" = "amd64" ]; then
        GOINSTALL=--64
      else
        GOINSTALL=--32
      fi
      ;;
  esac
  curl -fsSL https://raw.githubusercontent.com/wwmoraes/golang-tools-install-script/master/goinstall.sh | bash -s - "${GOINSTALL}"
fi

printf "Checking go packages on \e[94m%s\e[0m...\n" "${GOPATH}"

### Install packages
FIFO=$(mktemp -u -t dotfiles.golang)
mkfifo -m 0600 "${FIFO}"
trap 'rm -f "${FIFO}"' EXIT INT TERM
while read -r PACKAGE; do
  # IFS=: read PKG BIN <<< "${PACKAGE}"
  # IFS=@ read MODULE VERSION <<< "${PKG}"
  echo "${PACKAGE}" > "${FIFO}" &
  IFS=: read PKG BIN < "${FIFO}"
  echo "${PKG}" > "${FIFO}" &
  IFS=@ read MODULE VERSION < "${FIFO}"
  : "${VERSION:=latest}"
  : "${BIN:=$(basename "${MODULE}")}"

  printf "Checking \e[96m%s\e[0m...\n" "${BIN}"
  test -f "${GOPATH}/bin/${BIN}" && continue

  printf "Installing \e[96m%s\e[0m...\n" "${BIN}"
  go install "${MODULE}@${VERSION}" || printf "\e[91mFAILED\e[m to install \e[96m%s\e[0m\n" "${BIN}" >&2
done < "${PACKAGES}"
