#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

: "${DOTFILES_PATH:=${HOME}/.files}"
: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

### setup
POLYFILLS_PATH="${HOME}/.files/.polyfills"

printf "\e[1;33mPolyfills\e[0m\n"

for POLYFILL in "${POLYFILLS_PATH}"/*; do
  COMMAND=$(basename "${POLYFILL}")
  printf "Checking \e[91m%s\e[0m...\n" "${COMMAND}"
  command -V "${COMMAND}" >/dev/null 2>&1 && continue

  printf "Polyfilling \e[91m%s\e[0m...\n" "${COMMAND}"
  ln -sf "${POLYFILL}" "${HOME}/.local/bin/${COMMAND}"
  chmod +x "${HOME}/.local/bin/${COMMAND}"
done
