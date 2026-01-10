command -q fzf; or echo "fzf is not installed" && return

set pid (ps axww -o pid,user,comm | sed 1d | fzf -m | awk '{print $1}')

if test -n "$pid"
    echo $pid | xargs kill $argv
end
