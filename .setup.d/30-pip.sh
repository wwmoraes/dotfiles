#!/bin/bash

### setup
PACKAGES_FILE_NAME=packages/pip.txt

### magic block :D
DIRNAME=$(realpath $0 | xargs dirname)
# Checks and sets the file path corretly if running directly or sourced
if [ "$0" == "$BASH_SOURCE" ]; then
  PACKAGES_FILE_PATH=$DIRNAME/$PACKAGES_FILE_NAME
else
  PACKAGES_FILE_PATH=$DIRNAME/${BASH_SOURCE%%/*}/$PACKAGES_FILE_NAME
fi
readarray PACKAGES < $PACKAGES_FILE_PATH

echo -e "\e[1;33mPython pip packages\e[0m"

### Check package tool
echo "Checking pip manager..."
type -p pip &> /dev/null
if [ $? -ne 0 ]; then
  echo "python pip is not installed or in path"
  exit 1
fi

### Install packages
for PACKAGE in ${PACKAGES[@]}; do
  echo "Checking ${PACKAGE}..."
  pip show $PACKAGE &>/dev/null && continue

  echo "Installing ${PACKAGE}..."
  sudo pip install $PACKAGE
done
