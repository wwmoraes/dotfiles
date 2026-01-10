#!/usr/bin/env sh

set -eu

export GIT_REFLOG_ACTION=pre-merge-commit

HOOK="$(git rev-parse --git-path hooks/pre-commit)"

test -x "${HOOK}" && exec "${HOOK}"; :
