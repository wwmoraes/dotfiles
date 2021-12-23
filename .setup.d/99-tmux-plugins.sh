#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

printf "\e[1;34mTmux extensions\e[0m\n"

printf "Checking \e[96mtpm\e[0m...\n"
if [ ! -d "${HOME}/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
fi

printf "Installing tpm plugins...\n"
tmux source-file "${HOME}/.tmux.conf"
"${HOME}/.tmux/plugins/tpm/bin/install_plugins"
