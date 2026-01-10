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

: "${TITLE:=$(git log "${SOURCE_BRANCH}^..${SOURCE_BRANCH}" --pretty=format:%s 2> /dev/null)}"
: "${DESCRIPTION=$(git request-pull "${TARGET_BRANCH}" "${REMOTE_URL}" 2>/dev/null)}"

azure_devops_handler() {
	log "Azure DevOps detected"

	if ! PULL_REQUEST_ID=$(az repos pr list \
		--detect \
		--output tsv \
		--query [0].pullRequestId \
		--source-branch "${SOURCE_BRANCH}" \
		--status active \
		--target-branch "${TARGET_BRANCH}" \
		--top 1 \
		;); then
		log "failed to get the state of PRs"
		exit 1
	fi

	if [ -n "${PULL_REQUEST_ID}" ]; then
		log "updating PR"
		az repos pr update \
			--id "${PULL_REQUEST_ID}" \
			--description "${DESCRIPTION}" \
			--detect \
			--title "${TITLE}" \
			> /dev/null
	else
		log "creating PR"
		az repos pr create \
			--description "${DESCRIPTION}" \
			--detect \
			--draft \
			--open \
			--source-branch "${SOURCE_BRANCH}" \
			--target-branch "${TARGET_BRANCH}" \
			--title "${TITLE}" \
			> /dev/null
	fi
}

github_handler() {
	log "GitHub detected"

	if CLOSED=$(gh pr view \
		--repo "${REMOTE_URL}" \
		--json closed \
		--jq .closed \
		"${SOURCE_BRANCH}" \
		2>/dev/null) && [ "${CLOSED}" != "true" ]; then
		log "An open PR was found for the branch, so exiting to prevent duplicate PR creation."
		exit 0
	fi

	gh pr create \
		--draft \
		--title "${TITLE}" \
		--body "${DESCRIPTION}" \
		--base "${TARGET_BRANCH}" \
		--head "${SOURCE_BRANCH}" \
		--repo "${REMOTE_URL}" \
		--editor \
		;
}

case "${REMOTE_URL}" in
	"*dev.azure.com*") azure_devops_handler;;
	"*github.com*") github_handler;;
	"*") log "unsupported remote: ${REMOTE_URL}"; exit 1;;
esac
