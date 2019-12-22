# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

CHECKMARK=$(printf "\xE2\x9C\x94")
CROSSMARK=$(printf "\xE2\x9C\x96")
RIGHTWARDS_ARROW=$(printf "\xE2\x9E\xBE")

parse_git_branch() {
    if [ ! $(git status -s 2> /dev/null | wc -l) -eq 0 ]; then
        HASCHANGES="*"
    fi

    git branch 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/(\1${HASCHANGES})/"
}

parse_last_retcode() {
    if [ "$1" = "colored" ]; then
        [[ $? -eq 0 ]] && printf "\e[32m${CHECKMARK}\e[39m" || printf "\e[31m${CROSSMARK}\e[39m"
    else
        [[ $? -eq 0 ]] && printf "${CHECKMARK}" || printf "${CROSSMARK}"
    fi
}

if [ "$color_prompt" = yes ]; then
	PS1=$'\[$(parse_last_retcode colored)\] ${debian_chroot:+($debian_chroot)}\[\e[1;34m\]\W\[\e[33m\]$(parse_git_branch)\[\e[m\] \[\e[1;39m\]\$\[\e[m\] ${RIGHTWARDS_ARROW} '
else
	PS1=$'$(parse_last_retcode) ${debian_chroot:+($debian_chroot)}\W$(parse_git_branch) \$ ${RIGHTWARDS_ARROW} '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\W $\a\]$PS1"
    ;;
*)
    ;;
esac

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

HOST=$(hostname -s)
set -o allexport
[[ -f "$HOME/.env" ]] && source "$HOME/.env"
[[ -f "$HOME/.env_secrets" ]] && source "$HOME/.env_secrets"
[[ "$HOST" == "arch-linux" ]] && {
  [[ -f "$HOME/.env_personal" ]] && source "$HOME/.env_personal"
  [[ -f "$HOME/.env_personal_secrets" ]] && source "$HOME/.env_personal_secrets"
}
[[ "$HOST" == "Williams-MacBook-Pro" ]] && {
  [[ -f "$HOME/.env_work" ]] && source "$HOME/.env_work"
  [[ -f "$HOME/.env_work_secrets" ]] && source "$HOME/.env_work_secrets"
}
[[ -f "$HOME/.env-$HOST" ]] && source "$HOME/.env-$HOST"
set +o allexport

# fzf & bashfu sorcery
#   lists tmux sessions to attach to
#   allows creating sessions by using the fzf query
#   falls back to main session if something goes wrong (e.g. no fzf installed)

launchTmux() {
  # not a tty session
  tty -s || return
  [ -t 0 ] || return

  # non-interactive session
  [[ $- == *i* ]] || return

  # returns if already on a tmux session
  [[ "$TERM" =~ "screen" ]] && return
  [[ -z "$TMUX" ]] || return

  # returns if there's no tmux bin
  command -v tmux > /dev/null
  [ ! $? -eq 0 ] && return


  tmuxSessionList() {
    sessions=(${TMUX_DEFAULT_SESSION:-main} $(tmux list-sessions -F '#S' 2>/dev/null))
    printf '%s\n' "${sessions[@]}" | sort | uniq | awk NF
  }

  # check if fzf exists only once
  command -v fzf > /dev/null
  if [ $? -eq 0 ]; then
    session=$(tmuxSessionList | \
      fzf --print-query --reverse -0 | \
      tail -n1)
  else
    echo "tmux sessions: $(tmuxSessionList | xargs)"
    echo -n "tmux session name: "
    read session
  fi

    test -z ${session} && exit

    exec tmux -u new -A -s ${session} > /dev/null
}

launchTmux
