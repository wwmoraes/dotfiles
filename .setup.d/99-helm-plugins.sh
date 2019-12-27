#!/bin/bash

printf "\e[1;34mhelm plugins\e[0m\n"

WANTED_PLUGINS=(
  push
)

REPOS=()
REPOS[push]=https://github.com/chartmuseum/helm-push

INSTALLED_PLUGINS=($(helm plugin list | awk 'NR != 1 {print $1}'))

for PLUGIN in ${WANTED_PLUGINS[@]}; do
  printf "Checking \e[96m${PLUGIN}\e[0m...\n"
  printf "%s\n" ${PLUGINS[@]} | grep -q $PLUGIN || {
    printf "Installing \e[96m${PLUGIN}\e[0m...\n"
    helm plugin install ${REPOS[$PLUGIN]}
  }
done
