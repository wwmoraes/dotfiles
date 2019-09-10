# Remove the global version, as it shadows the universal one
set -eg fish_user_paths

# fzf
set -U FZF_LEGACY_KEYBINDINGS 0
set -U FZF_COMPLETE 1
set -U FZF_REVERSE_ISEARCH_OPTS '--preview-window=up:10 --preview="echo {}" --height 100%'

# golang
set -U GOROOT $HOME/.go
set -U GOPATH $HOME/go

# homebrew
eval (env SHELL=/usr/bin/fish /home/linuxbrew/.linuxbrew/bin/brew shellenv)
