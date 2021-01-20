#!/bin/bash

set -Eeuo pipefail

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"

### setup
PACKAGES_FILE_NAME=packages/node.txt

### magic block :D
DIRNAME=$(perl -MCwd -e 'print Cwd::abs_path shift' "$0" | xargs dirname)
# Checks and sets the file path corretly if running directly or sourced
if [ "$0" == "${BASH_SOURCE[0]}" ]; then
  PACKAGES_FILE_PATH="${DIRNAME}/${PACKAGES_FILE_NAME}"
else
  PACKAGES_FILE_PATH="${DIRNAME}/${BASH_SOURCE%%/*}/${PACKAGES_FILE_NAME}"
fi

PACKAGES=()
while IFS= read -r line; do
   PACKAGES+=("$line")
done <"${PACKAGES_FILE_PATH}"

printf "\e[1;33mNode packages\e[0m\n"

### Check package tool
echo "Checking npm..."
# Get manager
if ! _=$(type -p npm &> /dev/null); then
  echo "npm not found - plase install node"
  exit 1
fi

### Check package tool
echo "Checking yarn..."
# Get manager
if ! _=$(type -p yarn &> /dev/null); then
  npm i -g yarn
fi

echo "Checking for node packages..."

### Install packages
for PACKAGE in "${PACKAGES[@]+${PACKAGES[@]}}"; do
  printf "Checking \e[96m%s\e[0m...\n" "${PACKAGE%%:*}"
  test -d "$(yarn global dir)/node_modules/${PACKAGE##*:}" && continue

  printf "Installing \e[96m%s\e[0m...\n" "${PACKAGE%%:*}"
  yarn global add "${PACKAGE%%:*}" > /dev/null
done
