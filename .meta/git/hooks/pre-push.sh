#!/usr/bin/env sh

set -u

export GIT_REFLOG_ACTION=pre-push

git stash push --keep-index --include-untracked | grep -vqFx "No local changes to save"
STASHED=$?

remake pushcheck
STATUS=$?

if [ "${STASHED}" -eq "0" ]; then
	git stash pop --quiet || true
fi

exit ${STATUS}
