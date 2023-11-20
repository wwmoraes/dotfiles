function fkill -d "Fuzzy kill"
  set pid (ps axww -o pid,user,comm | sed 1d | fzf -m | awk '{print $1}')

  if test -n "$pid"
    echo $pid | xargs kill $argv
  end
end
