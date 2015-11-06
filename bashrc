# Created:  Mon 21 Sep 2015
# Modified: Fri 06 Nov 2015
# Author:   Josh Wainwright
# Filename: bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PATH=$PATH:~/Bin:~/Tools
export EDITOR=vim
export PAGER=less

## Aliases
source ~/.bash/aliases.bash
source ~/.bash/git.bash
source ~/.bash/ldra.bash
alias ls='ls --color=auto'
alias ll='ls -Gghmn --time-style=+"" --group-directories-first'
alias la='ll -A'

## Options
shopt -s autocd
shopt -s cdspell
shopt -s dirspell
shopt -s dotglob
shopt -s extglob
shopt -s globstar
shopt -s histappend
shopt -s nocaseglob

## Prompt
set_prompt() {
	lastcmd=$?
	P_RED='\[\e[0;31m\]'
	P_CYAN='\[\e[0;36m\]'
	P_GREEN='\[\e[0;32m\]'
	P_GREY='\[\e[0;33m\]'
	P_NC='\[\e[0m\]'

	PS1="\n${P_CYAN}\w  ${P_GREY}\j\n"
	if [ $lastcmd -eq 0 ]; then
		PS1+=${P_GREEN}
	else
		PS1+=${P_RED}
	fi
	str=$(printf "%${SHLVL}s")
	PS1+="${str// />}"
	PS1+="${P_NC} "
}
PROMPT_COMMAND='set_prompt'

## History
export HISTCONTROL=ignorespace:ignoredups:erasedups
export HISTFILE=~/.bash/history/history_$(date "+%m%Y")
export HISTFILESIZE=50000

bind 'set colored-stats on'
bind 'set page-completions off'
source ~/.bash/colours.bash

source ~/.bash/completion.bash

export LANG=en_GB.UTF-8

declare -a JUMPLIST=($PWD)
JUMP_POS=0
function jumplist-add {
	JUMP_POS=$((JUMP_POS+1))
	JUMPLIST=(${JUMPLIST[@]:0:$JUMP_POS})
	JUMPLIST+=(${1:-$PWD})
}

function jumplist-echo {
	echo "Jumplist: "
	n=0
	for i in "${JUMPLIST[@]}"; do
		printf "\t%s: %s\n" "$n" "$i"
		n=$((n+1))
	done
	echo "Jump Pos: $JUMP_POS"
	echo "Jump Cur: ${JUMPLIST[$JUMP_POS]}"
}

function jumplist-backward {
	printf "%b" "\033[2A\033[K"
	if [ $JUMP_POS -gt 0 ]; then
		JUMP_POS=$((JUMP_POS-1))
		builtin cd ${JUMPLIST[$JUMP_POS]}
	fi
	printf "%b" "${PWD/$HOME/\~}"
}

function jumplist-forward {
	printf "%b" "\033[2A\033[K"
	if [ $JUMP_POS -lt $((${#JUMPLIST[@]}-1)) ]; then
		JUMP_POS=$((JUMP_POS+1))
		builtin cd ${JUMPLIST[$JUMP_POS]}
	fi
	printf "%b" "${PWD/$HOME/\~}"
}

function cd {
	builtin cd "$@" > /dev/null && ll
	jumplist-add $PWD
}

bind -x '"\C-O":jumplist-backward'
bind -x '"\C-K":jumplist-forward'
bind 'Space: magic-space'
bind '"\e[1;5C": forward-word'
bind '"\e[1;5D": backward-word'
bind '"\e[5C": forward-word'
bind '"\e[5D": backward-word'
bind '"\e\e[C": forward-word'
bind '"\e\e[D": backward-word'

bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

bind -x '"\C-e":ef'
