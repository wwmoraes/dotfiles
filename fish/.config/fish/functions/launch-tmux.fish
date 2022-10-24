function launch-tmux
  # not a tty session
  tty -s; or return
  test -t 0; or return

  # non-interactive session
  status --is-interactive; or return

  # VSCode terminal
  string match -q "vscode" $TERM_PROGRAM; and return

  # already inside a tmux session
  string match -q "screen*" $TERM; and return

  # tmux not found
  command -v tmux > /dev/null; or return

  # get active sessions + "defaults"
  set -l activeTmuxSessions (tmux list-sessions -F '#S' 2>/dev/null)
  set -l tmuxSessions (cat "$HOME/.tmux.sessions.conf" 2>/dev/null)
  set -l tmuxpSessions (ls -1 "$HOME/.tmuxp" 2>/dev/null | ifne xargs basename -s .yaml)
  set -l sessions (string join \n $activeTmuxSessions $tmuxSessions $tmuxpSessions | sort -u | awk NF)

  # offer options
  if command -v fzf > /dev/null
    set session (string join \n $sessions | fzf --print-query --reverse -0 | tail -n1)
  else
    echo "tmux sessions: "(echo $sessions | xargs)
    echo -n "tmux session name: "
    read session
  end

  # finally, execute tmux :D
  test -n $session; or return

  # join existing session
  echo $activeTmuxSessions | grep -qFx $session
  and exec tmux -u new -A -s "$session" > /dev/null

  # create tmuxp session
  command -v tmuxp > /dev/null && test -f "$HOME/.tmuxp/$session.yaml"
  and exec tmuxp load -y "$session"

  # create new plain session
  exec tmux -u new -A -s "$session" > /dev/null
end
