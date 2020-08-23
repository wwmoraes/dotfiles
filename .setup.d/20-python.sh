#!/bin/bash

### setup
PACKAGES_FILE_NAME=packages/pip.txt

### magic block :D
DIRNAME=$(perl -MCwd -e 'print Cwd::abs_path shift' $0 | xargs dirname)
# Checks and sets the file path corretly if running directly or sourced
if [ "$0" == "$BASH_SOURCE" ]; then
  PACKAGES_FILE_PATH=$DIRNAME/$PACKAGES_FILE_NAME
else
  PACKAGES_FILE_PATH=$DIRNAME/${BASH_SOURCE%%/*}/$PACKAGES_FILE_NAME
fi

PACKAGES=()
while IFS= read -r line; do
   PACKAGES+=("$line")
done <$PACKAGES_FILE_PATH

printf "\e[1;33mPython pip packages\e[0m\n"

### Check package tool
printf "Checking \e[96mpip\e[0m manager...\n"
type -p pip3.8 &> /dev/null
if [ $? -ne 0 ]; then
  TMP=$(mktemp -t get-pip.py)
  curl https://bootstrap.pypa.io/get-pip.py -o $TMP 2> /dev/null
  sudo python3.8 $TMP
  rm $TMP
fi

### Install packages
for PACKAGE in ${PACKAGES[@]}; do
  printf "Checking \e[96m${PACKAGE}\e[0m...\n"
  pip3.8 show $PACKAGE &>/dev/null && continue

  printf "Installing \e[96m${PACKAGE}\e[0m...\n"
  sudo -H pip3.8 install $PACKAGE
done
