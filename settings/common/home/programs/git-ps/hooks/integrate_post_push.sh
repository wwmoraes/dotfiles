#!/usr/bin/env sh

set -eum

ROOT=$(git rev-parse --show-toplevel)

mkdir -p "${ROOT}/.git/git-ps/logs"

exec 2>>"${ROOT}/.git/git-ps/logs/$(basename "$0").log"

log() { echo >&2 "$(date --utc +%FT%T.%3NZ) $*"; }

log "$(basename "$0") started"
