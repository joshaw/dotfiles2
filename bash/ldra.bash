# Created:  Thu 30 Jul 2015
# Modified: Mon 20 Feb 2017
# Author:   Josh Wainwright
# Filename: ldra.bash

ldra() {
	if [ $# -eq 1 ]; then
		if [[ "$1" == *"launcher"* ]]; then
			~/ldra/launcher/ldralncher
		else
			cmd="$1"
			builtin cd ~/LDRA_flexlm/ > /dev/null
			echo $cmd
			./${cmd}.sh
			builtin cd - > /dev/null
		fi
	elif [ $# -eq 2 ]; then
		name="$1"
		lang="$2"
		cp ~/.ldra/Testbed.ini.${lang} ~/.ldra/Testbed.ini
		~/LDRA_Toolsuite/${lang}/${name} &
	else
		echo "Wrong number of arguments" 1>&2
	fi
}

if [ $BASH ]; then
	_ldra_complete() {
		local cur=${COMP_WORDS[COMP_CWORD]}
		local cmds="tbmanager tbrun tbvision testbed start_licenseserver stop_licenseserver re-read_licensefile launcher"
		if [ "${#COMP_WORDS[@]}" -eq 2 ]; then
			COMPREPLY=( $(compgen -W "${cmds}" -- $cur) )
		elif [ "${#COMP_WORDS[@]}" -eq 3 ]; then
			COMPREPLY=( $(compgen -W "Ada C_C++" -- $cur) )
		fi
	}

	complete -F _ldra_complete ldra
fi

alias vimhosts='$EDITOR /cygdrive/c/Windows/System32/drivers/etc/hosts'

export TESTBED=/home/joshwainwright/.ldra/
