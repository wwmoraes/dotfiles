#!/bin/bash

### setup
PACKAGES_FILE_NAME=packages/golang.txt

### magic block :D
DIRNAME=$(realpath $0 | xargs dirname)
# Checks and sets the file path corretly if running directly or sourced
if [ "$0" == "$BASH_SOURCE" ]; then
  PACKAGES_FILE_PATH=$DIRNAME/$PACKAGES_FILE_NAME
else
  PACKAGES_FILE_PATH=$DIRNAME/${BASH_SOURCE%%/*}/$PACKAGES_FILE_NAME
fi
readarray PACKAGES < $PACKAGES_FILE_PATH

echo -e "\e[1;33mGolang packages\e[0m"

### Check package tool
echo "Checking golang..."
# Get manager
type -p go &> /dev/null
if [ $? -ne 0 ]; then
  GOINSTALL=
  case "$(uname -s)" in
    "Darwin")
      GOINSTALL=--darwin
      ;;
    "Linux")
      if [ "$(uname -m)" == "x86_64" ]; then
        GOINSTALL=--64
      else
        GOINSTALL=--32
      fi
      ;;
  esac
  curl -fsSL https://raw.githubusercontent.com/wwmoraes/golang-tools-install-script/master/goinstall.sh | bash -s - $GOINSTALL
fi

### Install packages
for PACKAGE in ${PACKAGES[@]}; do
  echo -e "Checking go package \e[96m${PACKAGE}\e[0m..."
  test -d $GOPATH/src/$PACKAGE && continue

  echo -e "Installing go package \e[96m${PACKAGE}\e[0m..."
  go get ${PACKAGE}
done
