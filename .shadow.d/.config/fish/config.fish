test -f /etc/fish/setEnvironment.fish
and source /etc/fish/setEnvironment.fish

test -f /etc/fish/config.fish
and source /etc/fish/config.fish

# configure TTY tab stops
command -q tabs; and tabs -2

# skip non-tty sessions
tty -s; or return
test -t 0; or return

command -q direnv
and test -e .envrc
and direnv reload

# skip non-login sessions
status --is-login; or return

# skip non-interactive sessions
status --is-interactive; or return

# skip if in Apple Terminal.app
string match -q "Apple_Terminal" $TERM_PROGRAM; and return

# skip if inside a tmux/GNU screen session
string match -q "screen*" $TERM; and return

# skip if inside a zellij session
set -Sq ZELLIJ; and return

# zellij not found
command -v zellij > /dev/null; or return

# remove dead session as zellij fails to ressurrect it
zellij list-sessions --no-formatting | rg "^main\b"
or zellij delete-session main

exec zellij attach -c main
