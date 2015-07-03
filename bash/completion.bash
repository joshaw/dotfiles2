# Created:  Fri 26 Jun 2015
# Modified: Fri 03 Jul 2015
# Author:   Josh Wainwright
# Filename: completion.bash

shopt -s extglob progcomp
complete -A alias unalias
complete -A binding bind
complete -A builtin builtin
complete -A command -A alias -A builtin -A function sudo
complete -A command command type which
complete -A command man
complete -A directory cd rmdir pushd
complete -A file -X '!*.md' md.py
complete -A file -X '!*.gnu' gnuplot gnuplot.exe
complete -A helptopic help
complete -A job -P '"%' -S '"' fg jobs disown
complete -A setopt set
complete -A shopt shopt
complete -A stopped -P '"%' -S '"' bg
complete -A variable readonly unset
complete -C "sed -e 's/^\(\S*\)\s.*$/\1/' .cdbookmarks" cdb
complete -F _make_complete -A file make
complete -W "h v l d u x i r s a R" -P "-" amr

export CDPATH=.:~:$HOME/Documents/Details
bind 'TAB:menu-complete'
bind "set show-all-if-ambiguous on"
bind 'set completion-ignore-case on'
bind 'set completion-map-case on'
bind 'set menu-complete-display-prefix on'
bind 'set show-all-if-unmodified on'

_make_complete() {
	local list=$(grep -E "^[a-zA-Z][a-zA-Z0-9]*:" makefile | sed 's/:.*//')
	local cur=${COMP_WORDS[COMP_CWORD]}
	COMPREPLY=( $(compgen -W "$list" -- $cur) )
}
