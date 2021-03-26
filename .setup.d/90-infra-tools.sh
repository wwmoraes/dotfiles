#!/bin/bash

set -Eeuo pipefail

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

printf "\e[1;34mInfrastructure tools\e[0m\n"

printf "Checking \e[96mterraform\e[0m...\n"
if ! _=$(type -p terraform &> /dev/null); then
  VERSION=$(curl -sf https://releases.hashicorp.com/terraform/ | grep terraform_ | head -n1 | sed -E 's/.*terraform_([0-9.]+).*/\1/')

  printf "Downloading \e[96mterraform\e[0m...\n"
  curl -fsSLo ~/.local/bin/terraform.zip "https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_${SYSTEM}_${ARCH}.zip" > /dev/null

  printf "Installing \e[96mterraform\e[0m...\n"
  pushd ~/.local/bin > /dev/null && \
  unzip terraform.zip && \
  rm terraform.zip && \
  chmod +x terraform && \
  popd > /dev/null
fi
