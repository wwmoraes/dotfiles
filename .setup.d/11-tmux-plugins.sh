#!/bin/bash

echo -e "\e[1;34mTmux extensions\e[0m"

echo -e "Checking \e[96mtpm\e[0m..."
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo -e "Installing tpm plugins..."
tmux source-file ~/.tmux.conf
~/.tmux/plugins/tpm/bin/install_plugins
