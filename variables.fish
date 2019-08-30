#!/usr/bin/env fish

# Source the config
test -f ~/.config/fish/config.fish; and source ~/.config/fish/config.fish

### Set user paths
# get argument paths
set -l paths $argv[1]
# Home dir binaries
set -l paths $HOME/bin $HOME/.local/bin $paths
# Rust: cargo
set -l paths $HOME/.cargo/bin $paths
# Golang
set -l paths $paths $GOROOT/bin $GOPATH/bin

### Add user paths to fish if they're not set already
for user_path in $argv[1]
  if not contains $user_path $fish_user_paths
    set -U fish_user_paths $user_path $fish_user_paths
  end
end