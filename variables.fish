#!/usr/bin/env fish

# Source the config
test -f ~/.config/fish/config.fish; and source ~/.config/fish/config.fish

# fzf
set -U FZF_LEGACY_KEYBINDINGS 0
set -U FZF_COMPLETE 1
set -U FZF_REVERSE_ISEARCH_OPTS '--preview-window=up:10 --preview="echo {}" --height 100%'

# golang
set -U GOROOT $HOME/.go
set -U GOPATH $HOME/go

# homebrew
# eval (env SHELL=/usr/bin/fish /home/linuxbrew/.linuxbrew/bin/brew shellenv)
set -U HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew";
set -U HOMEBREW_CELLAR "/home/linuxbrew/.linuxbrew/Cellar";
set -U HOMEBREW_REPOSITORY "/home/linuxbrew/.linuxbrew/Homebrew";
set -q MANPATH; or set MANPATH ''; set -U MANPATH "/home/linuxbrew/.linuxbrew/share/man" $MANPATH;
set -q INFOPATH; or set INFOPATH ''; set -U INFOPATH "/home/linuxbrew/.linuxbrew/share/info" $INFOPATH;

### Add user paths to fish if they're not set already
for user_path in (string split ':' $argv[1])
  if not contains $user_path $fish_user_paths && string match -q "/home/*" $user_path
    echo "adding $user_path to fish user paths..."
    set -U fish_user_paths $user_path $fish_user_paths
  end
end

# Remove the global versions, as they shadows the universal ones
set -eg fish_user_paths
set -eg HOMEBREW_PREFIX
set -eg HOMEBREW_CELLAR
set -eg HOMEBREW_REPOSITORY
set -eg MANPATH
set -eg INFOPATH
