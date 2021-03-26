#!/bin/bash

set -Eeuo pipefail

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

# link VSCode user folder
SOURCE="$HOME/.config/Code/User"
TARGET="$HOME/Library/Application Support/Code/User"
if [[ ! -L "${TARGET}" ]]; then
  rm -rf "${TARGET}"
  ln -sf "${SOURCE}" "${TARGET}"
fi

# harklink fonts
mkdir -p "${HOME}/Library/Fonts"
for font in "${HOME}"/.local/share/fonts/*; do
  ln -f "${font}" "${HOME}/Library/Fonts/$(basename "${font}")"
done
atsutil databases -removeUser
killall fontd
