#!/bin/bash

# A little script for a TTT Server, it works for me, but that does not mean that it does for you too.
# Cheers
# - tschaerni https://github.com/tschaerni
#
# Some snippets are from Doomsider
# https://github.com/doomsider/

# --------------------------------------- Settings ----------------------------------------
# Path to steamcmd
STEAMCMD="/path/to/steamCMD"
# Path to Counterstrike:Source and appid
CSS="/path/to/css"
CSSID="232330"
# Path to Garrysmod and appid
GMOD="/path/to/gmod"
GMODID="4020"
# Path to bin
SERVICE="$GMOD/srcds_run"
# Name of screensession
SCREENID="ttt"
# Max Players
MAXPLAYER="16"
# AUTHKEY for the server, can be generated here --> http://steamcommunity.com/dev/apikey
AUTHKEY="2378RBJSDsomerandomgeneratednumbers783FSDFS783"
# WorkshopcollectionID can here added
WRKSHPCOLL="5472someothernumbers32562"
# -----------------------------------------------------------------------------------------
# Functions
ttt_start(){
	if ps aux | grep -v grep | grep $SERVICE >/dev/null
	then
		echo "$SERVICE is actually runnning, abort..."
		exit 1
	else
		screen -wipe
		echo "Starting $SERVICE..."
		screen -dmS $SCREENID -m sh -c "$SERVICE -console -maxplayers $MAXPLAYER -game garrysmod +gamemode terrortown +map ttt_airbus_b3 -authkey $AUTHKEY +host_workshop_collection $WRKSHPCOLL"
		sleep 3
		if ps aux | grep -v grep | grep $SERVICE >/dev/null
		then
			echo "Successfully started, have some fun! And don't forget the cookies =3"
		else
			echo "Could not start $SERVICE. Abort..."
		fi
	fi
}

ttt_stop(){
	if ps aux | grep -v grep | grep $SERVICE >/dev/null
	then
		screen -p 0 -S $SCREENID -X stuff $'quit\n'
		while ps aux | grep -v grep | grep srcds_linux >/dev/null
		do
			sleep 0.1
		done
		screen -S $SCREENID -X quit
	else
		echo "$SERVICE isn't running"
		exit 1
	fi
}

ttt_restart(){
	if ps aux | grep -v grep | grep $SERVICE >/dev/null
	then
		screen -p 0 -S $SCREENID -X stuff $'quit\n'
	else
		echo "$SERVICE isn't running"
		exit 1
	fi
}

ttt_update(){
	if ps aux | grep -v grep | grep $SERVICE >/dev/null
	then
		echo "Cannot update, $SERVICE is running"
		exit 1
	else
		# GMOD
		read -p "Type [y] to update Garrysmod: " answer
		if [ "$answer" == "y" ]
		then
			$STEAMCMD/steamcmd.sh +login anonymous +force_install_dir $GMOD +app_update $GMODID validate +quit
		else
			echo "Abort..."
			exit 255
		fi
		# CS:S
		read -p "Type [y] to update Counterstrike:Source: " answer
		if [ "$answer" == "y" ]
		then
			$STEAMCMD/steamcmd.sh +login anonymous +force_install_dir $CSS +app_update $CSSID validate +quit
		else
			echo "Abort..."
			exit 255
		fi
	fi
}

ttt_check(){
	if ps aux | grep -v grep | grep $SERVICE >/dev/null
	then
		echo "$SERVICE is running"
	else
		echo "$SERVICE isn't running"
	fi
}
# End of Functions
# -----------------------------------------------------------------------------------------

case "$1" in

	start)
		ttt_start
	;;

	stop)
		ttt_stop
	;;

	restart)
		ttt_restart
	;;

	update)
		ttt_update
	;;

	check)
		ttt_check
	;;

	*)
		echo "Command not found. {start|stop|restart|update|check}"
		exit 1
	;;
esac

exit 0

