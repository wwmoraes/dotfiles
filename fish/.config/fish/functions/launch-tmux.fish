function launch-tmux
  # tmux not found
  command -v tmux > /dev/null; or return

  # already inside a tmux session
  string match "screen*" $TERM > /dev/null; and return

  set -q TMUX_DEFAULT_SESSION; or set -lx TMUX_DEFAULT_SESSION main

  # get active sessions + "defaults"
  function tmuxSessionList
    set sessions $TMUX_DEFAULT_SESSION (tmux list-sessions -F '#S' 2>/dev/null)
    string join \n $sessions | sort | uniq | awk NF
  end

  # offer options
  if command -v fzf > /dev/null
    set session (tmuxSessionList | fzf --print-query --reverse -0 | tail -n1)
  else
    echo "tmux sessions: "(tmuxSessionList | xargs)
    echo -n "tmux session name: "
    read session
  end

  # kthxbye
  test -z $session; and exec exit

  # finally, execute tmux :D
  exec tmux new -A -s $session > /dev/null
end
