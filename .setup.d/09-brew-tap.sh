#!/bin/bash

set -Eeuo pipefail

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"
: "${WORK:?unknown if on a work machine}"
: "${PERSONAL:?unknown if on a personal machine}"

if [ "${SYSTEM}" == "darwin" ]; then
  ### setup
  PACKAGES_FILE_DIR=packages/darwin
  PACKAGES_FILE_NAME=tap.txt

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

  if [ "${PERSONAL}" = "1" ]; then
    echo IZ PERSONALZ
    if [ -f "${BASE_FILE_PATH}/${PACKAGES_FILE_DIR}/../personal/${PACKAGES_FILE_NAME}" ]; then

      while IFS= read -r line; do
        PACKAGES+=("${line}")
      done <"${BASE_FILE_PATH}/${PACKAGES_FILE_DIR}/../personal/${PACKAGES_FILE_NAME}"
    fi
  fi

  if [ "${WORK}" = "1" ]; then
    if [ -f "${BASE_FILE_PATH}/${PACKAGES_FILE_DIR}/../work/${PACKAGES_FILE_NAME}" ]; then
      while IFS= read -r line; do
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

  printf "\e[1;33mBrew tap repositories\e[0m\n"

  TAPS=$(brew tap)

  ### Add repository
  for PACKAGE in "${PACKAGES[@]+${PACKAGES[@]}}"; do
    printf "Checking \e[96m%s\e[0m...\n" "${PACKAGE}"

    echo "${TAPS}" | grep -qFx "${PACKAGE}" && continue

    printf "Tapping \e[96m%s\e[0m...\n" "${PACKAGE}"
    brew tap -q "${PACKAGE}" 2> /dev/null || true
  done
fi
