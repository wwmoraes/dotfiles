#!/usr/bin/env sh

set -eu

export GIT_REFLOG_ACTION=applypatch-msg

HOOK="$(git rev-parse --git-path hooks/commit-msg)"

test -x "${HOOK}" && exec "${HOOK}" ${1+"$@"}; :
