#!/bin/bash

set -Eeuo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: $0 <script-path-to-run> [args]"
  exit 2
fi

set +m # disable job control in order to allow lastpipe
if [ "$(shopt | grep -c lastpipe)" = "1" ]; then
  shopt -s lastpipe
fi

# import common functions
. functions.sh

### variables used across the setup files
export SYSTEM=$(getOS)
echo "System: ${SYSTEM}"
export ARCH=$(getArch)
echo "Architecture: ${ARCH}"
export WORK=$(isWork)
echo "Is work? ${WORK}"
export PERSONAL=$(isPersonal)
echo "Is personal? ${PERSONAL}"

SCRIPT="${1}"
shift

exec "${SCRIPT}" "$@"
