#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

#if [ -d /etc/X11/xinit/xinitrc.d ]; then
#	for f in /etc/X11/xinit/xinitrc.d/*; do
#		[ -x "$f" ] && . "$f"
#	done
#	unset f
#fi

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

setxkbmap gb
setxkbmap -option caps:escape

sh ~/.fehbg
#xset +fp /usr/share/fonts/local
#xset fp rehash
#xset -b

#conky -c ~/.scripts/dwm/conkyrc | while read -r; do xsetroot -name "$REPLY"; done &
while true; do
	~/Bin/dwmstatus
	#xsetroot -name "$(cat /tmp/dwm_status_bar/content)"
	 sleep 10s
done &
exec ~/.scripts/dwm/startdwm
#exec selectwm
#exec goomwwm
#exec i3
#exec wmii
#exec awesome
#exec openbox-session
#exec startxfce4 --with-ck-launch
#exec startxfce4
#exec enlightenment_start
