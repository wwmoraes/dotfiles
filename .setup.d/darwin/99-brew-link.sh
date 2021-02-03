#!/bin/bash
###
### Homebrew doesn't link keg-only packages to /usr/local/{bin,sbin},
###   even with `brew link --force <package>`
###   instead, they recommend adding /usr/local/opt/<package>/{bin,sbin}
###   to your path (LOL). Democracy uh?
###

set -Eeuo pipefail

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"

printf "\e[1;33mHomebrew (correct) linking\e[0m\n"

CHECKMARK=$(printf "\xE2\x9C\x94")
CROSSMARK=$(printf "\xE2\x9C\x96")
RIGHTWARDS_ARROW=$(printf "\xE2\x9E\xBE")

rm -rf "${HOME}"/.local/opt/{bin,sbin}
mkdir -p "${HOME}"/.local/opt/{bin,sbin}

brew link --overwrite python@3.9 || true

for package in /usr/local/opt/*; do
  # echo $package
  printf "Cheking \e[96m%s\e[0m..." "$( basename "${package}")"

  BINS=()

  if [ -d "/usr/local/opt/${package}/bin" ]; then
    for bin in /usr/local/opt/"${package}"/bin/*; do
      if ! _=$(type -p "${bin}" &> /dev/null); then
        BINS+=("${bin}")
        ln -sf "/usr/local/opt/${package}/bin/${bin}" ~/.local/opt/bin
      fi
    done
  fi

  if [ -d "/usr/local/opt/${package}/sbin" ]; then
    for sbin in /usr/local/opt/"${package}"/sbin/*; do
      if ! _=$(type -p "${sbin}" &> /dev/null); then
        BINS+=("${sbin}")
        ln -sf "/usr/local/opt/${package}/sbin/${sbin}" ~/.local/opt/sbin
      fi
    done
  fi

  if [[ ${#BINS[@]} -gt 0 ]]; then
    printf "\e[91m%s\e[0m %s %s\n" "${CROSSMARK}" "${RIGHTWARDS_ARROW}" "${BINS[*]}"
  else
    printf "\e[92m%s\e[0m\n" "${CHECKMARK}"
  fi
done
