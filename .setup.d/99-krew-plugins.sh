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
PACKAGES_FILE_NAME=krew.txt
PACKAGES_FILE_PATH="${PACKAGES_PATH}/${PACKAGES_FILE_NAME}"

# named pipe to receive all packages
PACKAGES="${TMP}/packages"
mkfifo "${PACKAGES}"

# reads packages from the file
while IFS= read -r LINE; do
  printf "%s\n" "${LINE}" > "${PACKAGES}" &
done <"${PACKAGES_FILE_PATH}"

printf "\e[1;33mKrew plugins\e[0m\n"

### Check package tool
printf "Checking \e[91mkrew\e[0m...\n"
if ! _=$(kubectl plugin list 2> /dev/null | grep kubectl-krew > /dev/null); then
  curl -fsSLO https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz
  curl -fsSLO https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.yaml
  tar xzf krew.tar.gz
  KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_$(uname -m | sed -e 's/x86_64/amd64/' -e 's/arm.*$/arm/')"
  $KREW install \
    --manifest=krew.yaml --archive=krew.tar.gz

  echo "Initializing krew..."
  kubectl krew update
fi

while read -r PACKAGE; do
  printf "Checking \e[96m%s\e[0m...\n" "${PACKAGE}"
  kubectl krew list | grep "${PACKAGE}" > /dev/null && continue

  printf "Installing \e[96m%s\e[0m...\n" "${PACKAGE}"
  kubectl krew install "${PACKAGE}"
done < "${PACKAGES}"
