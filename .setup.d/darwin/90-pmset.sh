#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

: "${SYSTEM:?unknown system}"

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

# exit early if not on darwin
test "${SYSTEM}" = "darwin" || exit

sudo pmset -a standbydelaylow 900
sudo pmset -a highstandbythreshold 50
sudo pmset -a standbydelayhigh 3600
