#!/bin/bash --noprofile --norc

set +m # disable job control in order to allow lastpipe
if [ $(shopt | grep lastpipe | wc -l) = 1 ]; then
  shopt -s lastpipe
fi

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
  $HOME/.go/bin
  $HOME/go/bin
  $HOME/.local/bin
  $HOME/bin
)

mkdir -p $HOME/.local/bin
mkdir -p $HOME/bin

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

### setup scripts
for setupd in .setup.d/*.sh; do
  . $setupd
done

ARCH=$(uname -s | tr '[:upper:]' '[:lower:]')
for setupd in .setup.d/$ARCH/*.sh; do
  . $setupd
done

printf "\e[1;34mMiscellaneous\e[0m\n"
# Update system font cache
type -p fc-cache > /dev/null
if [ $? -eq 0 ]; then
  printf "Updating font cache...\n"
  fc-cache -f &
fi
### Set fish paths
printf "Setting fish universal variables...\n"
fish ./variables.fish $PATHS

type -p kquitapp5 > /dev/null
if [ $? -eq 0 ]; then
  printf "Updating KDE globals...\n"
  kquitapp5 kglobalaccel && sleep 2s && kglobalaccel5 &
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
