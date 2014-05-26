#!/bin/bash - 
#===============================================================================
#
#          FILE: alarmclock.sh
# 
#         USAGE: ./alarmclock.sh 
# 
#   DESCRIPTION: a small alarm clock script
# 
#       OPTIONS: ---
#  REQUIREMENTS: mplayer, xtrlock (optional: fortunes)
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Robin Cerny (), robin@cerny.li
#  ORGANIZATION: 
#       CREATED: 26.05.2014 17:06
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

FILE=/home/robin/alarm_sound2.mp3
#FILE=/home/robin/jdownloader/downloads/alarm_sound.mp3

lockcmd(){
	# lock all input devices
	xinput set-prop 10 151 0
	xinput set-prop 11 151 0
	xinput set-prop 12 151 0
}

unlockcmd(){
	# unlock all input devices
	xinput set-prop 10 151 1
	xinput set-prop 11 151 1
	xinput set-prop 12 151 1
}

progressbar() {
	{ for I in $(seq 1 100) ; do
		echo $I
		sleep 0.6
		done
		echo 100; } | dialog --backtitle "Bash Alarm Clock V1" \
			--gauge "$(fortune bofh-excuses)" 10 80 0
}

alarm(){
	mplayer -really-quiet -nolirc -loop 0 $FILE &
	xtrlock

	while true ; do

		if pidof xtrlock >/dev/null
		then
			sleep 1
		else
			kill $!
			break
		fi

	done
}

#============================================================================

alarm

lockcmd
mplayer -really-quiet -nolirc $FILE &
clear
progressbar
unlockcmd
clear

alarm

exit 0
