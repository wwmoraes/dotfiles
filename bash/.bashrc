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

parse_git_branch() {
    if [ ! $(git status -s 2> /dev/null | wc -l) -eq 0 ]; then
        HASCHANGES="*"
    fi

    git branch 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/(\1${HASCHANGES})/"
}

parse_last_retcode() {
    if [ "$1" = "colored" ]; then
        [[ $? -eq 0 ]] && printf "\e[32m\u2714\e[39m" || printf "\e[31m\u2716\e[39m"
    else
        [[ $? -eq 0 ]] && printf "\u2714" || printf "\u2716"
    fi
}

if [ "$color_prompt" = yes ]; then
	PS1=$'\[$(parse_last_retcode colored)\] ${debian_chroot:+($debian_chroot)}\[\e[1;34m\]\W\[\e[33m\]$(parse_git_branch)\[\e[m\] \[\e[1;39m\]\$\[\e[m\] \u27be '
else
	PS1=$'$(parse_last_retcode) ${debian_chroot:+($debian_chroot)}\W$(parse_git_branch) \$ \u27be '
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


export PATH=$HOME/bin:$HOME/.local/bin:$HOME/go/bin:$HOME/.go/bin:$HOME/.cargo/bin:$HOME/.krew/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$HOME/.nvm/versions/node/v13.0.1/bin:$HOME/.fzf/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/local/texlive/2018/bin/x86_64-linux

export TERM=xterm-256color
export EDITOR=vim
export VISUAL=vim
export SHELL=/usr/bin/fish
export LANG=en_US.UTF-8
export FZF_LEGACY_KEYBINDINGS=0
export FZF_COMPLETE=1
export FZF_REVERSE_ISEARCH_OPTS='--preview-window=up:10 --preview="echo {}" --height 100%'
export TMUX_PLUGIN_MANAGER_PATH=~/.config/tmux/plugins/
export NPM_TOKEN=4e07e0c4-eb1a-4723-a42e-30ad0350469b

# fzf & bashfu sorcery
#   lists tmux sessions to attach to
#   allows creating sessions by using the fzf query
#   falls back to main session if something goes wrong (e.g. no fzf installed)
launchTmux() {
  tmuxSessionList() {
    tmux list-sessions -F '#S' 2>/dev/null | cat <(echo $DEFAULT_TMUX) - | uniq | awk NF
  }

  # returns if already on a tmux session
  [ ! -z "$TMUX" ] && return

  # returns if there's no tmux bin
  command -v tmux > /dev/null
  [ ! $? -eq 0 ] && return

  DEFAULT_TMUX=main

  command -v fzf > /dev/null
  if [ $? -eq 0 ]; then
    session=$(tmuxSessionList | \
    fzf --print-query --reverse -0 | \
    tail -n1)
  else
    echo "tmux sessions: $(tmuxSessionList | xargs)"
    echo -n "tmux session name (default: $DEFAULT_TMUX): "
    read session
  fi

  exec tmux new -A -s ${session:-$DEFAULT_TMUX} && \
  exit
}

launchTmux
