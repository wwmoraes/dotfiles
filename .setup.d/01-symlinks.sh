#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

: "${DOTFILES_PATH:=${HOME}/.files}"

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

printf "\e[1;33mSymbolic links creation\e[0m\n"

# import common functions
# shellcheck source=../functions.sh
. "${DOTFILES_PATH}/functions.sh"

enterTmp
getPackages "symlinks.txt"
: "${PACKAGES:?run getPackages to generate}"

while IFS='|' read -r SRC DST; do
  # expand the user home
  SRC=$(printf "%s" "${SRC}" | sed "s|^~|${HOME}|")
  DST=$(printf "%s" "${DST}" | sed "s|^~|${HOME}|")

  printf "Checking \e[96m%s\e[0m...\n" "${DST}"
  # check if the destination is a link...
  if [ -L "${DST}" ]; then
    # ... and that it points to the expected source
    test "$(readlink "${DST}")" = "${SRC}" && continue
    # otherwise we unlink
    unlink "${DST}"
  else
    # not a link, so we remove it whatever type it is
    rm -rf "${DST}"
  fi

  printf "Linking \e[96m%s\e[0m...\n" "${DST}"
  # ensure the source directory exists, so we always link
  test -d "${SRC}" || mkdir -p "${SRC}"
  ln -sf "${SRC}" "${DST}" || true
done < "${PACKAGES}"
