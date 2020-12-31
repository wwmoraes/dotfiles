#!/bin/bash

set -Eeuo pipefail

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"

### setup
PACKAGES_FILE_NAME=packages/golang.txt

### magic block :D
DIRNAME=$(perl -MCwd -e 'print Cwd::abs_path shift' $0 | xargs dirname)
# Checks and sets the file path corretly if running directly or sourced
if [ "$0" == "$BASH_SOURCE" ]; then
  PACKAGES_FILE_PATH=$DIRNAME/$PACKAGES_FILE_NAME
else
  PACKAGES_FILE_PATH=$DIRNAME/${BASH_SOURCE%%/*}/$PACKAGES_FILE_NAME
fi

PACKAGES=()
while IFS= read -r line; do
   PACKAGES+=("$line")
done <$PACKAGES_FILE_PATH

printf "\e[1;33mGolang packages\e[0m\n"

### Check package tool
echo "Checking golang..."
# Get manager
if ! _=$(type -p go &> /dev/null); then
  GOINSTALL=
  case "${SYSTEM}" in
    "darwin")
      GOINSTALL=--darwin
      ;;
    "linux")
      if [ "${ARCH}" == "amd64" ]; then
        GOINSTALL=--64
      else
        GOINSTALL=--32
      fi
      ;;
  esac
  curl -fsSL https://raw.githubusercontent.com/wwmoraes/golang-tools-install-script/master/goinstall.sh | bash -s - $GOINSTALL
fi

: "${GOPATH:=${HOME}/go}"

echo "Checking for Go packages on $GOPATH..."

### Install packages
  printf "Checking go package \e[96m${PACKAGE}\e[0m...\n"
  test -d $GOPATH/src/$PACKAGE && continue
for PACKAGE in "${PACKAGES[@]+${PACKAGES[@]}}"; do

  printf "Installing go package \e[96m${PACKAGE}\e[0m...\n"
  go get ${PACKAGE}
done
