#!/usr/bin/env sh

set -eum
trap 'kill 0' INT HUP TERM

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

printf "\e[1;33m[Darwin] Developer setup\e[0m\n"

# run only on darwin
test "${CHEZMOI_OS:-}" = "darwin" || exit

# enable developer mode to bypass authorization requests
if ! _=$(/usr/sbin/DevToolsSecurity -status | grep -Fx "Developer mode is currently enabled." > /dev/null); then
  echo "enabling developer mode on this system"
  sudo /usr/sbin/DevToolsSecurity -enable
fi

# add current user to the developer group
if ! _=$(groups | xargs -n1 | grep -Fx _developer > /dev/null); then
  echo "adding user to group _developer"
  sudo dscl . append /Groups/_developer GroupMembership "$(whoami)"
fi
if ! _=$(groups | xargs -n1 | grep -Fx _webdeveloper > /dev/null); then
  echo "adding user to group _webdeveloper"
  sudo dscl . append /Groups/_webdeveloper GroupMembership "$(whoami)"
fi

echo "configuring taskport privilege"
sudo security authorizationdb write system.privilege.taskport allow
