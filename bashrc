# Created:  Mon 21 Sep 2015
# Modified: Mon 25 Sep 2017
# Author:   Josh Wainwright
# Filename: bashrc

# If not running interactively, don't do anything
# [[ $- != *i* ]] && return

export TMP=/tmp
export PATH=~/Bin:~/Tools/bin:$PATH:"/usr/sbin":"/cygdrive/c/Program Files/Mozilla Firefox"
export EDITOR=vis
export PAGER=less
export BROWSER=firefox
export MEDIA=mpv
export WIKIDIR=~/Documents/Details

export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig"

## Aliases
. ~/.bash/aliases.bash
. ~/.bash/git.bash
. ~/.bash/ldra.bash

## Options
shopt -s autocd
shopt -s cdspell
shopt -s cdable_vars
shopt -s dirspell
shopt -s dotglob
shopt -s extglob
shopt -s globstar
shopt -s histappend
shopt -s cmdhist
shopt -s nocaseglob
shopt -s checkwinsize
set -o noclobber

## Prompt
set_prompt() {
	lastcmd=$?
	P_RED='\[\e[0;31m\]'
	P_CYAN='\[\e[0;36m\]'
	P_GREEN='\[\e[0;32m\]'
	P_GREY='\[\e[0;33m\]'
	P_NC='\[\e[0m\]'
# 	PROMPT_DIRTRIM=2

	PS1="\n${P_CYAN}\w  ${P_GREY}\j\n"
	if [ $lastcmd -eq 0 ]; then
		PS1+=${P_GREEN}
		history -a
	else
		PS1+=${P_RED}
	fi
	printf -v str "%${SHLVL}s"
	PS1+="${str// />}"
	PS1+="${P_NC} "
	pwd=${PWD/$HOME/\~}
	printf "\x1b]2;$pwd\x07"
}
PROMPT_COMMAND='set_prompt'

## History
HISTCONTROL=ignorespace:ignoredups:erasedups
# HISTFILE=~/.bash/history/history_$(date "+%Y%m")
HISTFILE=~/.bash/history/history
# HISTSIZE=500000
# HISTFILESIZE=500000
HISTSIZE=-1
HISTFILESIZE=-1
HISTIGNORE="&:[ ]*:exit:ls:ll:bg:fg*:history:clear:vim"
HISTTIMEFORMAT='%F %T'

bind 'set colored-stats on'
source ~/.bash/colours.bash

source ~/.bash/completion.bash

export LANG=en_GB.UTF-8

function cd {
	builtin cd "$@" > /dev/null && ll
}

bind 'Space: magic-space'
bind '"\e[1;5C": forward-word'
bind '"\e[1;5D": backward-word'
bind '"\e[5C": forward-word'
bind '"\e[5D": backward-word'
bind '"\e\e[C": forward-word'
bind '"\e\e[D": backward-word'

bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

stty werase undef
bind '"\C-w": backward-kill-word'
