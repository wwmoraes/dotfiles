#!/usr/bin/env bash

#  <xbar.title>Azure DevOps Pull Requests</xbar.title>
#  <xbar.version>0.0.1</xbar.version>
#  <xbar.author>William Artero</xbar.author>
#  <xbar.author.github>wwmoraes</xbar.author.github>
#  <xbar.desc>Lists and links Azure DevOps pull requests.</xbar.desc>
#  <xbar.dependencies>bash,az,awk</xbar.dependencies>
#  <xbar.abouturl>http://github.com/wwmoraes/dotfiles</xbar.abouturl>

#  <xbar.var>string(ORGANIZATION=""): Azure DevOps organization URL.</xbar.var>
#  <xbar.var>string(PROJECT=""): Name or ID of project.</xbar.var>
#  <xbar.var>string(REPOSITORIES=""): Comma-separated repository names.</xbar.var>
#  <xbar.var>string(PREFIXES=""): Comma-separated repository name prefixes.</xbar.var>
#  <xbar.var>string(AZ="az"): Azure CLI command-line custom path.</xbar.var>

set -euo pipefail

: "${ORGANIZATION:=}"
: "${PROJECT:=}"
: "${REPOSITORIES:=}"
: "${PREFIXES:=}"
: "${AZ:=az}"

RESET='\033[0m'
BOLD=$'\033[1m'
# DIM=$'\033[2m'
# UNDERLINE=$'\033[4m'
RED=$'\033[31m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
BLUE=$'\033[34;1m'
MAGENTA=$'\033[35;1m'
CYAN=$'\033[36;1m'

debug() {
  local FORMAT="[DEBUG] $1\n"
  shift
  printf "${FORMAT}" "$@" >&3
}

# multi-character join, as the standard IFS only supports a single character
join() {
  local separator="$1"
  shift
  local joined=$(printf "${separator}%s" "$@")
  echo "${joined:${#separator}}"
}

assertCommands() {
  # check if the azure CLI and devops extensions are installed
  debug "checking if azure CLI is installed..."
  if ! _=$(command -V "${AZ}" > /dev/null 2>&1); then
    echo "Please install the Azure CLI" >&2
    exit 2
  fi

  debug "checking if devops azure CLI extension is installed..."
  if ! ADO_EXT_VERSION=$(${AZ} extension list --query "[?name=='azure-devops'].version" -o tsv) || [ "${ADO_EXT_VERSION}" == "" ]; then
    #TODO install and refresh
    # open -g bitbar://refreshPlugin?name=$0
    echo "Please install the Azure CLI devops extension" >&2
    exit 2
  fi
}

assertVariables() {
  local EXIT=0

  # check required variables
  if [ -z "${ORGANIZATION}" ]; then
    echo "Please set the variable ORGANIZATION" >&2
    ((EXIT=EXIT+1))
  fi
  if [ -z "${PROJECT}" ]; then
    echo "Please set the variable PROJECT" >&2
    ((EXIT=EXIT+1))
  fi

  # check optional repositories and/or prefixes variables
  if [ -z "${REPOSITORIES}${PREFIXES}" ]; then
    echo "Please set the variable REPOSITORIES and/or PREFIXES" >&2
    ((EXIT=EXIT+1))
  fi

  # exit if there's any problems
  if [ ${EXIT} -gt 0 ]; then
    exec 3>&-
    exit 2
  fi
}

generateQueryFilter() {
  local FILTERS=()

  if [ -n "${PREFIXES:-}" ]; then
    debug "transforming prefixes into filters..."
    while read -r PREFIX; do
      FILTERS+=("starts_with(repository.name, '${PREFIX}')")
    done < <(echo "${PREFIXES}" | tr ',' '\n')
  fi

  if [ -n "${REPOSITORIES:-}" ]; then
    debug "transforming repositories into filters..."
    FILTERS+=("contains(['${REPOSITORIES//,/','}'], repository.name)")
  fi

  join " || " "${FILTERS[@]}"
}

if [ ${DEBUG:=0} -eq 1 ]; then
  exec 3>&2
else
  exec 3>/dev/null
fi

echo "↓⤸"
echo "---"

assertCommands
assertVariables

# remove trailing slash
ORGANIZATION="${ORGANIZATION%*/}"
FILTER=$(generateQueryFilter)
QUERY="[?${FILTER}].[repository.name,pullRequestId,mergeStatus,title,createdBy.displayName]"
debug "final query: ${QUERY}"

if ! PRS=$(${AZ} repos pr list \
  --org "${ORGANIZATION}" \
  -p "${PROJECT}" \
  --query "${QUERY}" \
  -o tsv | sort); then
  echo "failed to list PRs" >&2
  echo "${PRS}"
  exec 3>&-
  exit 1
fi

echo "Last update: $(date) | disabled=true | size=10"
LAST_REPOSITORY=
while IFS=$'\t' read -r REPOSITORY ID STATUS TITLE AUTHOR; do
  if [ "${LAST_REPOSITORY}" != "${REPOSITORY}" ]; then
    LAST_REPOSITORY=${REPOSITORY}
    echo "---"
    echo "${REPOSITORY} | href=${ORGANIZATION}/${PROJECT}/_git/${REPOSITORY}/pullrequests color=cadetblue size=11"
  fi
  case "${STATUS}" in
    "succeeded") STATUS="";;
    *) STATUS="${YELLOW} (${STATUS})${RESET}";;
  esac
  echo -e "${MAGENTA}${ID}${RESET}\t${TITLE} ${CYAN}[${AUTHOR}]${RESET}${STATUS} | href=${ORGANIZATION}/${PROJECT}/_git/${REPOSITORY}/pullrequest/${ID} ansi=true"
done < <(echo "${PRS}" | grep .)
echo "---"
echo "Refresh | refresh=true key=CmdOrCtrl+r"
exec 3>&-
