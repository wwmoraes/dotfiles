function fconnect -d "fuzzy connect to a host"
  set -l host (find -L ~/.ssh -type f \
    -exec awk '/^Host (.*\*.*|github.com)/ {next};/^Host/ {print $2}' '{}' \; | \
    sort | \
    uniq | \
    fzf --print-query --header="HOST" --prompt="Which host you want to connect to? " | tail -n1); or return 2

    test -n "$host"; or return 2

    set options "mosh/tmux" "ssh/tmux" mosh ssh

    set -l connType (printf "%s\n" $options | fzf --header="TYPE" --prompt="What type of connection to use? ")

    test -n "$connType"; or return 2

    set extraArgs ""

    string match -qr -- "ssh/?.*" $connType
    and set tool ssh -tt

    string match -qr -- "mosh/?.*" $connType
    and set tool mosh --ssh="ssh -tt" --no-ssh-pty

    string match -q -- "*/tmux" $connType; and begin
      # echo -n "tmux session name: "
      read -P "tmux session name [default: main] > " session
      test -z "$session"; and set session main
      set extraArgs tmux -u new -A -s $session
    end

    echo connecting to $host...
    set LC_CTYPE en_US.UTF-8
    echo $tool $host -- $extraArgs
    $tool $host -- $extraArgs
end
