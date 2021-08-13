#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

# harklink fonts
mkdir -p "${HOME}/Library/Fonts"
for font in "${HOME}"/.local/share/fonts/*; do
  ln -f "${font}" "${HOME}/Library/Fonts/$(basename "${font}")"
done
atsutil databases -removeUser
killall fontd
