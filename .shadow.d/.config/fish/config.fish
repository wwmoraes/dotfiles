test -f /etc/fish/setEnvironment.fish
and source /etc/fish/setEnvironment.fish

test -f /etc/fish/config.fish
and source /etc/fish/config.fish

# configure TTY tab stops
command -q tabs; and tabs -2

# not a tty session
tty -s; or return
test -t 0; or return

# non-login session
status --is-login; or return

# non-interactive session
status --is-interactive; or return

command -q direnv
and test -e .envrc
and direnv reload

# Apple Terminal.app
string match -q "Apple_Terminal" $TERM_PROGRAM; and return

# inside a tmux session
string match -q "screen*" $TERM; and return

# inside a zellij session
set -Sq ZELLIJ; and return

echo checking tmux
if test -n "$USE_TMUX"
	# tmux not found
	command -v tmux > /dev/null; or return

	# get active sessions + "defaults"
	set -l activeTmuxSessions (tmux list-sessions -F '#S' 2>/dev/null)
	set -l tmuxSessions (cat "$HOME/.tmux.sessions.conf" 2>/dev/null)
	set -l smugSessions (ls -1 $HOME/.config/smug/*.yml 2>/dev/null | ifne xargs basename -s .yml)
	set -l sessions (string join \n $activeTmuxSessions $tmuxSessions $smugSessions | sort -u | awk NF)

	# offer options
	if command -v fzf > /dev/null
	  set session (string join \n $sessions | fzf --print-query --reverse -0 | tail -n1)
	else
	  echo "tmux sessions: "(echo $sessions | xargs)
	  echo -n "tmux session name: "
	  read session
	end

	# finally, execute tmux :D
	test -n "$session"; or return

	# create session using smug if it matches a template
	command -v smug > /dev/null
	and echo $activeTmuxSessions | not grep -qFx $session
	and test -f "$HOME/.config/smug/$session.yml"
	and smug "$session" -a --detach

	# join or create plain session
	exec tmux -u new -A -s "$session" > /dev/null
else
	# zellij not found
	command -v zellij > /dev/null; or return
	
	# remove dead session as zellij fails to ressurrect it
	zellij list-sessions --no-formatting | rg "^main\b"
	or zellij delete-session main

	exec zellij attach -c main
end
