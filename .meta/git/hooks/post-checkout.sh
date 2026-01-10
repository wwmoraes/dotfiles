#!/usr/bin/env sh

set -eu

cd "$(git rev-parse --show-toplevel)"
test -x ./configure && ./configure; :
