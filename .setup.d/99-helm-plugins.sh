#!/bin/bash

set -Eeuo pipefail

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"

printf "\e[1;34mhelm plugins\e[0m\n"

PLUGINS=(
  "push|https://github.com/chartmuseum/helm-push"
)

INSTALLED_PLUGINS=($(helm plugin list 2>/dev/null | awk 'NR != 1 {print $1}'))

for PLUGIN in ${PLUGINS[@]}; do
  PLUGIN_NAME="${PLUGIN%%|*}"
  PLUGIN_URL="${PLUGIN##*|}"
  printf "Checking \e[96m${PLUGIN_NAME}\e[0m...\n"
  printf "%s\n" ${INSTALLED_PLUGINS[@]} | grep -q ${PLUGIN_NAME} || {
    printf "Installing \e[96m${PLUGIN_NAME}\e[0m...\n"
    helm plugin install ${PLUGIN_URL}
  }
done
