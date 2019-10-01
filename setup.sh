#!/bin/bash

set +m # disable job control in order to allow lastpipe
shopt -s lastpipe

echo -e "\e[1;34mProfile-like variable exports\e[0m"

profileFilesList=(
  $HOME/.profile
  $HOME/.bash_profile
)

# Removes non-existent profile files
for profilePath in ${profileFilesList[@]}; do
  if [ ! -f "$profilePath" ]; then
    profileFilesList=( "${profileFilesList[@]/$profilePath}" )
  fi
done

### Set environment variables
IFS=$'\n'
for entry in $(cat .env | grep -v '^#' | grep -v '^$'); do
  IFS='=' read key value <<< $entry
  value=$(echo $value)

  for profilePath in $profileFilesList; do
    grep "export ${key}" $profilePath > /dev/null
    if [ $? -eq 0 ]; then
      echo -e "Updating \e[96m${key}\e[0m on \e[95m$profilePath\e[0m"
      sed -Ei "s|(export ${key})=.*|export ${key}=${value}|" $profilePath
    else
      echo -e "Adding \e[96m${key}\e[0m to \e[95m$profilePath\e[0m"
      echo "export ${key}=${value}" >> $profilePath
    fi
  done
done
unset IFS

# Source them to update context
for profilePath in ${profileFilesList[@]}; do
  if [ ! -f "$profilePath" ]; then
    . profilePath
  fi
done

# System paths (FIFO)
PREPATHS=(
  /home/linuxbrew/.linuxbrew/sbin
  /home/linuxbrew/.linuxbrew/bin
  $HOME/.config/yarn/global/node_modules/.bin
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
export PATH=$(echo -n $PATH | awk -v RS=: '{gsub(/\/$/,"")} !($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}')
PATHS=$PATH

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until the parent has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

### setup scripts
for setupd in .setup.d/*.sh; do
  . $setupd
done

echo -e "\e[1;34mMiscellaneous\e[0m"
# Update system font cache
echo -e "Updating font cache..."
fc-cache -f &
### Set fish paths
echo -e "Setting fish universal variables..."
fish ./variables.fish $PATHS

type -p kquitapp5 > /dev/null
if [ $? -eq 0 ]; then
  echo -e "Updating KDE globals..."
  kquitapp5 kglobalaccel && sleep 2s && kglobalaccel5 &
fi

echo -e "\e[1;32mDone!\e[0m"
