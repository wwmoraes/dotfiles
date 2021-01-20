#!/bin/bash

set -Eeuo pipefail

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"

# link VSCode user folder
SOURCE="$HOME/.config/Code/User"
TARGET="$HOME/Library/Application Support/Code/User"
if [[ ! -L "${TARGET}" ]]; then
  rm -rf "${TARGET}"
  ln -sf "${SOURCE}" "${TARGET}"
fi
