#!/bin/bash
# Created:  Sun 25 Jan 2015
# Modified: Sun 25 Jan 2015
# Author:   Josh Wainwright
# Filename: gen_dicts.sh

set -o nounset
function echoerr() {
	>&2 echo $@
}

function progress(){
	# $1 = total value
	# $2 = current value
	# $3 = percent completed
	[[ -z $1 || -z $2 || -z $3 ]] && exit

	percent=$3
	completed=$(( $percent / 2 ))
	remaining=$(( 50 - $completed ))

	echo -ne "\r$1 ["
	printf "%0.s=" `seq $completed`
	echo -n ">"
	[[ $remaining != 0 ]] && printf "%0.s." `seq $remaining`
	echo -n "] $percent% ($2)  "
}

n=0
pathtofiles="/usr/share/vim/vim74/syntax/"
t=$(ls -1  $pathtofiles | wc -l)

for i in ${pathtofiles}*; do
	n=$((n+1))
	#echo -en "\r\033[K$n/$t: $i"
	progress  $t $n $(((n*100)/t))
	grep keyword $i |\
		grep -v nextgroup |\
		awk '{ $1=""; $2=""; $3=""; print}' |\
		sed -r -e 's/\s+/\n/g' |\
		sed -e '/^$/d' -e '/contained/d' |\
		sort -d |\
		uniq > ~/.vim/spell/dicts/$(basename $i .vim).dict
done
