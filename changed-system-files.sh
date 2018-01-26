# Created:  Fri 26 Jan 2018
# Modified: Fri 26 Jan 2018
# Author:   Josh Wainwright
# Filename: changed-system-files.sh

command -v pacman >/dev/null 2>&1 || { echo >&2 "Missing pacman"; exit 1; }

if [ "$1" = "-h" ]; then
	cat << EOH
Find system installed files that have been modified.

Usage:
	$0 [-hqv]

-h 	Show this usage text
-q 	Just print changed files without annotation
-d 	Show diff of files
EOH

elif [ "$1" = "-q" ]; then
	pacman -Qii \
	| grep -E '^MODIFIED' \
	| awk '{print $2}'

elif [ "$1" = "-d" ]; then
	dir=$(dirname "$0")
	for f in $(sh "$0" -q); do
		echo "$f"
		diff -uN "$f" "$dir/${f:1}"
	done

else
	pacman -Qii \
	| grep -E '^Name|^MODIFIED' \
	| grep --no-group-separator -B1 '^MODIFIED' \
	| sed -e 's/^Name *: /\n/' -e 's/^MODIFIED[ \t]*/- /'
fi
