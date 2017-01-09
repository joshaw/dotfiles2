# Created:  Tue 15 Oct 2013
# Modified: Mon 21 Nov 2016
# Author:   Josh Wainwright
# Filename: aliases.zsh
#
# Defines general aliases and functions.
#

# exists
exists() {
	hash "$1" > /dev/null 2>&1
	return $?
}

# Aliases {{{1

# Define general aliases.
alias type='type -a'

# Editor
alias vimrc='vim -c ":e \$MYVIMRC"'
alias vimbuild='make distclean && ./configure --with-features=huge --disable-acl --disable-workshop --disable-netbeans --disable-hangulinput --enable-pythoninterp --enable-python3interp --enable-luainterp --disable-darwin --disable-smack --disable-selinux --disable-xsmp --disable-mzschemeinterp --disable-netbeans --disable-hangulinput --disable-xim --disable-gui --disable-gtktest && make && make install && vim -c"TestFeatures"'

alias ls='ls --color=always --group-directories-first' # Lists with colour enabled
alias l='ls -1A'           # Lists in one column, hidden files.
alias ll='ls -NGghmn --time-style=+"" --group-directories-first'
alias lll='ls -NAlh --sort=size . | tr -s " " | cut -d " " -f 5,9-'
alias la='ll -A'           # Lists human readable sizes, hidden files.

if ! exists clear; then
	alias clear='printf "\033c"'
fi

alias chromeos="sudo cgpt add -i 6 -P 0 -S 0 /dev/mmcblk0"

# File Download
if exists curl; then
	alias get='curl --continue-at - --location --progress-bar --remote-name --remote-time'
elif exists wget; then
	alias get='wget --continue --progress=bar --timestamping'
elif exists axel; then
	alias get='axel -a'
elif exists aria2c; then
	alias get='aria2c -j 8'
fi

# Resource Usage
alias df='df -kh'
alias du='du -kh'

if exists htop; then
	alias top=htop
fi

# Apt-get update all
alias apt-all='sudo -- sh -c "apt-get update && apt-get upgrade && apt-get dist-upgrade && apt-get autoremove && apt-get autoclean && apt-get clean"'

# Miscellaneous
alias suspend='sudo systemctl suspend'

alias mv='mv -i -v'
alias rm='rm -v'
alias less='less -F'
alias sprunge='curl -F "sprunge=<-" http://sprunge.us'

# Build instructions
alias g++='g++ -Wall -o'
alias junit='java org.junit.runner.JUnitCore'

# Pointess command to look wierd and cool
alias useless='while true; do head -n 100 /dev/urandom; sleep .1; done | hexdump -C | grep "ca fe"'

# Media -------------------------------
alias mpv='mpv --save-position-on-quit'
alias mpa='mpv --no-video'
alias mplayer='mplayer -msgcolor -nolirc -nojoystick'
alias mute-beep='xset -b && sudo rmmod pcspkr'
alias play-dvd='mplayer -nocache -dvd-device /dev/sr0 -mouse-movements dvdnav://'
alias vimp='vim ~/Documents/Details/pass.gpg'

# Functions {{{1

# mcd {{{2
# Makes a directory and changes to it.
mcd() {
	[[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1"
}

# newest {{{2
# show newest files
newest () {
	# http://www.commandlinefu.com/commands/view/9015/find-the-most-recently-changed-files-recursively
	find . -type f -printf '%TY-%Tm-%Td %TT %p\n' | grep -v cache | grep -v ".git" | sort -r | less -S
}

# pdfgrep {{{2
# Search through multiple pdf files for string
alias pdftotext='/cygdrive/c/progs/Git/bin/pdftotext.exe'
if ! exists pdfgrep; then
	pdfgrep() {
		if exists pdftotext; then
			pdftotext=$(which pdftotext)
		else
			pdftotext=/cygdrive/c/progs/Git/mingw64/bin/pdftotext.exe
		fi
		find . -name '*.pdf' -exec sh -c "$pdftotext \"{}\" - | grep -i --with-filename --label=\"{}\" --color \"$1\"" \;
	}
fi

# paclist {{{2
paclist() {
	sudo pacman -Qei $(pacman -Qu|cut -d" " -f 1)|awk ' BEGIN {FS=":"}/^Name/{printf("\033[1;36m%s\033[1;37m", $2)}/^Description/{print $2}'
}

# svg2pdf {{{2
# Convert svg to pdf
svg2pdf() {
	rsvg-convert -f pdf $1 >! $1:r.pdf
}

# bakuf {{{2
bakuf () {
    oldname=$1;
    if [ "$oldname" != "" ]; then
        datepart=$(date +%Y%m%d);
    	firstpart=${oldname%.*}
        ext=${oldname##*.}
        newname=$firstpart.$datepart.$ext
        cp -R ${oldname} ${newname};
    fi
}

# pwgen {{{2
pwgen() {
	< /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-16};echo;
}

# locate {{{2
locate() {
	files=~/.files
	if [ -f $files ]; then
		find $files -mtime +8 -exec sh -c \
			'mdays=$((($(date +%s) - $(stat --printf="%Y" .files)) / (60*60*24) )); \
			echo "database is more than 8 days old (actual age is $mdays)"' \;
		grep "$@" $files 2> /dev/null || \
			echo "No match found."
	else
	 	command locate "$@"
	fi
}

# axelpw {{{2
axelpw() {
	exists aria2c || return 1
	url=$1
	usr=$2
	pass=$3
 	url=${url#http://}
# 	axel -a http://$usr:$pass@$url
#	curl -O -u $usr:$pass $url
	aria2c -x 16 -s 16 --file-allocation=none http://${usr}:${pass}@${url}
}

# Zsh Bookmark movements {{{1
SH_BOOKMARKS="$HOME/.cdbookmarks"

cdb_edit() {
	$EDITOR "$SH_BOOKMARKS"
}

cdb() {
	local entry
	index=0
	if [ "$1" == "list" ]; then
		sort -dfu "$SH_BOOKMARKS"
		return 0
	fi
	for entry in $(echo "$1" | tr '/' '\n'); do
		local CD
		CD=$(egrep "^$entry\\s" "$SH_BOOKMARKS" | sed "s#^$entry\\s\+##")
		if [ -z "$CD" ]; then
			echo "$0: no such bookmark: $entry"
			return 1
		else
			builtin cd "$CD"
		fi
	done
}
