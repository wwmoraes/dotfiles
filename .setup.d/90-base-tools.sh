#!/bin/bash

set -Eeuo pipefail

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

printf "\e[1;34mBase tools\e[0m\n"

printf "Checking \e[96mpet\e[0m...\n"
if ! _=$(type -p pet > /dev/null); then
  BASE_URL=https://github.com/knqyf263/pet

  VERSION="$(curl -sI "${BASE_URL}/releases/latest" | sed -En 's/^[Ll]ocation: .*\/v([0-9.]+).*/\1/p')"

  DOWNLOAD_URL="${BASE_URL}/releases/download/v${VERSION}/pet_${VERSION}_${SYSTEM}_${ARCH}.tar.gz"

  pushd ~/.local/bin > /dev/null
  printf "Downloading \e[96mpet\e[0m...\n"
  curl -fsSLo pet.tar.gz "${DOWNLOAD_URL}"
  printf "Extracting \e[96mpet\e[0m...\n"
  tar -xzf pet.tar.gz
  rm pet.tar.gz
  popd > /dev/null
fi

printf "Checking \e[96mplantuml\e[0m...\n"
if ! _=$(type -p plantuml.jar > /dev/null); then
  TMP=$(mktemp -d)
  pushd "${TMP}" >& /dev/null
  printf "Downloading \e[96mplantuml\e[0m...\n"
  curl -fsSLO https://netix.dl.sourceforge.net/project/plantuml/plantuml.jar
  printf "Installing \e[96mplantuml\e[0m...\n"
  install -g "$(id -g)" -o "$(id -u)" -m 0750 plantuml.jar ~/.local/bin/plantuml.jar
  popd >& /dev/null
fi
