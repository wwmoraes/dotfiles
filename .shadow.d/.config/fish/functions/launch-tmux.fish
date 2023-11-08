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

  # path hack
  test (uname -s) = "Darwin"; and set -xg PATH (launchctl getenv PATH)

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

  # join existing session
  echo $activeTmuxSessions | grep -qFx $session
  and exec tmux -u new -A -s "$session" > /dev/null

  # create smug session
  command -v smug > /dev/null && test -f "$HOME/.config/smug/$session.yml"
  and exec smug "$session" -a

  # create new plain session
  exec tmux -u new -A -s "$session" > /dev/null
end
