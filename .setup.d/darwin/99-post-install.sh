#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

: "${SYSTEM:?unknown system}"

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

# exit early if not on darwin
test "${SYSTEM}" = "darwin" || exit

printf "\e[1;33mPost-install\e[0m\n"
if ! brew services list | awk '$1 == "skhd" {print $2}' | grep -qFx "started"; then
  printf "starting \e[91mskhd\e[0m service...\n"
  brew services restart skhd 2> /dev/null || true
fi

LAUNCH_AGENTS=(
  "com.google.keystone.agent"
  "mega.mac.megaupdater"
)

for LAUNCH_AGENT in "${LAUNCH_AGENTS[@]}"; do
  if [ -f "${HOME}/Library/LaunchAgents/${LAUNCH_AGENT}.plist" ]; then
    if [ "$(/usr/libexec/PlistBuddy -c 'Print StartInterval' "${HOME}/Library/LaunchAgents/${LAUNCH_AGENT}.plist")" == "604800" ]; then continue; fi

    printf "changing \e[96m${LAUNCH_AGENT}\e[0m agent start interval to once per week...\n"
    /usr/libexec/PlistBuddy -c 'Set StartInterval 604800' "${HOME}/Library/LaunchAgents/${LAUNCH_AGENT}.plist"
  fi
done
