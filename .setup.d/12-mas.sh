#!/bin/bash

set -Eeuo pipefail

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"
: "${WORK:?unknown if on a work machine}"
: "${PERSONAL:?unknown if on a personal machine}"

if [ "${SYSTEM}" == "darwin" ]; then
  ### setup
  PACKAGES_FILE_DIR=packages/darwin
  PACKAGES_FILE_NAME=mas.txt

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
      echo "${line}" | grep -Eq "^#" && continue
      PACKAGES+=("$line")
    done <"${BASE_FILE_PATH}/${PACKAGES_FILE_DIR}/${PACKAGES_FILE_NAME}"
  fi

  if [ "${PERSONAL}" = "1" ]; then
    if [ -f "${BASE_FILE_PATH}/${PACKAGES_FILE_DIR}/../personal/${PACKAGES_FILE_NAME}" ]; then

      while IFS= read -r line; do
        echo "${line}" | grep -Eq "^#" && continue
        PACKAGES+=("${line}")
      done <"${BASE_FILE_PATH}/${PACKAGES_FILE_DIR}/../personal/${PACKAGES_FILE_NAME}"
    fi
  fi

  if [ "${WORK}" = "1" ]; then
    if [ -f "${BASE_FILE_PATH}/${PACKAGES_FILE_DIR}/../work/${PACKAGES_FILE_NAME}" ]; then
      while IFS= read -r line; do
        echo "${line}" | grep -Eq "^#" && continue
        PACKAGES+=("${line}")
      done <"${BASE_FILE_PATH}/${PACKAGES_FILE_DIR}/../work/${PACKAGES_FILE_NAME}"
    fi
  fi

  HOST=$(hostname -s)
  if [ -f "${BASE_FILE_PATH}/${PACKAGES_FILE_DIR}/../${HOST}/${PACKAGES_FILE_NAME}" ]; then
    while IFS= read -r line; do
      PACKAGES+=("${line}")
    done <"${BASE_FILE_PATH}/${PACKAGES_FILE_DIR}/../${HOST}/${PACKAGES_FILE_NAME}"
  fi

  printf "\e[1;33mMac App Store packages\e[0m\n"

  INSTALLED_PACKAGES=$(mas list | grep -vE "^#" | awk '{print $1}')
  ### Install packages
  for PACKAGE in "${PACKAGES[@]+${PACKAGES[@]}}"; do
    printf "Checking \e[96m%s\e[0m...\n" "${PACKAGE##*:}"

    if ! _=$(echo "${INSTALLED_PACKAGES}" | grep -Fx "${PACKAGE%%:*}"); then
      printf "Installing \e[96m%s\e[0m...\n" "${PACKAGE##*:}"
      mas install "${PACKAGE%%:*}"
    fi
  done
fi
