#!/bin/bash --noprofile --norc

set -Eeuo pipefail

set +m # disable job control in order to allow lastpipe
if [ $(shopt | grep lastpipe | wc -l) = 1 ]; then
  shopt -s lastpipe
fi

# import common functions
. functions.sh

printf "\e[1;34mProfile-like variable exports\e[0m\n"

profileFilesList=(
  $HOME/.profile
  $HOME/.bash_profile
  $HOME/.bashrc
)

# Ignores non-existent profile files
for profilePath in ${profileFilesList[@]}; do
  if [ ! -f "$profilePath" ]; then
    profileFilesList=( ${profileFilesList[@]/$profilePath} )
  fi
done

# Source them to update context
for profilePath in ${profileFilesList[@]}; do
  if [ -f "$profilePath" ]; then
    . $profilePath
  fi
done

# System paths (FIFO)
PREPATHS=(
  $HOME/.config/yarn/global/node_modules/.bin
  $HOME/.local/google-cloud-sdk/bin
  $HOME/.yarn/bin
  $HOME/.krew/bin
  $HOME/.cargo/bin
  $HOME/go/bin
  $HOME/.go/bin
  $HOME/.local/opt/bin
  $HOME/.local/opt/sbin
  $HOME/.local/bin
)

mkdir -p $HOME/.local/bin
mkdir -p $HOME/.local/opt/{bin,sbin}

for PREPATH in ${PREPATHS[@]}; do
    PATH=$PREPATH:$PATH
done

# Dedup paths
echo "dedupping and exporting PATH"
export PATH=$(echo -n $PATH | awk -v RS=: '{gsub(/\/$/,"")} !($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}')
echo "persisting PATH"
echo "PATH=${PATH}" > $HOME/.env_path

# used to pass to the fish script
PATHS=$PATH

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until the parent has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

### variables used across the setup files
SYSTEM=$(getOS)
echo "System: ${SYSTEM}"
ARCH=$(getArch)
echo "Architecture: ${ARCH}"

### setup scripts
for setupd in .setup.d/*.sh; do
  . $setupd
done

### platform-specitic setup scripts
if [ -d .setup.d/$SYSTEM ]; then
  for setupd in .setup.d/$SYSTEM/*.sh; do
    . $setupd
  done
fi

printf "\e[1;34mMiscellaneous\e[0m\n"
# creates the control path folder for SSH
mkdir -p ~/.ssh/control
# Update system font cache
if _=$(type -p fc-cache > /dev/null); then
  printf "Updating font cache...\n"
  fc-cache -f &
fi
### Set fish paths
printf "Setting fish universal variables...\n"
set +e
fish ./variables.fish $PATHS
set -e

if _=$(type -p kquitapp5 &> /dev/null); then
  printf "Updating KDE globals...\n"
  kquitapp5 kglobalaccel && sleep 2s && kglobalaccel5 &
fi

if [ "${SYSTEM}" == "darwin" ]; then
  if [ -d /System/Library/CoreServices/PowerChime.app ]; then
    printf "Disabling MacOS power chime...\n"
    defaults write com.apple.PowerChime ChimeOnAllHardware -bool false
    killall PowerChime &> /dev/null
  fi
fi

printf "Reloading tmux configuration...\n"
tmux source-file $HOME/.tmux.conf

printf "\e[1;34mCleanup\e[0m\n"

printf "Removing old variables...\n"
VARIABLES=()
while IFS= read -r line; do
   PACKAGES+=("$line")
done <.env-remove

printf "\e[1;32mDone!\e[0m\n"
