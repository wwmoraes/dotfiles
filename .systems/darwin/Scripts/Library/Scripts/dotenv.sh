#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

: "${HOST:=$(hostname -s)}"

test -x /usr/libexec/path_helper && eval "$(/usr/libexec/path_helper -s)"

processDotenvFile() {
  # skip if file does not exist
  test ! -e "$1" && return

  # skip if file is not readable
  test ! -r "$1" && return

  echo "processing $1..."

  while read -r line; do
    # skip empty lines
    test -z "${line}" && continue

    # skip comment lines
    test "$(expr "${line}" : '#')" -gt 0 && continue

    name="${line%%=*}"
    # expand tilde with the home path
    value=$(echo "${line#*=}" | sed "s|~|${HOME}|g")

    case "${value}" in
      \'*\') launchctl setenv "${name}" "$(printf "%s" "${value}" | sed -E "s/^'(.*)'$/\1/")";;
      *) launchctl setenv "${name}" "${value}";;
    esac

  done <"$1"
}

# remove first
for FILE in "${HOME}/.env_remove"*; do
  while IFS= read -r VARIABLE; do
    # skip empty lines
    test -z "${VARIABLE}" && continue

    # skip comment lines
    test "$(expr "${VARIABLE}" : '#')" -gt 0 && continue

    launchctl unsetenv "${VARIABLE}"
    unset -v "${VARIABLE}"
  done < "${FILE}"
done

processDotenvFile "${HOME}/.env"
processDotenvFile "${HOME}/.env_secrets"
while IFS= read -r TAG; do
  processDotenvFile "${HOME}/.env_${TAG}"
  processDotenvFile "${HOME}/.env_${TAG}_secrets"
done < "${HOME}/.tagsrc"
processDotenvFile "${HOME}/.env-${HOST}"

exit 0
