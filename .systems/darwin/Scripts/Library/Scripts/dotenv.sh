#! /bin/bash

eval $(/usr/libexec/path_helper -s)

processDotenvFile() {
  if [ ! -r "$1" ]; then
      return
  fi

  while read line; do
    # skip empty lines or comments
    if [ ! -n "$line" -o `expr "$line" : '#'` -gt 0 ]; then continue; fi

    IFS="=" read -r name value <<<"$line"

    launchctl setenv $name "$value"
  done <"$1"
}

[[ -f "$HOME/.env" ]] && processDotenvFile "$HOME/.env"
[[ -f "$HOME/.env_secrets" ]] && processDotenvFile "$HOME/.env_secrets"
[[ "$HOST" == "Williams-MacBook-Pro" ]] && {
  [[ -f "$HOME/.env_work" ]] && processDotenvFile "$HOME/.env_work"
  [[ -f "$HOME/.env_work_secrets" ]] && processDotenvFile "$HOME/.env_work_secrets"
}
[[ -f "$HOME/.env-$HOST" ]] && processDotenvFile "$HOME/.env-$HOST"

exit 0
