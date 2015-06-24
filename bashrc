#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PATH=$PATH:~/Bin:~/Tools
export EDITOR=vim
export PAGER=less

## Aliases
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ll -a'
source ~/.zsh/aliases.zsh
source ~/.zsh/git.zsh

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
	P_NC='\[\e[0m\]'

	PS1="\n${P_CYAN}\w\n"
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
export HISTFILE=~/.bash/history
export HISTFILESIZE=3000

## Complete
export CDPATH=.:~:$HOME/Documents/Details
bind 'TAB:menu-complete'
bind "set show-all-if-ambiguous on"
bind 'set completion-ignore-case on'
bind 'set completion-map-case on'
bind 'set menu-complete-display-prefix on'
bind 'set show-all-if-unmodified on'
bind 'set colored-stats on'
bind 'set visible-stats on'
source ~/.bash/dircolours

complete -A directory cd
complete -C "sed -e 's/^\(\S*\)\s.*$/\1/' .cdbookmarks" cdb
complete -A file -X '!*.md' md.py

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
	if [ $JUMP_POS -gt 0 ]; then
		JUMP_POS=$((JUMP_POS-1))
		builtin cd ${JUMPLIST[$JUMP_POS]}
		echo $PWD
	fi
}

function jumplist-forward {
	if [ $JUMP_POS -lt $((${#JUMPLIST[@]}-1)) ]; then
		JUMP_POS=$((JUMP_POS+1))
		builtin cd ${JUMPLIST[$JUMP_POS]}
	fi
}

function cd {
	builtin cd "$@" > /dev/null
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
