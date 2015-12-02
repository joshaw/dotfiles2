# Created:  Thu 30 Jul 2015
# Modified: Tue 01 Dec 2015
# Author:   Josh Wainwright
# Filename: ldra.bash

ldra() {
	if [ $# -eq 1 ]; then
		if [[ "$1" == *"launcher"* ]]; then
			~/ldra/launcher/ldralauncher
		else
			cmd="$1"
			builtin cd ~/LDRA_flexlm/ > /dev/null
			echo $cmd
			./${cmd}.sh
			builtin cd - > /dev/null
		fi
	elif [ $# -eq 3 ]; then
		name="$1"
		lang="$2"
		ver="$3"
		cp ~/.ldra/Testbed.ini.${lang}${ver} ~/.ldra/Testbed.ini
		~/LDRA_Toolsuite/${ver}/${lang}/${name} &
	else
		echo "Wrong number of arguments" 1>&2
	fi
}

_ldra_complete() {
	local cur=${COMP_WORDS[COMP_CWORD]}
	local cmds="tbmanager tbrun tbvision testbed start_licenseserver stop_licenseserver re-read_licensefile launcher"
	if [ "${#COMP_WORDS[@]}" -eq 2 ]; then
		COMPREPLY=( $(compgen -W "${cmds}" -- $cur) )
	elif [ "${#COMP_WORDS[@]}" -eq 3 ]; then
		COMPREPLY=( $(compgen -W "Ada C_C++" -- $cur) )
	elif [ "${#COMP_WORDS[@]}" -eq 4 ]; then
		COMPREPLY=( $(compgen -W "944 945 946 950 951" -- $cur) )
	fi
}

complete -F _ldra_complete ldra

alias vimhosts='vim /cygdrive/c/Windows/System32/drivers/etc/hosts'
