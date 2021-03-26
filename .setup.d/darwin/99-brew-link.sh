#!/bin/sh
#
# Homebrew doesn't link keg-only packages to /usr/local/{bin,sbin},
#   even with `brew link --force <package>`
#   instead, they recommend adding /usr/local/opt/<package>/{bin,sbin}
#   to your path (LOL). Democracy uh?
#

set -eum
trap 'kill 0' INT HUP TERM

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"
: "${PACKAGES_PATH:?must be set}"

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

# create temp work dir and traps cleanup
TMP=$(mktemp -d)
OLD_PWD="${PWD}"
cd "${TMP}"
trap 'cd "${OLD_PWD}"; rm -rf "${TMP}"' EXIT

printf "\e[1;33mHomebrew (correct) linking\e[0m\n"

CHECKMARK=$(printf "\xE2\x9C\x94")
CROSSMARK=$(printf "\xE2\x9C\x96")
RIGHTWARDS_ARROW=$(printf "\xE2\x9E\xBE")

rm -rf "${HOME}"/.local/opt/bin
rm -rf "${HOME}"/.local/opt/sbin
mkdir -p "${HOME}"/.local/opt/bin
mkdir -p "${HOME}"/.local/opt/sbin

for package in /usr/local/opt/*; do
  NAME=$(basename "${package}")
  BINS="${TMP}/bins-${NAME}"
  touch "${BINS}"

  printf "Checking \e[96m%s\e[0m..." "${NAME}"

  if [ -d "${package}/bin" ]; then
    for bin in "${package}"/bin/*; do
      if ! _=$(command -V "${bin}" >/dev/null 2>&1); then
        basename "${bin}" >> "${BINS}"
        ln -sf "${bin}" ~/.local/opt/bin
      fi
    done
  fi

  if [ -d "${package}/sbin" ]; then
    for sbin in "${package}"/sbin/*; do
      if ! _=$(command -V "${sbin}" >/dev/null 2>&1); then
        basename "${sbin}" >> "${BINS}"
        ln -sf "${sbin}" ~/.local/opt/sbin
      fi
    done
  fi

  if [ "$(wc -l "${BINS}" | awk '{print $1}')" != "0" ]; then
    printf "\e[91m%s\e[0m %s %s\n" "${CROSSMARK}" "${RIGHTWARDS_ARROW}" "$(tr '\n' ' ' < "${BINS}")"
  else
    printf "\e[92m%s\e[0m\n" "${CHECKMARK}"
  fi
done
