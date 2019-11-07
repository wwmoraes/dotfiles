#!/bin/bash

printf "\e[1;34mTmux extensions\e[0m\n"

printf "Checking \e[96mtpm\e[0m...\n"
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

printf "Installing tpm plugins...\n"
tmux source-file ~/.tmux.conf
~/.tmux/plugins/tpm/bin/install_plugins
