#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

# run only on darwin
test "${CHEZMOI_OS:-}" = "darwin" || exit

printf "\e[1;33mDarwin power management settings\e[0m\n"

sudo pmset -a standbydelaylow 900
sudo pmset -a highstandbythreshold 50
sudo pmset -a standbydelayhigh 3600
