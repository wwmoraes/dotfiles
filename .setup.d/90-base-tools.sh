#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"
: "${PACKAGES_PATH:?must be set}"

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

# create temp work dir and traps cleanup
TMP=$(mktemp -d)
OLD_PWD="${PWD}"
cd "${TMP}"
trap 'cd "${OLD_PWD}"; rm -rf "${TMP}"' EXIT

printf "\e[1;34mBase tools\e[0m\n"

printf "Checking \e[96mpet\e[0m...\n"
if ! _=$(command -V pet > /dev/null 2>&1); then
  BASE_URL=https://github.com/knqyf263/pet
  VERSION="$(curl -sI "${BASE_URL}/releases/latest" | sed -En 's/^[Ll]ocation: .*\/v([0-9.]+).*/\1/p')"
  DOWNLOAD_URL="${BASE_URL}/releases/download/v${VERSION}/pet_${VERSION}_${SYSTEM}_${ARCH}.tar.gz"

  printf "Downloading \e[96mpet\e[0m...\n"
  curl -fsSL "${DOWNLOAD_URL}" | tar xzf -
  printf "Installing \e[96mpet\e[0m...\n"
  chmod +x pet
  mv pet "${HOME}/.local/bin"
fi

printf "Checking \e[96mplantuml\e[0m...\n"
if ! _=$(command -V plantuml.jar > /dev/null 2>&1); then
  printf "Downloading \e[96mplantuml\e[0m...\n"
  curl -fsSLO https://netix.dl.sourceforge.net/project/plantuml/plantuml.jar
  printf "Installing \e[96mplantuml\e[0m...\n"
  install -g "$(id -g)" -o "$(id -u)" -m 0750 plantuml.jar "${HOME}/.local/bin/plantuml.jar"
fi

printf "Checking \e[96mgrawkit\e[0m...\n"
if ! _=$(command -V grawkit > /dev/null 2>&1); then
  printf "Downloading \e[96mgrawkit\e[0m...\n"
  curl -fsSLO https://raw.githubusercontent.com/deuill/grawkit/master/grawkit
  printf "Installing \e[96mgrawkit\e[0m...\n"
  install -g "$(id -g)" -o "$(id -u)" -m 0750 grawkit "${HOME}/.local/bin/grawkit"
fi
