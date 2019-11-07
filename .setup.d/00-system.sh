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

printf "\e[1;33mSystem packages\e[0m\n"

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
  printf "ERROR\nUnable to detect the OS package manager\n"
  exit 1
fi

### Install packages
for PACKAGE in ${PACKAGES[@]}; do
  printf "Checking \e[96m${PACKAGE%%:*}\e[0m...\n"
  type -p ${PACKAGE##*:} &> /dev/null && continue

  printf "Installing \e[96m${PACKAGE%%:*}\e[0m...\n"
  sudo ${MANAGER} ${PACKAGE%%:*}
done
