HOST=$(hostname -s)

set -o allexport
test -f "$HOME/.env" && source "$HOME/.env"
test -f "$HOME/.env_secrets" && source "$HOME/.env_secrets"
test "$HOST" == "arch-linux" -a -f "$HOME/.env_personal" && source "$HOME/.env_personal"
test "$HOST" == "arch-linux" -a -f "$HOME/.env_personal_secrets" && source "$HOME/.env_personal_secrets"

test "$HOST" == "Williams-MacBook-Pro" -a -f "$HOME/.env_work" && source "$HOME/.env_work"
test "$HOST" == "Williams-MacBook-Pro" -a -f "$HOME/.env_work_secrets" && source "$HOME/.env_work_secrets"
test -f "$HOME/.env-$HOST" && source "$HOME/.env-$HOST"
set +o allexport
