#!/bin/bash

### setup
PACKAGES_FILE_NAME=packages/krew.txt

### magic block :D
DIRNAME=$(realpath $0 | xargs dirname)
# Checks and sets the file path corretly if running directly or sourced
if [ "$0" == "$BASH_SOURCE" ]; then
  PACKAGES_FILE_PATH=$DIRNAME/$PACKAGES_FILE_NAME
else
  PACKAGES_FILE_PATH=$DIRNAME/${BASH_SOURCE%%/*}/$PACKAGES_FILE_NAME
fi
readarray PACKAGES < $PACKAGES_FILE_PATH

printf "\e[1;33mKrew plugins\e[0m\n"

### Check package tool
echo "Checking krew plugin manager..."
kubectl plugin list 2> /dev/null | grep kubectl-krew > /dev/null
if [ $? -ne 0 ]; then
  pushd "$(mktemp -d)" > /dev/null
  curl -fsSLO "https://storage.googleapis.com/krew/v0.2.1/krew.{tar.gz,yaml}"
  tar zxvf krew.tar.gz
  ./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64" install \
    --manifest=krew.yaml --archive=krew.tar.gz
  popd > /dev/null

  echo "Initializing krew..."
  kubectl krew update
fi

### Install packages
for PACKAGE in ${PACKAGES[@]}; do
  printf "Checking \e[96m${PACKAGE}\e[0m...\n"
  kubectl krew list | grep $PACKAGE > /dev/null && continue

  printf "Installing \e[96m${PACKAGE}\e[0m...\n"
  kubectl krew install $PACKAGE
done
