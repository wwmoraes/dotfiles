#!/usr/bin/env sh

set -eum
trap 'kill 0' INT HUP TERM

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

# import common functions
# shellcheck source=../.setup.d/functions.sh
. "${DOTFILES_PATH}/.setup.d/functions.sh"

h1 "[Darwin] Power management settings"

# run only on darwin
test "${CHEZMOI_OS:-}" = "darwin" || exit 0

sudo pmset -a standbydelaylow 900
sudo pmset -a highstandbythreshold 50
sudo pmset -a standbydelayhigh 3600
