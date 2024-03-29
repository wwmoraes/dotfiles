#!/usr/bin/env sh

set -eum
trap 'kill 0' INT HUP TERM

test -x /usr/libexec/path_helper && eval "$(/usr/libexec/path_helper -s)"

safeLaunchctl() {
  command -v launchctl > /dev/null || return

  launchctl "$@"
}

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
      \'*\') safeLaunchctl setenv "${name}" "$(printf "%s" "${value}" | sed -E "s/^'(.*)'$/\1/")";;
      *) safeLaunchctl setenv "${name}" "${value}";;
    esac

  done <"$1"
}

# remove first
while IFS= read -r VARIABLE; do
  # skip empty lines
  test -z "${VARIABLE}" && continue

  # skip comment lines
  test "$(expr "${VARIABLE}" : '#')" -gt 0 && continue

  safeLaunchctl unsetenv "${VARIABLE}"
  unset -v "${VARIABLE}"
done < "${HOME}/.config/environment.rm.conf"

for FILE in "${HOME}/.config/environment.d/"*.conf; do
  processDotenvFile "${FILE}"
done
