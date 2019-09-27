#!/bin/bash

### setup
EXTENSIONS_FILE_NAME=.vscode/extensions.json

### magic block :D
DIRNAME=$(realpath $0 | xargs dirname)
# Checks and sets the file path corretly if running directly or sourced
if [ "$0" == "$BASH_SOURCE" ]; then
  EXTENSIONS_FILE_NAME=$(realpath $DIRNAME/../$EXTENSIONS_FILE_NAME)
else
  EXTENSIONS_FILE_NAME=$(realpath $DIRNAME/${BASH_SOURCE%%/*}/../$EXTENSIONS_FILE_NAME)
fi

echo -e "\e[1;33mVSCode extensions\e[0m"

### Check vscode
echo "Checking vscode..."
type -p code &> /dev/null
if [ $? -ne 0 ]; then
  echo "VSCode is not installed or in path"
  exit 1
fi

### Install packages
echo "Checking extensions..."
TMP=$(mktemp -d)
mknod $TMP/vscode-installed p
code --list-extensions | tr '[:upper:]' '[:lower:]' | sort > $TMP/vscode-installed &

mknod $TMP/vscode-extensions-list p
cat $EXTENSIONS_FILE_NAME | grep -vE "[ \t]*//.*" | jq .recommendations[] | tr -d '"' | sort > $TMP/vscode-extensions-list &

comm -13 $TMP/vscode-installed $TMP/vscode-extensions-list | uniq -u | while read EXTENSION; do
  echo -e "Installing \e[96m${EXTENSION}\e[0m..."
  code --install-extension $EXTENSION
done

rm -r $TMP
