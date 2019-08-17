#!/bin/sh

# Clone on home
pushd ~ > /dev/null
git clone git@github.com:wwmoraes/dotfiles.git .dotfiles

# Install
pushd ~/.dotfiles > /dev/null
make install

# Go back to the previous directory
pushd +2 > /dev/null
dirs -c