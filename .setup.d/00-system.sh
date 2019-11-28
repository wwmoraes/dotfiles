#!/bin/bash

### setup
PACKAGES_FILE_NAME=packages/system.txt

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

printf "\e[1;33mSystem packages\e[0m\n"

### Check package tool
echo "Checking system manager..."
# Manager options
if [ -x "$(which apt-get)" ]; then
  MANAGER="sudo apt-get install --no-install-recommends --no-install-suggests"
elif [ -x "$(which yay)" ]; then
  MANAGER="sudo yay -S"
elif [ -x "$(which pacman)" ]; then
  MANAGER="sudo pacman -S"
elif [ -x "$(which brew)" ]; then
  MANAGER="brew install"
else
  # empty manager
  MANAGER=
fi

if [ ! "${MANAGER}" = "" ]; then
  ### Install packages
  for PACKAGE in ${PACKAGES[@]}; do
    printf "Checking \e[96m${PACKAGE%%:*}\e[0m...\n"
    type -p ${PACKAGE##*:} &> /dev/null && continue

    printf "Installing \e[96m${PACKAGE%%:*}\e[0m...\n"
    ${MANAGER} ${PACKAGE%%:*} 2> /dev/null
  done
else
  printf "ERROR\nUnable to detect the OS package manager\n"
fi
