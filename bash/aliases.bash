# Created:  Tue 15 Oct 2013
# Modified: Mon 14 Dec 2015
# Author:   Josh Wainwright
# Filename: aliases.zsh
#
# Defines general aliases and functions.
#

# exists
function exists() {
	hash "$1" > /dev/null 2>&1
	return $?
}

# Aliases {{{1

# Define general aliases.
alias _='sudo'
alias b='${BROWSER}'
alias e='${VISUAL:-${EDITOR}}'
alias p='${PAGER}'
alias type='type -a'
alias x='exit'

# Editor
hash nvim 2> /dev/null && alias vim='VIMRUNTIME= nvim'
alias e='vim'
alias vimrc='vim -c ":e \$MYVIMRC"'

alias ls='ls --color=always --group-directories-first' # Lists with colour enabled
alias l='ls -1A'           # Lists in one column, hidden files.
alias ll='ls -Gghmn --time-style=+"" --group-directories-first'
alias lll='ls -Alh --sort=size . | tr -s " " | cut -d " " -f 5,9'
alias lr='ll -R'           # Lists human readable sizes, recursively.
alias la='ll -A'           # Lists human readable sizes, hidden files.
alias lm='la | "$PAGER"'   # Lists human readable sizes, hidden files through pager.
alias lx='ll -XB'          # Lists sorted by extension (GNU only).
alias lk='ll -Sr'          # Lists sorted by size, largest last.
alias lt='ll -tr'          # Lists sorted by date, most recent last.
alias lc='lt -c'           # Lists sorted by date, most recent last, shows change time.
alias lu='lt -u'           # Lists sorted by date, most recent last, shows access time.

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
# Lists the ten most used commands.
alias history-stat="cat ~/.bash/history/* | awk '{print \$1}' | sort | uniq -c | sort -n"
function histgrep() {
	cat ~/.bash/history/* | grep "$*" | sort | uniq
}

alias mv='mv -i -v'
alias rm='rm -v'
alias less='less -F'
alias sprunge='curl -F "sprunge=<-" http://sprunge.us'

# Build instructions
alias g++='g++ -Wall -o'
alias junit='java org.junit.runner.JUnitCore'

# Pointess command to look wierd and cool
alias useless='while [ true ]; do head -n 100 /dev/urandom; sleep .1; done | hexdump -C | grep "ca fe"'

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
function mcd {
	[[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1"
}

# newest {{{2
# show newest files
function newest () {
	# http://www.commandlinefu.com/commands/view/9015/find-the-most-recently-changed-files-recursively
	find . -type f -printf '%TY-%Tm-%Td %TT %p\n' | grep -v cache | grep -v ".git" | sort -r | less
}

# pdfgrep {{{2
# Search through multiple pdf files for string
if exists pdfgrep; then
	pdfgrep "$@"
# 	return $?
else
	function pdfgrep {
		if exists pdftotext; then
			pdftotext=$(which pdftotext)
		else
			pdftotext=/cygdrive/c/progs/Git/bin/pdftotext.exe
		fi
		find . -name '*.pdf' -exec sh -c "$pdftotext \"{}\" - | grep -i --with-filename --label=\"{}\" --color \"$1\"" \;
	}
	fi

# paclist {{{2
function paclist() {
	sudo pacman -Qei $(pacman -Qu|cut -d" " -f 1)|awk ' BEGIN {FS=":"}/^Name/{printf("\033[1;36m%s\033[1;37m", $2)}/^Description/{print $2}'
}

# svg2pdf {{{2
# Convert svg to pdf
function svg2pdf (){
	rsvg-convert -f pdf $1 >! $1:r.pdf
}

# pocket {{{2
# Send link to pocket
function pocket() {
	for ARG in "$@"; do
		echo $ARG | /usr/bin/mutt -s link add@getpocket.com
	done
}

# bakuf {{{2
function bakuf () {
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
function pwgen() {
	< /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-16};echo;
}

# locate {{{2
function locate() {
	files=~/.files
	if [[ -f $files ]]; then
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
function axelpw() {
	exists axel || return 1
	url=$1
	usr=$2
	pass=$3
	url=${url#http://}
	axel -a http://$usr:$pass@$url
}

# Zsh Bookmark movements {{{1
SH_BOOKMARKS="$HOME/.cdbookmarks"

function cdb_edit() {
	$EDITOR "$SH_BOOKMARKS"
}

function cdb() {
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
