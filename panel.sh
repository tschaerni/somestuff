#!/bin/bash - 
#===============================================================================
#
#          FILE: panel.sh
# 
#         USAGE: ./panel.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Robin Cerny (rc), tschaerni@gmail.com
#  ORGANIZATION: private
#       CREATED: 07.12.2013 18:11:20 CET
#      REVISION:  ---
#===============================================================================

#set -o nounset                              # Treat unset variables as an error

#Settings:
BASEDIR=$(dirname `readlink -f $0`)
GAMENAME="direwolf server"
SCREENSESSION=direwolf
LOCK=$BASEDIR/shutdown_new.lock
TIMESTAMP=$(date +%d-%m-%Y_%H%M)
BACKUPHISTORY=3
PROPERTIES="$BASEDIR/server.properties"
cd $BASEDIR

usage(){
	echo -e \
"Unknown or no option
Use panel: $0 {start|stop|instantstop|restart|instantrestart|save|backup|pidof|kill|removedrop|instantremovedrop|compresslog|switchmode}

Options:
start			Starts the $GAMENAME in screensession $SCREENSESSION
stop			Stops the $GAMENAME and terminate screensession $SCREENSESSION with a delay of 5min
instantstop		Stops the $GAMENAME without delay
restart			Restarts the $GAMENAME with a delay of 5min
instantrestart		Restarts the $GAMENAME without a delay
backup			Make a backup now
save			Save the Database to Disk
pidof			Shows the current PID
kill			Kill the runnning $GAMENAME
removedrop		Remove all drops with a delay of 1min
instantremovedrop	Remove all drops without a delay
compresslog		Compress all server.log
switchmode		Switches the online mode"
}

pid(){
	pids=$(ps aux | grep mcpc.jar | grep -v grep | grep -v SCREEN | grep -v rlwrap | awk -F" " '{print $2}')
	echo "$pids"
}


start(){
	
	if [[ -z $(screen -ls $SCREENSESSION | grep $SCREENSESSION | grep tached) ]] ; then

		echo "Starting screen session '$SCREENSESSION'..."
		screen -d -m -S $SCREENSESSION
		echo "starting $GAMENAME on screensession '$SCREENSESSION'."
		screen -S $SCREENSESSION -p 0 -X stuff "./mcstart.sh$(printf \\r)"
		#echo "execute command PEX in 3 min"
		#sleep 1m
		#echo "execute command PEX in 2 min"
		#sleep 1m
		#echo "execute command PEX in 1 min"
		#sleep 1m
		#screen -S $SCREENSESSION -p 0 -X stuff "pex set default group Spieler$(printf \\r)"

	else

		if [[ -z $(pid) ]] ; then

			echo "using existing screen session '$SCREENSESSION'..."
			echo "starting $GAMENAME on screensession '$SCREENSESSION'."
			screen -S $SCREENSESSION -p 0 -X stuff "./mcstart.sh$(printf \\r)"
			#echo "execute command PEX in 3 min"
			#sleep 1m
			#echo "execute command PEX in 2 min"
			#sleep 1m
			#echo "execute command PEX in 1 min"
			#sleep 2m
			#screen -S $SCREENSESSION -p 0 -X stuff "pex set default group Spieler$(printf \\r)"

		else

			echo "There is a running screen session '$SCREENSESSION', and a running $GAMENAME. Please Check manually."

		fi

	fi
}

stop(){
	echo "$MESSAGE the $GAMENAME on screensession "$SCREENSESSION"."
	screen -S $SCREENSESSION -p 0 -X stuff "say $MESSAGE in 5 Min.!$(printf \\r)"
	echo "$MESSAGE in 5min"
	sleep 60
	screen -S $SCREENSESSION -p 0 -X stuff "say $MESSAGE in 4 Min.!$(printf \\r)"
	echo "$MESSAGE in 4min"
	sleep 60
	screen -S $SCREENSESSION -p 0 -X stuff "say $MESSAGE in 3 Min.!$(printf \\r)"
	echo "$MESSAGE in 3min"
	sleep 60
	screen -S $SCREENSESSION -p 0 -X stuff "say $MESSAGE in 2 Min.!$(printf \\r)"
	echo "$MESSAGE in 2min"
	sleep 60
	screen -S $SCREENSESSION -p 0 -X stuff "say $MESSAGE in 1 Min.!$(printf \\r)"
	echo "$MESSAGE in 1min"
	sleep 30
	screen -S $SCREENSESSION -p 0 -X stuff "say $MESSAGE in 30 Sek.!$(printf \\r)"
	echo "$MESSAGE in 30sec"
	sleep 25
	screen -S $SCREENSESSION -p 0 -X stuff "say $MESSAGE in 5sec.!$(printf \\r)"
	sleep 5
	screen -S $SCREENSESSION -p 0 -X stuff "kickall Server $MESSAGE!$(printf \\r)"
	sleep 2
	screen -S $SCREENSESSION -p 0 -X stuff "save-all$(printf \\r)"
	screen -S $SCREENSESSION -p 0 -X stuff "stop$(printf \\r)"
	echo "Save database"

}

save(){
	echo "Saving database."
	screen -S $SCREENSESSION -p 0 -X stuff "save-all$(printf \\r)"
}

backup(){

	if [ -d $BASEDIR/backup ]
	then
		echo "Starte Backupprozess"
	else
		echo "erstelle Backupverzeichnis unter $BASEDIR/backup"
		mkdir $BASEDIR/backup
	fi

	if ps aux | grep mcpc.jar | grep -v grep | grep -v SCREEN | grep -v rlwrap | awk -F" " '{print $2}' >/dev/null
	then
		echo "$GAMENAME läuft. Starte Backup"
		screen -S $SCREENSESSION -p 0 -X stuff "say §3Starte Backup$(printf \\r)"
		screen -S $SCREENSESSION -p 0 -X stuff "save-off$(printf \\r)"
		screen -S $SCREENSESSION -p 0 -X stuff "save-all$(printf \\r)"
		sleep 5
		sync
		sleep 5
#		tar cfv $BASEDIR/backup/fuyb_backup_$TIMESTAMP.tar $BASEDIR/FeedUpYourBeast
		zip -r $BASEDIR/backup/world_backup_$TIMESTAMP.zip $BASEDIR/World
		if [ "$?" == "0" ] ; then
			screen -S $SCREENSESSION -p 0 -X stuff "say §3Backup erfolgreich abgeschlossen.$(printf \\r)"
			echo "Backup erfolgreich abgeschlossen."
		else
			screen -S $SCREENSESSION -p 0 -X stuff "say §3Backup hat sich mit Fehlern beendet.$(printf \\r)"
			echo "Backup hat sich mit Fehlern beendet. Bitte nachprüfen."
		fi
		screen -S $SCREENSESSION -p 0 -X stuff "save-on$(printf \\r)"
		echo "Gelöscht werden:"
		echo $(find $BASEDIR/backup -type d -mtime +$BACKUPHISTORY)
		echo "Lösche alte Backups"
		find $BASEDIR/backup -type d -mtime +$BACKUPHISTORY | grep -v -x "$BASEDIR/backup" | xargs rm -rf

	else

		echo "$GAMENAME läuft nicht. Starte Backup"
		sync
		tar cfv $BASEDIR/backup/world_backup$TIMESTAMP.tar $BASEDIR/World
		if [ "$?" == "0" ] ; then
			echo "Backup erfolgreich abgeschlossen"
		else
			echo "Backup wurde mit Fehlern beendet. Bitte nachprüfen."
		fi
#		echo "Komprimiere..."

#		for file in $BASEDIR/backup/*.tar
#		do
#			gzip -9 "$file"
#		done

#		echo "Backups wurden komprimiert."
#		echo "Gelöscht werden:"
#		echo $(find $BASEDIR/backup -type d -mtime +$BACKUPHISTORY)
#		echo "Lösche alte Backups"
#		find $BASEDIR/backup -type d -mtime +$BACKUPHISTORY | grep -v -x "$BASEDIR/backup" | xargs rm -rf
		echo "Fertig."

	fi
}

#backupcompress(){
#	echo "Komprimiere Backups"
#	for file in $BASEDIR/backup/*.tar
#	do
#		gzip -9 "$file"
#	done
#	echo "Backups wurden komprimiert. Fertig"
#}

removedrop(){
	echo "Lösche alle herumliegenden Items..."
	screen -S $SCREENSESSION -p 0 -X stuff "remove drop -1$(printf \\r)"
#	sleep 2s
#	screen -S $SCREENSESSION -p 0 -X stuff "stoplag$(printf \\r)"
#	sleep 2s
#	screen -S $SCREENSESSION -p 0 -X stuff "stoplag -c$(printf \\r)"
#	sleep 1s
	screen -S $SCREENSESSION -p 0 -X stuff "say §3Alle herumliegenden Items wurden gelöscht$(printf \\r)"
	screen -S $SCREENSESSION -p 0 -X stuff "pex set default group Spieler$(printf \\r)"
}

online_mode(){
	echo "Switche Online mode..."
	if grep "online-mode=true" $PROPERTIES >/dev/null
	then
		sed -i "s/online-mode=true/online-mode=false/g" $PROPERTIES
		echo "Online mode ist jetzt false"
	elif grep "online-mode=false" $PROPERTIES >/dev/null
	then
		sed -i "s/online-mode=false/online-mode=true/g" $PROPERTIES
		echo "Online mode ist jetzt true"
	fi
}

case $1 in

	start)
		start
	;;

	stop)
		touch $LOCK
		MESSAGE=§3Stop
		stop
	;;

	instantstop)
		touch $LOCK
		MESSAGE=§3Neustart
		screen -S $SCREENSESSION -p 0 -X stuff "kickall Server $MESSAGE!$(printf \\r)"
		sleep 3
		screen -S $SCREENSESSION -p 0 -X stuff "save-all$(printf \\r)"
		screen -S $SCREENSESSION -p 0 -X stuff "stop$(printf \\r)"
		echo "Speichere Datenbank ..."
	;;

	save)
		save
	;;

	restart)
		MESSAGE=§3Neustart
		stop
		echo "$MESSAGE wird vorbereitet ..."
	;;

	instantrestart)
		MESSAGE=§3Neustart
		screen -S $SCREENSESSION -p 0 -X stuff "kickall Server $MESSAGE!$(printf \\r)"
		sleep 3
		screen -S $SCREENSESSION -p 0 -X stuff "stop$(printf \\r)"
		echo "Save database"
	;;

	backup)
		backup
	;;

#	backupcompress)
#		backupcompress
#	;;

	pidof)
		pid
	;;

	kill)
		runningpid=$(pid)
		echo "kill the $GAMENAME PID: $runningpid"
		kill $runningpid
		echo "kill executed, please check."
	;;

	removedrop)
		currenttime=$(date +%H%M)
		if [ -f $LOCK ] ; then
			exit 1
		else
			if [ "$currenttime" != "0300" ]
			then
				screen -S $SCREENSESSION -p 0 -X stuff "pex set default group Spieler$(printf \\r)"
				screen -S $SCREENSESSION -p 0 -X stuff "say §3In einer Minute werden alle herumliegenden Items gelöscht!$(printf \\r)"
				sleep 60
				removedrop
				sleep 5
				save
			fi
		fi
	;;

	instantremovedrop)
		if [ -f $LOCK ] ; then
			exit 1
		else
			screen -S $SCREENSESSION -p 0 -X stuff "pex set default group Spieler$(printf \\r)"
			removedrop
			sleep 5
			save
		fi
	;;

	compresslog)
		zip -r -j $BASEDIR/logs/serverlog.zip $BASEDIR/logs/*.txt
		#if [ "$?" == "0" ] ; then
			rm $BASEDIR/logs/*.txt
		#fi
	;;

	switchmode)
		online_mode
		sleep 3
		stop
		echo "Neustart wird vorbereitet"
	;;

	*)
		usage
		exit 1
	;;

esac

exit 0
