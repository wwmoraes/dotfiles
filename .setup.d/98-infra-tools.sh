#!/bin/bash

printf "\e[1;34mInfrastructure tools\e[0m\n"

printf "Checking \e[96mterraform\e[0m...\n"
type -p terraform &> /dev/null
if [ $? -ne 0 ]; then
  VERSION=0.12.16

  PLATFORM=$(uname -s | tr '[:upper:]' '[:lower:]')

  case "$(uname -m | tr '[:upper:]' '[:lower:]')" in
    x86|386) HARDWARE=386;;
    arm*) HARDWARE=arm;;
    x86_64|amd64|""|*) HARDWARE=amd64;;
  esac

  printf "Downloading \e[96mterraform\e[0m...\n"
  curl -Lo ~/.local/bin/terraform.zip https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_${PLATFORM}_${HARDWARE}.zip > /dev/null

  printf "Installing \e[96mterraform\e[0m...\n"
  pushd ~/.local/bin > /dev/null && \
  unzip terraform.zip && \
  rm terraform.zip && \
  chmod +x terraform && \
  popd > /dev/null
fi
