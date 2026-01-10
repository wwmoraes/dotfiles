#!/usr/bin/env sh

set -eu

grep -q "^fixup! " "$1" || cog verify --file "$1"

git interpret-trailers --in-place --trailer signer --trailer patch-stack --trim-empty "$1"
