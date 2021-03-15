#!/bin/bash

set -Eeuo pipefail

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"

### setup
POLYFILLS_RELATIVE_PATH=../.polyfills

### magic block :D
DIRNAME=$(perl -MCwd -e 'print Cwd::abs_path shift' "$0" | xargs dirname)
# Checks and sets the file path corretly if running directly or sourced
if [ "$0" == "${BASH_SOURCE[0]}" ]; then
  POLYFILLS_PATH=${DIRNAME}/${POLYFILLS_RELATIVE_PATH}
else
  POLYFILLS_PATH=${DIRNAME}/${BASH_SOURCE%%/*}/${POLYFILLS_RELATIVE_PATH}
fi

printf "\e[1;33mPolyfills\e[0m\n"

for POLYFILL in "${POLYFILLS_PATH}"/*; do
  printf "Checking \e[96m%s\e[0m...\n" "$(basename "${POLYFILL}")"

   if ! _=$(type -p "${POLYFILL}" &> /dev/null); then
    printf "Polyfilling \e[96m%s\e[0m...\n" "${POLYFILL}"
    ln -sf "${POLYFILLS_PATH}/${POLYFILL}" "$HOME/.local/bin/${POLYFILL}"
    chmod +x "$HOME/.local/bin/${POLYFILL}"
   fi
done
