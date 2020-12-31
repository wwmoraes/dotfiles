#!/bin/bash

set -Eeuo pipefail

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"

### setup
POLYFILLS_RELATIVE_PATH=../.polyfills

### magic block :D
DIRNAME=$(perl -MCwd -e 'print Cwd::abs_path shift' $0 | xargs dirname)
# Checks and sets the file path corretly if running directly or sourced
if [ "$0" == "$BASH_SOURCE" ]; then
  POLYFILLS_PATH=$DIRNAME/$POLYFILLS_RELATIVE_PATH
else
  POLYFILLS_PATH=$DIRNAME/${BASH_SOURCE%%/*}/$POLYFILLS_RELATIVE_PATH
fi

printf "\e[1;33mPolyfills\e[0m\n"

for pf in $(ls $POLYFILLS_PATH); do
  printf "Checking \e[96m${pf}\e[0m...\n"
   
   if ! _=$(type -p $pf &> /dev/null); then
    printf "Polyfilling \e[96m${pf}\e[0m...\n"
    ln -sf "$POLYFILLS_PATH/$pf" "$HOME/.local/bin/$f"
   fi
done
