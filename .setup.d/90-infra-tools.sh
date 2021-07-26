#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

# create temp work dir and traps cleanup
TMP=$(mktemp -d)
OLD_PWD="${PWD}"
cd "${TMP}"
trap 'cd "${OLD_PWD}"; rm -rf "${TMP}"' EXIT

printf "\e[1;34mInfrastructure tools\e[0m\n"

printf "Checking \e[96mterraform\e[0m...\n"
if ! _=$(command -V terraform >/dev/null 2>&1); then
  ### thank you hashicorp for fucking changing the pattern!
  # if ! VERSION=$(curl -sf https://releases.hashicorp.com/terraform/ | grep terraform_ | head -n1 | sed -E 's/.*terraform_([0-9.]+).*/\1/'); then
  #   echo "unable to fetch version tag"
  #   exit 1
  # fi
  VERSION=0.15.5

  printf "Downloading \e[96mterraform\e[0m ${VERSION}...\n"
  if ! curl -fsSLo terraform.zip "https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_${SYSTEM}_${ARCH}.zip" > /dev/null; then
    echo "failed to download"
    exit 1
  fi

  printf "Installing \e[96mterraform\e[0m...\n"

  unzip terraform.zip
  chmod +x terraform
  mv terraform ~/.local/bin
fi
