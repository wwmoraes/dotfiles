function fssh -d "fuzzy connects to hosts configured on ssh"
  set -l host (grep -REh --exclude-dir=control "^Host" ~/.ssh | \
    sed 's/Host //' | \
    tr ' ' '\n' | \
    sort | \
    uniq | \
    grep -v -e "*" -e github.com -e bitbucket.com | \
    fzf -1 --header="HOST"); or return 2

    echo connecting to $host...
    ssh -tt $host
end
