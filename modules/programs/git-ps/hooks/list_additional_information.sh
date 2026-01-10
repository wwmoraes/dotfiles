#!/usr/bin/env sh

set -eum

ROOT=$(git rev-parse --show-toplevel)

mkdir -p "${ROOT}/.git/git-ps/logs"

exec 2>>"${ROOT}/.git/git-ps/logs/$(basename "$0").log"

log() { echo >&2 "$(date --utc +%FT%T.%3NZ) $*"; }

log "$(basename "$0") started"

: "${PATCH_INDEX:=${1:-}}"
: "${PATCH_STATUS:=${2:-}}"
: "${PATCH_COMMIT:=${3:-}}"
: "${PATCH_TITLE:=${4:-}}"

: "${PATCH_INDEX:?must be set directly or via \$1}"
: "${PATCH_STATUS:?must be set directly or via \$2}"
: "${PATCH_COMMIT:?must be set directly or via \$3}"
: "${PATCH_TITLE:?must be set directly or via \$4}"

: "${REMOTE_NAME:=${3:-$(git remote 2> /dev/null)}}"
: "${REMOTE_URL:=${4:-$(git remote get-url "${REMOTE_NAME}" 2> /dev/null)}}"

log "pwd: ${PWD}"
log "index: ${PATCH_INDEX}"
log "status: ${PATCH_STATUS}"
log "commit: ${PATCH_COMMIT}"
log "title: ${PATCH_TITLE}"

SLUG=$(printf "%s" "${PATCH_TITLE}" | tr -C '[:alnum:]' '_')

log "slug: ${SLUG}"

github_handler() {
	# TODO add head:<branch_name> to search
	# shellcheck disable=SC2016
	gh pr list \
		--search "head:ps/rr/${SLUG}" \
		--limit 1 \
		--json state,comments,reviews \
		--template \
		'{{range .}}{{printf "%.1s" .state}} {{len .comments}} {{range .reviews}}{{if eq .state "APPROVED"}}${{end}}{{end}}{{end}}' \
		;
}

case "${REMOTE_URL}" in
	# "*dev.azure.com*") azure_devops_handler;;
	"*github.com*") github_handler;;
	"*") log "unsupported remote: ${REMOTE_URL}"; exit 1;;
esac
