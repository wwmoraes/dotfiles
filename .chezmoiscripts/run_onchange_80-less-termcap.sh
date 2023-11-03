#!/usr/bin/env sh

set -eum
trap 'kill 0' INT HUP TERM

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

printf "\e[1;33mless termcap/terminfo setup\e[0m\n"

printf "\e[1;34mgenerating terminal-dependant text lesskey config\e[0m\n"
cat > "${HOME}/.lesskey" << EOF
#env
LESS = -isRM +Gg
LESS_TERMCAP_md = $(tput bold; tput setaf 4)
LESS_TERMCAP_us = $(tput smul; tput bold; tput setaf 6)
LESS_TERMCAP_ue = $(tput rmul; tput sgr0)
LESS_TERMCAP_mb = $(tput bold; tput setaf 2)
LESS_TERMCAP_so = $(tput bold; tput setaf 3; tput setab 4)
LESS_TERMCAP_se = $(tput rmso; tput sgr0)
LESS_TERMCAP_mr = $(tput rev)
LESS_TERMCAP_mh = $(tput dim)
LESS_TERMCAP_ZN = $(tput ssubm)
LESS_TERMCAP_ZV = $(tput rsubm)
LESS_TERMCAP_ZO = $(tput ssupm)
LESS_TERMCAP_ZW = $(tput rsupm)
LESS_TERMCAP_ZH = $(tput sitm)
LESS_TERMCAP_ZR = $(tput ritm)
LESS_TERMCAP_me = $(tput sgr0)
GROFF_NO_SGR = 1
EOF
