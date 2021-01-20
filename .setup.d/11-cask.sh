#!/bin/bash

set -Eeuo pipefail

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"

if [ "${SYSTEM}" == "darwin" ]; then
  ### setup
  PACKAGES_FILE_DIR=packages/darwin
  PACKAGES_FILE_NAME=cask.txt

  ### magic block :D
  DIRNAME=$(perl -MCwd -e 'print Cwd::abs_path shift' "$0" | xargs dirname)
  # Checks and sets the file path corretly if running directly or sourced
  if [ "$0" == "${BASH_SOURCE[0]}" ]; then
    BASE_FILE_PATH="${DIRNAME}"
  else
    BASE_FILE_PATH="${DIRNAME}/${BASH_SOURCE%%/*}"
  fi

  PACKAGES=()
  if [ -f "${BASE_FILE_PATH}/${PACKAGES_FILE_DIR}/${PACKAGES_FILE_NAME}" ]; then
    while IFS= read -r line; do
      PACKAGES+=("$line")
    done <"${BASE_FILE_PATH}/${PACKAGES_FILE_DIR}/${PACKAGES_FILE_NAME}"
  fi

  printf "\e[1;33mBrew cask packages\e[0m\n"

  ### Install packages
  for PACKAGE in "${PACKAGES[@]+${PACKAGES[@]}}"; do
    printf "Checking \e[96m%s\e[0m...\n" "${PACKAGE%%:*}"
    type -p "${PACKAGE##*:}" &> /dev/null && continue

    printf "Installing \e[96m%s\e[0m...\n" "${PACKAGE%%:*}"
    brew install -q --cask "${PACKAGE%%:*}" 2> /dev/null
  done
fi
