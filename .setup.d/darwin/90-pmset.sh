#!/bin/bash

set -Eeuo pipefail

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

sudo pmset -a standbydelaylow 3600
sudo pmset -a highstandbythreshold 50
sudo pmset -a standbydelayhigh 10800
