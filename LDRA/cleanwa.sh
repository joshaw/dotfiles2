#!/bin/bash
# Created:  Mon 02 Feb 2015
# Modified: Mon 02 Feb 2015
# Author:   Josh Wainwright
# Filename: cleanwa.sh

set -o nounset
function echoerr() {
	>$2 echo $@
}

source $(dirname $BASH_SOURCE)/settings.sh

dryrun=true

if [[ $# -eq 1 ]]; then
	dryrun=false
fi

echo $dryrun
for LANG in lang_c lang_a lang_j; do

	LANGUAGE=${langs[$LANG]}
	echo $LANGUAGE

	for VERSION in $(eval echo  "\${$LANG[@]}"); do

		echo -e "\t$VERSION"

		WORKINGDIR="$WORKAREA_DIR/$LANGUAGE/$VERSION/"
		cd $WORKINGDIR
		filelist=$(
			find -maxdepth 1 -type f
			find -maxdepth 1 -type d -not -name "." \
				-and -not -name "Examples" )
		for file in $filelist; do
			du -sh $file | sed 's/^/\t\t/'
			if ! $dryrun; then
				rm -r "$file"
			fi
		done
		if ! $dryrun; then
			mkdir "Permdir"
			mkdir "Tbwrkfls"
		fi
	done
done
