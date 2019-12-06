#!/bin/bash

printf "\e[1;34mBase tools\e[0m\n"

printf "Checking \e[96mpet\e[0m...\n"
type -p pet > /dev/null
if [ $? -ne 0 ]; then
  BASE_URL=https://github.com/knqyf263/pet

  VERSION="$(curl -sI ${BASE_URL}/releases/latest | sed -En 's/^Location: .*\/v([0-9.]+).*/\1/p')"

  PLATFORM=$(uname -s | tr '[:upper:]' '[:lower:]')

  case "$(uname -m | tr '[:upper:]' '[:lower:]')" in
    x86|386)
      HARDWARE=386
      ;;
    arm*)
      HARDWARE=arm
      ;;
    x86_64|amd64|""|*)
      HARDWARE=amd64
      ;;
  esac

  DOWNLOAD_URL=${BASE_URL}/releases/download/v${VERSION}/pet_${VERSION}_${PLATFORM}_${HARDWARE}.tar.gz

  pushd ~/.local/bin > /dev/null
  printf "Downloading \e[96mpet\e[0m...\n"
  curl -fsSLo pet.tar.gz $DOWNLOAD_URL
  printf "Extracting \e[96mpet\e[0m...\n"
  tar -xzf pet.tar.gz
  rm pet.tar.gz
  popd > /dev/null
fi
