#!/bin/bash

printf "\e[1;34mInfrastructure tools\e[0m\n"

printf "Checking \e[96mterraform\e[0m...\n"
type -p terraform &> /dev/null
if [ $? -ne 0 ]; then
  VERSION=$(curl -sf https://releases.hashicorp.com/terraform/ | grep terraform_ | head -n1 | sed -E 's/.*terraform_([0-9.]+).*/\1/')

  printf "Downloading \e[96mterraform\e[0m...\n"
  curl -Lo ~/.local/bin/terraform.zip https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_${SYSTEM}_${ARCH}.zip > /dev/null

  printf "Installing \e[96mterraform\e[0m...\n"
  pushd ~/.local/bin > /dev/null && \
  unzip terraform.zip && \
  rm terraform.zip && \
  chmod +x terraform && \
  popd > /dev/null
fi
