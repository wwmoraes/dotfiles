#!/bin/bash

printf "\e[1;34mGCP tools\e[0m\n"

printf "Checking \e[96mgcloud\e[0m...\n"
type -p gcloud &> /dev/null
if [ $? -ne 0 ]; then
  printf "Downloading and installing \e[96mGoogle SDK\e[0m...\n"
  curl https://sdk.cloud.google.com | bash -- --disable-prompts --install-dir=$HOME/.local/
fi
