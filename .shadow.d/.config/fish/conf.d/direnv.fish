command -q direnv; or exit

direnv hook fish | source
direnv export fish | source

test -e .envrc; and direnv reload
