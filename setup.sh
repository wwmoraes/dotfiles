#!/bin/bash

# Tools wanted
SYSTEM_PACKAGES=(
  fish
  git
  vim
  stow
  tmux
  pip
)

HOMEBREW_PACKAGES=(
  fzf
  # lazygit
)

GO_PACKAGES=(
  github.com/jesseduffield/lazygit
)

PYTHON_PACKAGES=(
  powerline-status
)

# empty manager
MANAGER=

# Manager options
declare -A osInfo;
osInfo[/etc/debian_version]="apt-get install --no-install-recommends --no-install-suggests"
osInfo[/etc/arch-release]=pacman
osInfo[/etc/redhat-release]=yum
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypp

echo "Checking system package manager..."
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
fi

# homebrew package manager detector
echo "Checking homebrew package manager..."
HOMEBREW_MANAGER=
type -p brew &> /dev/null
case "$(uname -s)" in
  "Darwin")
    HOMEBREW_MANAGER="brew install"
    type -p brew &> /dev/null
    if [ $? -ne 0 ]; then
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
    ;;
  "Linux")
    HOMEBREW_MANAGER="/home/linuxbrew/.linuxbrew/bin/brew install"
    type -p brew &> /dev/null
    if [ $? -ne 0 ]; then
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    fi
    eval $(SHELL=bash /home/linuxbrew/.linuxbrew/bin/brew shellenv)
    ;;
  ""|*)
    echo "Unable to detect the OS type to install homebrew"
    exit 1
esac

# golang detector
echo "Checking go..."
type -p go &> /dev/null
if [ $? -ne 0 ]; then
  GOINSTALL=
  case "$(uname -s)" in
    "Darwin")
      GOINSTALL=--darwin
      ;;
    "Linux")
      if [ "$(uname -m)" == "x86_64" ]; then
        GOINSTALL=--64
      else
        GOINSTALL=--32
      fi
      ;;
  esac
  curl -fsSL https://raw.githubusercontent.com/wwmoraes/golang-tools-install-script/master/goinstall.sh | bash -s - $GOINSTALL
fi

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until the parent has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

for PACKAGE in ${SYSTEM_PACKAGES[@]}; do
  echo "Checking system package $PACKAGE..."
  type -p $PACKAGE &> /dev/null && continue
  
  echo "Installing system package $PACKAGE..."
  sudo ${MANAGER} $PACKAGE
done

for PACKAGE in ${HOMEBREW_PACKAGES[@]}; do
  echo "Checking brew package $PACKAGE..."
  type -p $PACKAGE &> /dev/null && continue

  echo "Installing brew package $PACKAGE..."
  ${HOMEBREW_MANAGER} $PACKAGE
done

GOROOT=${GOROOT:-$HOME/.go}
GOPATH=${GOPATH:-$HOME/go}
for PACKAGE in ${GO_PACKAGES[@]}; do
  echo "Checking go package $PACKAGE..."
  test -d $GOPATH/src/$PACKAGE && continue

  echo "Installing go package $PACKAGE..."
  # go get $PACKAGE
done

for PACKAGE in ${PYTHON_PACKAGES[@]}; do
  echo "Checking python package $PACKAGE..."
  pip show $PACKAGE &>/dev/null && continue

  echo "Installing python package $PACKAGE..."
  sudo pip install $PACKAGE
done

### Set path
echo "Setting up fish path variable..."
fish -c ./variables.fish $PATH
