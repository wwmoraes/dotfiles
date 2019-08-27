#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: $0 <tool> <file>"
  exit 1
fi

TOOL=$1
FILE=$2

if [ -L "$FILE" ]; then
  echo "$FILE is a symbolic link already"
  exit 1
fi

if [ ! $(echo "$FILE" | grep "$HOME") ]; then
  echo "Can't add file: it isn't in your home"
  exit 1
fi

DESTINATION=$(echo $FILE | sed "s#$HOME#$(pwd)/$TOOL#")

echo "adding $FILE to $DESTINATION"
mkdir -p $(dirname $DESTINATION)
cp "$FILE" "$DESTINATION"

echo "Removing origin file $FILE"
rm "$FILE"

echo "stowing tool $TOOL"
stow -t ~ -R "$TOOL"