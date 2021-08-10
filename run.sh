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
: "${PACKAGES_PATH:=${DOTFILES_PATH}/.setup.d/packages}"
: "${TAGSRC:=${HOME}/.tagsrc}"
: "${SYSTEM:=$(getOS)}"
: "${ARCH:=$(getArch)}"
: "${TAGS:=$(getTags)}"
: "${WORK:=$(isWork)}"
: "${PERSONAL:=$(isPersonal)}"
: "${HOST:=$(hostname -s)}"
set +a

echo "dotfiles path: ${DOTFILES_PATH}"
echo "packages path: ${PACKAGES_PATH}"
echo "Tags rc file: ${TAGSRC}"
echo "System: ${SYSTEM}"
echo "Architecture: ${ARCH}"
echo "Tags: ${TAGS}"
echo "Is work? ${WORK}"
echo "Is personal? ${PERSONAL}"
echo "Host: ${HOST}"

SCRIPT="$1"
shift
sh "${SCRIPT}" "$@"
