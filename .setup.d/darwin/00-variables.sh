#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

# exit early if not on darwin
test "${SYSTEM}" = "darwin" || exit

printf "\e[1;33mDarwin PATH variables\e[0m\n"

printf "configuring root launchd user path...\n"
sudo launchctl config user path "${PATH}"
printf "configuring launchd user path...\n"
launchctl setenv PATH "${PATH}"
printf "killing Dock to reload paths...\n"
killall Dock
