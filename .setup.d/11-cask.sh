#!/bin/bash

if [ "${SYSTEM}" == "darwin" ]; then
  ### setup
  PACKAGES_FILE_DIR=packages/darwin
  PACKAGES_FILE_NAME=cask.txt

  ### magic block :D
  DIRNAME=$(perl -MCwd -e 'print Cwd::abs_path shift' $0 | xargs dirname)
  # Checks and sets the file path corretly if running directly or sourced
  if [ "$0" == "$BASH_SOURCE" ]; then
    BASE_FILE_PATH=$DIRNAME
  else
    BASE_FILE_PATH=$DIRNAME/${BASH_SOURCE%%/*}
  fi

  PACKAGES=()
  if [ -f $BASE_FILE_PATH/$PACKAGES_FILE_DIR/$PACKAGES_FILE_NAME ]; then
    while IFS= read -r line; do
      PACKAGES+=("$line")
    done <$BASE_FILE_PATH/$PACKAGES_FILE_DIR/$PACKAGES_FILE_NAME
  fi

  printf "\e[1;33mBrew cask packages\e[0m\n"

  ### Install packages
  for PACKAGE in ${PACKAGES[@]}; do
    printf "Checking \e[96m${PACKAGE%%:*}\e[0m...\n"
    type -p ${PACKAGE##*:} &> /dev/null && continue

    printf "Installing \e[96m${PACKAGE%%:*}\e[0m...\n"
    brew install -q --cask ${PACKAGE%%:*} 2> /dev/null
  done
fi