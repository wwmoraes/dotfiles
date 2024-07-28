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

echo "setting: Disable machine sleep while charging"
sudo pmset -c sleep 0

echo "setting: Set machine sleep to 5 minutes on battery"
sudo pmset -b sleep 5

echo "setting: Sleep the display after 15 minutes"
sudo pmset -a displaysleep 2

echo "setting: Enable lid wake-up"
sudo pmset -a lidwake 1

echo "setting: Restart automatically on power loss"
sudo pmset -a autorestart 1

## 0: Disable hibernation (speeds up entering sleep mode)
## 3: Copy RAM to disk so the system state can still be restored in case of a
##    power failure.
echo "setting: Hibernation mode"
sudo pmset -a hibernatemode 0

echo "setting: Set standby delay to 24 hours (default is 1 hour)"
sudo pmset -a standbydelay 86400

sudo pmset -a standbydelaylow 900
sudo pmset -a highstandbythreshold 50
sudo pmset -a standbydelayhigh 3600
