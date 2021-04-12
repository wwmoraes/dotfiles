#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

if [ $# -lt 1 ]; then
  echo "usage: $0 <script-path-to-run> [args]"
  exit 2
fi

# import common functions
# shellcheck source=functions.sh
. "${HOME}/.files/functions.sh"

### variables used across the setup files
set -a
: "${TRACE:=0}"
: "${VERBOSE:=0}"
SYSTEM=$(getOS)
ARCH=$(getArch)
TAGS=$(getTags)
WORK=$(isWork)
PERSONAL=$(isPersonal)
HOST=$(hostname -s)
PACKAGES_PATH="${HOME}/.files/.setup.d/packages"
TAGSRC="${HOME}/.tagsrc"
set +a

echo "System: ${SYSTEM}"
echo "Architecture: ${ARCH}"
echo "Tags: ${TAGS}"
echo "Is work? ${WORK}"
echo "Is personal? ${PERSONAL}"
echo "packages path: ${PACKAGES_PATH}"

SCRIPT="${1}"
shift

sh "${SCRIPT}" "$@"
