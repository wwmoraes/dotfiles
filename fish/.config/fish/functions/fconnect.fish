function fconnect -d "fuzzy connect to a host"
  set -l host (grep -REh --exclude-dir=control "^Host" ~/.ssh | \
    sed 's/Host //' | \
    awk 'FS=" " {print $1}' | \
    sort | \
    uniq | \
    grep -v -e "*" -e github.com -e bitbucket.com | \
    fzf -1 --header="HOST" --prompt="Which host you want to connect to? "); or return 2

    set options "mosh/tmux" "ssh/tmux" mosh ssh

    set -l connType (printf "%s\n" $options | fzf --header="TYPE" --prompt="What type of connection to use? ")

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
