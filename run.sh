#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

if [ $# -lt 1 ]; then
  echo "usage: $0 <script-path-to-run> [args]"
  exit 2
fi

: "${DOTFILES_PATH:=${HOME}/.files}"

# import common functions
# shellcheck source=functions.sh
. "${DOTFILES_PATH}/functions.sh"

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
TAGSRC="${HOME}/.tagsrc"
: "${PACKAGES_PATH:=${DOTFILES_PATH}/.setup.d/packages}"
set +a

echo "dotfiles path: ${DOTFILES_PATH}"
echo "System: ${SYSTEM}"
echo "Architecture: ${ARCH}"
echo "Tags: ${TAGS}"
echo "Is work? ${WORK}"
echo "Is personal? ${PERSONAL}"
echo "packages path: ${PACKAGES_PATH}"

SCRIPT="${1}"
shift

sh "${SCRIPT}" "$@"
