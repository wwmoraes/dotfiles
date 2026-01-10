#!/usr/bin/env sh

set -eu

git interpret-trailers --in-place --trailer signer --trailer patch-stack --trim-empty "$1"
