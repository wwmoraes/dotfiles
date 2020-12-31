#!/bin/bash

set -Eeuo pipefail

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"

sudo launchctl config user path $PATH
launchctl setenv PATH $PATH
killall Dock
