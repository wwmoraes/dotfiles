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

processDotenvFile "${HOME}/.env"
processDotenvFile "${HOME}/.env_secrets"
if [ "${HOST}" = "M1Cabuk" ]; then
  processDotenvFile "${HOME}/.env_personal"
  processDotenvFile "${HOME}/.env_personal_secrets"
fi
if [ "${HOST}" = "C02DQ36NMD6P" ]; then
  processDotenvFile "${HOME}/.env_work"
  processDotenvFile "${HOME}/.env_work_secrets"
fi
processDotenvFile "${HOME}/.env-${HOST}"

exit 0
