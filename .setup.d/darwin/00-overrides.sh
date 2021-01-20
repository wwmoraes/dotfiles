#!/bin/bash

set -Eeuo pipefail

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"

printf "\e[1;33mDarwin directory links\e[0m\n"

printf "linking python3 to python on /usr/local/bin...\n"
ln -sf /usr/local/bin/python3 /usr/local/bin/python

# link VSCode user folder
SOURCE="$HOME/.config/Code/User"
TARGET="$HOME/Library/Application Support/Code/User"
if [[ ! -L "${TARGET}" ]]; then
  rm -rf "${TARGET}"
  ln -sf "${SOURCE}" "${TARGET}"
fi
