#!/bin/bash

set +m # disable job control in order to allow lastpipe
shopt -s lastpipe

### Paths
GOROOT=${GOROOT:-$HOME/.go}
GOPATH=${GOPATH:-$HOME/go}

# System paths
PREPATHS=(
  $HOME/bin
  $GOPATH/bin
  $GOROOT/bin
  $HOME/.cargo/bin
  $HOME/.krew/bin
)

# Only add the paths that are needed
PATHS=($(echo $PATH | tr ':' '\n'))
for PREPATH in ${PREPATHS[@]}; do
  if [ ! $(printf '%s\n' ${PATHS[@]} | grep -P "^$PREPATH$") ]; then
    PATH=$PREPATH:$PATH
  fi
done
export PATH

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until the parent has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

### setup scripts
for setupd in .setup.d/*.sh; do
  . $setupd
done


echo -e "\e[1;34mStowing configurations...\e[0m"
# install config files
make install

echo -e "\e[1;34mFinishing setup...\e[0m"
# Update system font cache
echo -e "Updating font cache..."
fc-cache -f &
### Set fish path
echo -e "Updating fish path variable..."
fish ./variables.fish $PATH

echo -e "\e[1;32mDone!\e[0m"
