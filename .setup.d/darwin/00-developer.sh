#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

# enable developer mode to bypass authorisation requests
sudo /usr/sbin/DevToolsSecurity -enable

# add current user to the developer group
sudo dscl . append /Groups/_developer GroupMembership $(whoami)
