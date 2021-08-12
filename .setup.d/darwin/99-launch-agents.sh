#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

: "${SYSTEM:?unknown system}"
: "${DOTFILES_PATH:=${HOME}/.files}"
: "${START_INTERVAL:=604800}"

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

printf "\e[1;33mLaunch agents configuration\e[0m\n"

# exit early if not on darwin
test "${SYSTEM}" = "darwin" || exit

# import common functions
# shellcheck source=../../functions.sh
. "${DOTFILES_PATH}/functions.sh"

enterTmp
getPackages "launchagents.txt"
: "${PACKAGES:?run getPackages to generate}"

while read -r PACKAGE; do
  printf "checking \e[96m%s\e[0m...\n" "${PACKAGE}"

  PLIST_PATH="${HOME}/Library/LaunchAgents/${PACKAGE}.plist"
  test -f "${PLIST_PATH}" || continue

  test "$(/usr/libexec/PlistBuddy -c 'Print StartInterval' "${PLIST_PATH}")" -eq "${START_INTERVAL}" && continue

  printf "configuring \e[96m%s\e[0m...\n" "${PACKAGE}"
  /usr/libexec/PlistBuddy -c "Set StartInterval ${START_INTERVAL}" "${PLIST_PATH}"
done < "${PACKAGES}"
