#!/usr/bin/env fish

### Set variables
# Homebrew
set -U HOMEBREW_PREFIX $HOMEBREW_PREFIX
set -U HOMEBREW_CELLAR $HOMEBREW_CELLAR
set -U HOMEBREW_REPOSITORY $HOMEBREW_REPOSITORY
set -q MANPATH; or set MANPATH ''
set -U MANPATH $MANPATH
set -q INFOPATH; or set INFOPATH ''
set -U INFOPATH $INFOPATH
# Golang
set -U GOROOT $HOME/.go
set -U GOPATH $HOME/go

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
    set -g fish_user_paths $user_path $fish_user_paths
  end
end