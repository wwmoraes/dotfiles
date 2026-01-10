#!/usr/bin/env sh

set -eum

ROOT=$(git rev-parse --show-toplevel)

mkdir -p "${ROOT}/.git/git-ps/logs"

exec 2>>"${ROOT}/.git/git-ps/logs/$(basename "$0").log"

log() { echo >&2 "$(date --utc +%FT%T.%3NZ) $*"; }

log "$(basename "$0") started"

git remote set-head "${REMOTE_NAME}" --auto > /dev/null

: "${SOURCE_BRANCH:=${1:-$(git branch --show-current 2> /dev/null)}}"
: "${TARGET_BRANCH:=${2:-$(git symbolic-ref "refs/remotes/${REMOTE_NAME}/HEAD" --short) 2> /dev/null}}"
: "${REMOTE_NAME:=${3:-$(git remote 2> /dev/null)}}"
: "${REMOTE_URL:=${4:-$(git remote get-url "${REMOTE_NAME}" 2> /dev/null)}}"

: "${SOURCE_BRANCH:?must be set}"
: "${TARGET_BRANCH:?must be set}"
: "${REMOTE_NAME:?must be set}"
: "${REMOTE_URL:?must be set}"

github_handler() {
	gh pr --repo "${REMOTE_URL}" checks "${SOURCE_BRANCH}"
}

case "${REMOTE_URL}" in
	# "*dev.azure.com*") azure_devops_handler;;
	"*github.com*") github_handler;;
	"*") log "unsupported remote: ${REMOTE_URL}"; exit 1;;
esac
