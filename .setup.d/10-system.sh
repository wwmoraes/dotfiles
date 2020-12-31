#!/bin/bash

set -Eeuo pipefail

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"

### setup
PACKAGES_FILE_DIR=packages
PACKAGES_FILE_NAME=system.txt

### magic block :D
DIRNAME=$(perl -MCwd -e 'print Cwd::abs_path shift' $0 | xargs dirname)
# Checks and sets the file path corretly if running directly or sourced
if [ "$0" == "$BASH_SOURCE" ]; then
  BASE_FILE_PATH=$DIRNAME
else
  BASE_FILE_PATH=$DIRNAME/${BASH_SOURCE%%/*}
fi

PACKAGES=()
while IFS= read -r line; do
  PACKAGES+=("$line")
done <$BASE_FILE_PATH/$PACKAGES_FILE_DIR/$PACKAGES_FILE_NAME

if [ -f $BASE_FILE_PATH/$PACKAGES_FILE_DIR/$SYSTEM/$PACKAGES_FILE_NAME ]; then
  while IFS= read -r line; do
    PACKAGES+=("$line")
  done <$BASE_FILE_PATH/$PACKAGES_FILE_DIR/$SYSTEM/$PACKAGES_FILE_NAME
fi

printf "\e[1;33mSystem packages\e[0m\n"

### Check package tool
echo "Checking system manager..."
# Manager options
if [ -x "$(which apt-get 2> /dev/null)" ]; then
  MANAGER="sudo apt-get install --no-install-recommends --no-install-suggests"
elif [ -x "$(which yay 2> /dev/null)" ]; then
  MANAGER="sudo yay -S"
elif [ -x "$(which pacman 2> /dev/null)" ]; then
  MANAGER="sudo pacman -S"
elif [ -x "$(which brew 2> /dev/null)" ]; then
  MANAGER="brew install"
else
  # empty manager
  MANAGER=
fi

if [ ! "${MANAGER}" = "" ]; then
  ### Install packages
  for PACKAGE in "${PACKAGES[@]+${PACKAGES[@]}}"; do
    printf "Checking \e[96m${PACKAGE%%:*}\e[0m...\n"
    type -p ${PACKAGE##*:} &> /dev/null && continue

    printf "Installing \e[96m${PACKAGE%%:*}\e[0m...\n"
    ${MANAGER} ${PACKAGE%%:*} 2> /dev/null
  done
else
  printf "ERROR\nUnable to detect the OS package manager\n"
fi
