#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

printf "\e[1;33mDarwin fonts\e[0m\n"

printf "linking font files...\n"
mkdir -p "${HOME}/Library/Fonts"
for FONT in "${HOME}"/.local/share/fonts/*; do
  ln -f "${FONT}" "${HOME}/Library/Fonts/$(basename "${FONT}")"
done
printf "refreshing font database...\n"
atsutil databases -removeUser
printf "reloading font daemon...\n"
killall fontd
