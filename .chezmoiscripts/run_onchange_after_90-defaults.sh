#!/usr/bin/env sh
# chezmoi:template:left-delimiter="# {{" right-delimiter=}}
# {{- range $_, $filename := (glob (joinPath .chezmoi.homeDir ".config" "macos-defaults" "*.yaml")) }}
# # {{ base $filename }} hash: # {{ include $filename | sha256sum }}
# {{- end }}

set -eum
trap 'kill 0' INT HUP TERM

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

printf "\e[1;33m[Darwin] User Defaults\e[0m\n"

# run only on darwin
test "${CHEZMOI_OS:-}" = "darwin" || exit

# skip changing defaults
test "${DEFAULTS:-0}" = "0" && exit

## sane defaults on https://github.com/kevinSuttle/macOS-Defaults
macos-defaults apply ~/.config/macos-defaults

test "${DEFAULTS:-0}" = "1" && exit

## Ask for the administrator password upfront
sudo -v

## Keep-alive: update existing `sudo` time stamp until the parent has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

################################################################################
printf "\e[1;34mUI/UX\e[0m\n"

echo "setting: disable the sound effects on boot"
# cspell:disable-next-line
sudo nvram SystemAudioVolume=" "

## Commented out, as this is known to cause problems in various Adobe apps :(
## See https://github.com/mathiasbynens/dotfiles/issues/237
# echo "setting: Fix for the ancient UTF-8 bug in QuickLook (https://mths.be/bbo)"
# echo "0x08000100:0" > ~/.CFUserTextEncoding

# echo "setting: Disable Notification Center and remove the menu bar icon"
# cspell:disable-next-line
# launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

# echo "setting: Stop iTunes from responding to the keyboard media keys"
# launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

################################################################################
printf "\e[1;34mEnergy saving\e[0m\n"

echo "setting: Restart automatically if the computer freezes"
# cspell:disable-next-line
sudo systemsetup -setrestartfreeze on

echo "setting: Never go into computer sleep mode"
# cspell:disable-next-line
sudo systemsetup -setcomputersleep Off > /dev/null

## Remove the sleep image file to save disk space
# cspell:disable-next-line
# test -f /private/var/vm/sleepimage && sudo rm /private/var/vm/sleepimage

## Create a zero-byte file instead…
# cspell:disable-next-line
# sudo touch /private/var/vm/sleepimage

## …and make sure it can't be rewritten
# cspell:disable-next-line
# sudo chflags uchg /private/var/vm/sleepimage


################################################################################
printf "\e[1;34mFinder\e[0m\n"

echo "setting: always show the user Library folder"
# cspell:disable-next-line
chflags nohidden "${HOME}/Library"

echo "setting: Show the /Volumes folder"
# cspell:disable-next-line
sudo chflags nohidden /Volumes


################################################################################
printf "\e[1;34mSpotlight\e[0m\n"

echo "action: Load new settings before rebuilding the index"
# cspell:disable-next-line
killall mds > /dev/null || true

echo "action: enable indexing for the main volume"
# cspell:disable-next-line
sudo mdutil -i on / > /dev/null

# echo "action: Rebuild the index from scratch"
# cspell:disable-next-line
# sudo mdutil -E / > /dev/null

################################################################################
printf "\e[1;34mTime Machine\e[0m\n"

# echo "setting: Disable local Time Machine backups"
# cspell:disable-next-line
# hash tmutil > /dev/null 2>&1 && sudo tmutil disablelocal

echo "setting: thin local Time Machine snapshots"
# cspell:disable-next-line
hash tmutil > /dev/null 2>&1 && sudo tmutil thinlocalsnapshots / 1000000000 1 > /dev/null 2>&1

################################################################################
printf "\e[1;34mSecurity\e[0m\n"

echo "setting: allow apps from anywhere"
# cspell:disable-next-line
sudo spctl --master-enable

################################################################################
printf "\e[1;34mMiscellaneous\e[0m\n"

# cspell:disable
## disable system integrity protection on fs, nvram and debug
# csrutil enable --without fs --without nvram --without debug
# cspell:enable

# cspell:disable
## purges 'Open With' duplicates + reloads environment variables
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
# cspell:enable
