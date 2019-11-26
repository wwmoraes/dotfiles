#!/bin/bash

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
echo "Checking vscode..."
type -p code &> /dev/null
if [ $? -eq 0 ]; then
  ### Install packages
  echo "Checking extensions..."
  TMP=$(mktemp -d)
  # mknod $TMP/vscode-installed p
  mkfifo $TMP/vscode-installed
  code --list-extensions | tr '[:upper:]' '[:lower:]' | sort > $TMP/vscode-installed &

  # mknod $TMP/vscode-extensions-list p
  mkfifo $TMP/vscode-extensions-list
  cat $EXTENSIONS_FILE_NAME | grep -vE "[ \t]*//.*" | jq .recommendations[] | tr -d '"' | sort > $TMP/vscode-extensions-list &

  comm -13 $TMP/vscode-installed $TMP/vscode-extensions-list | uniq -u | while read EXTENSION; do
    printf "Installing \e[96m${EXTENSION}\e[0m...\n"
    code --install-extension $EXTENSION
  done

  rm -r $TMP
else
  echo "VSCode is not installed or in path"
fi
