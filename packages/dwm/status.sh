#!/bin/bash
# Status script for dwm
# colours: 01:normal 02:white 03:red 04:green 05:yellow 06:blue 07:cyan 08:magenta 09:grey

# mem(){
# 	mem="$(awk '/^-/ {print $3}' <(free -m))"
# 	echo -e "Mem\x04$mem\x01"
# }

#    # CPU line courtesy Procyon:https://bbs.archlinux.org/viewtopic.php?pid=874333#p874333
# cpu(){
# 	read cpu a b c previdle rest < /proc/stat
# 	prevtotal=$((a+b+c+previdle))
# 	sleep 0.5
# 	read cpu a b c idle rest < /proc/stat
# 	total=$((a+b+c+idle))
# 	cpu="$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))"
# 	echo -e "CPU\x05$cpu%\x01"
# 	}

arg=$1
minute=$(date +%M)
bigSec=$(date +%s)

function removeUnprintable(){
	clean=$(echo "$1" | tr 'āáǎàēéěèīíǐìú' 'aaaaeeeeiiiu' )
	echo $clean
}

function testTimeNow(){
	duration=$1
	if [ "$arg" = "now" ]; then
		return 0
	else
		return 1
	fi

	if [ $(($bigSec%$duration)) -eq 0 ]; then
		return 0
	else
		return 1
	fi
}

function open(){
# if [[ $minute%5 -eq 0 ]]; then
	if testTimeNow 300; then
		opn=$(lsof | wc -l)
		echo -ne " $opn" > /tmp/dwm_status_bar/open
	fi
}

function mpd(){
	stat=$(mpc status | awk 'NR==2 {print $1}')
	case "$stat" in
		"[paused]") stat_short="||" ;;
		"[playing]") stat_short=">" ;;
		*) stat_short="_" ;;
	esac
	curMessy=$(mpc current -f "[[%artist% - ]%title%]|[%file%]" | head -n 1)
	cur=$(removeUnprintable "$curMessy" )
	perc=$(mpc | awk 'NR==2 {print $4}')
	echo -ne " \x08$stat_short $perc $cur\x01" > /tmp/dwm_status_bar/mpd
}

#function rdog(){
#	read rawdog_unread updated < /tmp/rawdog_feeds
#	if [ "$rawdog_unread" -ne 0 ]; then
#		echo -ne " \x04R:\x01$rawdog_unread" > /tmp/dwm_status_bar/rdog
#	else
#		echo "" > /tmp/dwm_status_bar/rdog
#	fi
#}

function grd(){
	if testTimeNow 600; then
		unread=$(~/greaderunread.sh)
		if [ "$unread" -ne 0 ]; then
			echo -ne " \x04U:\x01$unread" > /tmp/dwm_status_bar/grd
		else
			echo "" > /tmp/dwm_status_bar/grd
		fi
	fi
}

function mail(){
if testTimeNow 120; then
		notify-send "Mail updated $((bigSec%120))"
		feed=$(nice -n 19 curl -n --silent "https://mail.google.com/mail/feed/atom")
		new=$(echo $feed | sed -n -e 's/.*<fullcount>\(.*\)<\/fullcount>.*/\1/p')
		# new=$(find ~/.mail/ -type f -wholename '*/new/*' | wc -l);
		# unread=$(find ~/.mail/ -type f -regex '.*/cur/.*2,[^S]*$' | wc -l);
		if [ "$new" -ne 0 ]; then
			echo -ne " \x04M:\x01$new" > /tmp/dwm_status_bar/mail
			details=$(echo $feed | sed -n -e 's/.*<title>\(.*\)<\/title>.*/\1/p' -e 's/.*<name>\(.*\)<\/name>.*/\t\1/p' | tail -n+2)
			#notify-send "<b>New messages availible</b>\n$details"
		else
			echo "" > /tmp/dwm_status_bar/mail
		fi
	fi
}

function pac(){
	if testTimeNow 120; then
		notify-send "Pacman has been run!!!!"
		pup="$(pacman -Qqu | wc -l)"
		if [ "$pup" -ne 0 ]; then
			echo -ne " \x04P:\x01$pup" > /tmp/dwm_status_bar/pac
		else
			echo "" > /tmp/dwm_status_bar/pac
		fi
	fi
}

function hdd(){
	disk=$(df /dev/sda7 --output=pcent | tail -n 1 | tr -d " ")
	echo -ne " \x06H:\x01$disk" > /tmp/dwm_status_bar/hdd
}

function int(){
	ipaddr=$(ifconfig wlan0 | awk '/inet / {print $2}')
	signal_tmp=$(cat /proc/net/wireless | grep wlan0 | awk '{print $3}' | tr -d ".")
	if [ $signal_tmp -le 30 ]; then
		signal="\x07$signal_tmp%\x01"
	else
		signal="$signal_tmp%"
	fi
	echo -ne " \x06I:\x01($ipaddr) \x06W:\x01$signal" > /tmp/dwm_status_bar/int
}

function dte(){
	# up=$(awk '{printf("%dd %02dh %02dm",($1/60/60/24),($1/60/60%24),($1/60%60))}' /proc/uptime)
	read seconds tmp < /proc/uptime
	seconds=${seconds%.*}
	days=$(($seconds/60/60/24))
	hours=$(($seconds/60/60%24))
	minutes=$(($seconds/60%60))
	if [[ $days -eq 0 ]]; then
		up=$hours"h "$minutes"m"
	elif [[ $days -gt 7 ]]; then
		up="\x03"$days"d\x01 "$hours"h "$minutes"m"
	else
		up=$days"d "$hours"h "$minutes"m"
	fi
#	up=$(awk '{
#		if (($1/60/60/24) -eq 0)
#			printf("%02dh %02dm",($1/60/60%24),($1/60%60));
#		else if (($1/60/60/24) -ge 3)
#			printf("\x03%dd\x01 %02dh %02dm",($1/60/60/24),($1/60/60%24),($1/60%60));
#		else
#			printf("%dd %02dh %02dm",($1/60/60/24),($1/60/60%24),($1/60%60));
#		}' /proc/uptime)
	tme=$(date "+%l:%M:%S%P")
	dte=$(date "+%e %b'%g")
	echo -ne " \x06Up:\x01$up \x08$tme\x01 $dte" > /tmp/dwm_status_bar/dte
}

#xsetroot -name "$(mpd) $(mail) $(pac) $(hdd) $(int) $(dte) "
# ------------------------------------------------------------------
## Make folder and files
# ------------------------------------------------------------------
# check if tmp folder exists and create if not
if [ ! -d "/tmp/dwm_status_bar" ];
then
	mkdir /tmp/dwm_status_bar
fi
# check if each tmp file exits and create if not
if [ ! -f "/tmp/dwm_status_bar/content" ];
then
	touch /tmp/dwm_status_bar/content
fi

echo "" > /tmp/dwm_status_bar/content

for file in  mpd open pac mail hdd int dte
do
	if [ ! -f "/tmp/dwm_status_bar/$file" ];
	then
		touch /tmp/dwm_status_bar/$file
	fi
	$file
	cat /tmp/dwm_status_bar/$file >> /tmp/dwm_status_bar/content
done

# ------------------------------------------------------------------
## Run commands
# ------------------------------------------------------------------
#mpd
#open
#mail
#pac
#hdd
#int
#dte

#echo -ne "$(mpd) $(mail) $(pac) $(hdd) $(int) $(dte) "

# ------------------------------------------------------------------
## Concatenate final file
# ------------------------------------------------------------------
# for file in mpd mail pac hdd int dte
# do
# 	cat /tmp/dwm_status_bar/$file >> /tmp/dwm_status_bar/content
# done
