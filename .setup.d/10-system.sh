#!/bin/bash

set -Eeuo pipefail

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"
: "${WORK:?unknown if on a work machine}"
: "${PERSONAL:?unknown if on a personal machine}"

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

### setup
PACKAGES_FILE_DIR=packages
PACKAGES_FILE_NAME=system.txt

### magic block :D
DIRNAME=$(perl -MCwd -e 'print Cwd::abs_path shift' "$0" | xargs dirname)
# Checks and sets the file path corretly if running directly or sourced
if [ "$0" == "${BASH_SOURCE[0]}" ]; then
  BASE_FILE_PATH=${DIRNAME}
else
  BASE_FILE_PATH=${DIRNAME}/${BASH_SOURCE%%/*}
fi

PACKAGES=()
while IFS= read -r line; do
  PACKAGES+=("$line")
done <"${BASE_FILE_PATH}/${PACKAGES_FILE_DIR}/${PACKAGES_FILE_NAME}"

if [ -f "${BASE_FILE_PATH}/${PACKAGES_FILE_DIR}/${SYSTEM}/${PACKAGES_FILE_NAME}" ]; then
  while IFS= read -r line; do
    PACKAGES+=("${line}")
  done <"${BASE_FILE_PATH}/${PACKAGES_FILE_DIR}/${SYSTEM}/${PACKAGES_FILE_NAME}"
fi

if [ "${PERSONAL}" = "1" ]; then
  if [ -f "${BASE_FILE_PATH}/${PACKAGES_FILE_DIR}/personal/${PACKAGES_FILE_NAME}" ]; then
    while IFS= read -r line; do
      PACKAGES+=("${line}")
    done <"${BASE_FILE_PATH}/${PACKAGES_FILE_DIR}/personal/${PACKAGES_FILE_NAME}"
  fi
fi

if [ "${WORK}" = "1" ]; then
  if [ -f "${BASE_FILE_PATH}/${PACKAGES_FILE_DIR}/work/${PACKAGES_FILE_NAME}" ]; then
    while IFS= read -r line; do
      PACKAGES+=("${line}")
    done <"${BASE_FILE_PATH}/${PACKAGES_FILE_DIR}/work/${PACKAGES_FILE_NAME}"
  fi
fi

HOST=$(hostname -s)
if [ -f "${BASE_FILE_PATH}/${PACKAGES_FILE_DIR}/${HOST}/${PACKAGES_FILE_NAME}" ]; then
  while IFS= read -r line; do
    PACKAGES+=("${line}")
  done <"${BASE_FILE_PATH}/${PACKAGES_FILE_DIR}/${HOST}/${PACKAGES_FILE_NAME}"
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
    printf "Checking \e[96m%s\e[0m...\n" "$(basename "${PACKAGE%%:*}")"
    type -p "${PACKAGE##*:}" &> /dev/null && continue

    printf "Installing \e[96m%s\e[0m...\n" "${PACKAGE%%:*}"
    ${MANAGER} "${PACKAGE%%:*}" 2> /dev/null
  done
else
  printf "ERROR\nUnable to detect the OS package manager\n"
fi

if [ "${SYSTEM}" = "darwin" ]; then
  printf "linking python3 binaries on /usr/local/bin...\n"
  PYTHON_KEG_NAME=$(brew info --json python | jq -r '.[0].name')
  PYTHON_KEG_VERSION=$(brew info --json python | jq -r '.[0].linked_keg')
  PYTHON_FRAMEWORK_VERSION=$(echo ${PYTHON_KEG_VERSION} | cut -d. -f 1,2)
  PYTHON_BIN_PATH=$(brew --prefix)/Cellar/${PYTHON_KEG_NAME}/${PYTHON_KEG_VERSION}/Frameworks/Python.framework/Versions/${PYTHON_FRAMEWORK_VERSION}/bin
  PYTHON_LIBEXEC_PATH=$(brew --prefix)/opt/${PYTHON_KEG_NAME}/libexec/bin

  for SOURCE in "${PYTHON_LIBEXEC_PATH}"/*; do
    TARGET=/usr/local/bin/$(basename "${SOURCE}")
    [ -e "${TARGET}" ] && unlink "${TARGET}"
    ln -sf "${SOURCE}" "${TARGET}"
  done

  for SOURCE in "${PYTHON_BIN_PATH}"/*; do
    TARGET=/usr/local/bin/$(basename "${SOURCE}")
    [ -e "${TARGET}" ] && unlink "${TARGET}"
    ln -sf "${SOURCE}" "${TARGET}"
  done

  brew link --overwrite ${PYTHON_KEG_NAME} || true
fi
