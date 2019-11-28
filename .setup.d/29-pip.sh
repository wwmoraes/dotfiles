#!/bin/bash

printf "\e[1;34mExternal pip install\e[0m\n"

printf "Checking \e[96mpip\e[0m...\n"
type -p pip &> /dev/null
if [ $? -ne 0 ]; then
  TMP=$(mktemp -t get-pip.py)
  curl https://bootstrap.pypa.io/get-pip.py -o $TMP 2> /dev/null
  sudo python $TMP
  rm $TMP
fi
