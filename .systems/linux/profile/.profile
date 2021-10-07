: "${HOST:=$(hostname -s)}"

processDotenvFile() {
  # skip if file does not exist
  test ! -e "$1" && return

  # skip if file is not readable
  test ! -r "$1" && return

  source "$1"
}

set -o allexport
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
set +o allexport
