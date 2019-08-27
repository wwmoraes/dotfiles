#!/bin/bash

# Tools wanted
SYSTEM_PACKAGES=(fish git vim stow tmux pip)
SYSTEM_PLUS_PACKAGES=(fzf)
PYTHON_PACKAGES=(powerline-status)

# empty manager
MANAGER=

# Manager options
declare -A osInfo;
osInfo[/etc/debian_version]="apt-get install --no-install-recommends --no-install-suggests"
osInfo[/etc/arch-release]=pacman
osInfo[/etc/redhat-release]=yum
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypp

echo -n "Checking package manager..."
# Get manager
for f in ${!osInfo[@]}
do
  if [[ -f $f ]]; then
    MANAGER=${osInfo[$f]}
    break
  fi
done

if [ "${MANAGER}" = "" ]; then
  echo -e "ERROR\nUnable to detect the OS package manager"
  exit 1
else
  echo -e " OK"
fi

# additional package manager detector
PLUS_MANAGER=
case "$(uname -s)" in
  "Darwin")
    PLUS_MANAGER="brew install"
    type -p brew &> /dev/null
    if [ $? -ne 0 ]; then
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
    ;;
  "Linux")
    PLUS_MANAGER="/home/linuxbrew/.linuxbrew/bin/brew install"
    type -p brew &> /dev/null
    if [ $? -ne 0 ]; then
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    fi
    eval $(SHELL=bash /home/linuxbrew/.linuxbrew/bin/brew shellenv)
    ;;
  ""|*)
    echo "Unable to detect the OS type to select an additional package manager"
    exit 1
esac

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until the parent has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

for PACKAGE in ${SYSTEM_PACKAGES[@]}; do
  type -p $PACKAGE &> /dev/null && continue
  
  echo "Installing system package $PACKAGE..."
  sudo ${MANAGER} $PACKAGE
done

for PACKAGE in ${PYTHON_PACKAGES[@]}; do
  pip show $PACKAGE &>/dev/null && continue

  echo "Installing python package $PACKAGE..."
  sudo pip install $PACKAGE
done

for PACKAGE in ${SYSTEM_PLUS_PACKAGES[@]}; do
  type -p $PACKAGE &> /dev/null && continue

  echo "Installing brew package $PACKAGE..."
  ${PLUS_MANAGER} $PACKAGE
done