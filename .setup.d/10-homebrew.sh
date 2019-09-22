#!/bin/bash

### setup
PACKAGES_FILE_NAME=packages/homebrew.txt

### magic block :D
DIRNAME=$(realpath $0 | xargs dirname)
# Checks and sets the file path corretly if running directly or sourced
if [ "$0" == "$BASH_SOURCE" ]; then
  PACKAGES_FILE_PATH=$DIRNAME/$PACKAGES_FILE_NAME
else
  PACKAGES_FILE_PATH=$DIRNAME/${BASH_SOURCE%%/*}/$PACKAGES_FILE_NAME
fi
readarray PACKAGES < $PACKAGES_FILE_PATH

echo -e "\e[1;33mHomebrew packages\e[0m"

### Check package tool
echo "Checking homebrew manager..."
HOMEBREW_MANAGER=
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

### Install packages
for PACKAGE in ${PACKAGES[@]}; do
  echo -e "Checking \e[96m${PACKAGE}\e[0m..."
  type -p ${PACKAGE} &> /dev/null && continue

  echo -e "Installing \e[96m${PACKAGE}\e[0m..."
  ${HOMEBREW_MANAGER} ${PACKAGE}
done
