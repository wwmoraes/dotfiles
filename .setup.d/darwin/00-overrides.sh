#!/bin/bash

ln -sf /usr/local/bin/python3 /usr/local/bin/python

# link VSCode user folder
SOURCE="$HOME/.config/Code/User"
TARGET="$HOME/Library/Application Support/Code/User"
if [[ ! -L "${TARGET}" ]]; then
  rm -rf "${TARGET}"
  ln -sf "${SOURCE}" "${TARGET}"
fi