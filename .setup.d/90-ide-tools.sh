#!/bin/bash

set -Eeuo pipefail

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"

### setup
EXTENSIONS_FILE_NAME=.vscode/extensions.json

### magic block :D
DIRNAME=$(perl -MCwd -e 'print Cwd::abs_path shift' $0 | xargs dirname)
# Checks and sets the file path corretly if running directly or sourced
if [ "$0" == "$BASH_SOURCE" ]; then
  EXTENSIONS_FILE_NAME=$(perl -MCwd -e 'print Cwd::abs_path shift' $DIRNAME/../$EXTENSIONS_FILE_NAME)
else
  EXTENSIONS_FILE_NAME=$(perl -MCwd -e 'print Cwd::abs_path shift' $DIRNAME/${BASH_SOURCE%%/*}/../$EXTENSIONS_FILE_NAME)
fi

printf "\e[1;33mVSCode extensions\e[0m\n"

### Check vscode
printf "Checking \e[96mcode\e[0m...\n"
VSCODE=$(command -v code || command -v code-oss)
if [ ! "$VSCODE" = "" ]; then
  TMP=$(mktemp -d)

  mkfifo $TMP/vscode-installed
  $VSCODE --list-extensions | tr '[:upper:]' '[:lower:]' | sort > $TMP/vscode-installed &

  mkfifo $TMP/vscode-extensions-list
  cat $EXTENSIONS_FILE_NAME | grep -vE "[ \t]*//.*" | jq .recommendations[] | tr -d '"' | sort > $TMP/vscode-extensions-list &

  comm -13 $TMP/vscode-installed $TMP/vscode-extensions-list | uniq -u | while read EXTENSION; do
    printf "Installing \e[96m${EXTENSION}\e[0m...\n"
    $VSCODE --install-extension ${EXTENSION}
  done

  rm -r $TMP
else
  echo "code is not installed or in path"
fi
