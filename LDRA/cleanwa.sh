#!/bin/bash
set -e

source $(dirname $BASH_SOURCE)/settings.sh

dryrun=true

if [[ "x$1" == "x" ]]; then
	dryrun=false
fi

echo $dryrun
for VERSION in $VERSIONS; do
	echo $VERSION

	for LANGUAGE in $LANGUAGES; do
		echo $LANGUAGE

		WORKINGDIR="$WORKAREA_DIR/$LANGUAGE/$VERSION/"
		cd $WORKINGDIR
		filelist=$(
			find -maxdepth 1 -type f
			find -maxdepth 1 -type d -not -name "." \
				-and -not -name "Examples" )
		for file in $filelist; do
			du -sh $file | sed 's/^/\t/'
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
