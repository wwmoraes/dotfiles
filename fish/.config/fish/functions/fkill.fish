function fkill -d "Fuzzy kill"
  set pid (ps -o pid,user,command | sed 1d | fzf -m | awk '{print $1}')

  if test -n "$pid"
    echo $pid | xargs kill $argv
  end
end
