#!/bin/bash

[ $# -ne 1 ] && {
  echo "usage: $0 <module>"
  exit 1
}

if [ "$(lsmod | grep $1 | wc -l)" = "0" ]; then
  echo "enabling $1"
  sudo modprobe $1
else
  echo "disabling $1"
  sudo modprobe -r $1
fi
