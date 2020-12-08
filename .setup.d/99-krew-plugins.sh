#!/bin/bash

### setup
PACKAGES_FILE_NAME=packages/krew.txt

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

printf "\e[1;33mKrew plugins\e[0m\n"

### Check package tool
echo "Checking krew plugin manager..."
kubectl plugin list 2> /dev/null | grep kubectl-krew > /dev/null
if [ $? -ne 0 ]; then
  pushd "$(mktemp -d)" > /dev/null
  curl -fsSLO https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz
  curl -fsSLO https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.yaml
  tar xzf krew.tar.gz
  KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_$(uname -m | sed -e 's/x86_64/amd64/' -e 's/arm.*$/arm/')"
  $KREW install \
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
