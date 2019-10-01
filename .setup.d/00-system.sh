#!/bin/bash

### setup
PACKAGES_FILE_NAME=packages/system.txt

### magic block :D
DIRNAME=$(realpath $0 | xargs dirname)
# Checks and sets the file path corretly if running directly or sourced
if [ "$0" == "$BASH_SOURCE" ]; then
  PACKAGES_FILE_PATH=$DIRNAME/$PACKAGES_FILE_NAME
else
  PACKAGES_FILE_PATH=$DIRNAME/${BASH_SOURCE%%/*}/$PACKAGES_FILE_NAME
fi
readarray PACKAGES < $PACKAGES_FILE_PATH

echo -e "\e[1;33mSystem packages\e[0m"

### Check package tool
# empty manager
MANAGER=

# Manager options
declare -A osInfo;
osInfo[/etc/debian_version]="apt-get install --no-install-recommends --no-install-suggests"
osInfo[/etc/arch-release]="pacman -S"
osInfo[/etc/redhat-release]=yum
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypp

echo "Checking system manager..."
# Get manager
for f in ${!osInfo[@]}; do
  if [[ -f $f ]]; then
    MANAGER=${osInfo[$f]}
    break
  fi
done

if [ "${MANAGER}" = "" ]; then
  echo -e "ERROR\nUnable to detect the OS package manager"
  exit 1
fi

### Install packages
for PACKAGE in ${PACKAGES[@]}; do
  echo -e "Checking \e[96m${PACKAGE%%:*}\e[0m..."
  type -p ${PACKAGE##*:} &> /dev/null && continue

  echo -e "Installing \e[96m${PACKAGE%%:*}\e[0m..."
  sudo ${MANAGER} ${PACKAGE%%:*}
done
