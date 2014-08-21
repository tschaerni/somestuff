#!/bin/bash - 
#===============================================================================
#
#          FILE: mcstart.sh
# 
#         USAGE: ./mcstart.sh 
# 
#   DESCRIPTION: Start script for a minecraft Server
# 
#       OPTIONS: ---
#  REQUIREMENTS: screen, java
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Robin Cerny (rc), tschaerni@gmail.com
#  ORGANIZATION: private
#       CREATED: 29.11.2013 04:15:59 CET
#      REVISION:  ---
#===============================================================================

#set -o nounset                              # Treat unset variables as an error

trap "kill -TERM -$$" INT

# Settings
BASEDIR=$(dirname `readlink -f $0`)
SCRIPTNAME=$(basename $0)
SERVICE="./mcpc-251.jar"
PID=$$
PIDFILE=/tmp/direwolf_new.pid
LOCK=$BASEDIR/shutdown_new.lock
SCREENSESSION=direwolf
TIMESTAMP=$(date +%d-%m-%Y_%H%M)
cmd="ionice -c2 -n0 nice -n -10 rlwrap java -Xms10G -Xmx10G -XX:PermSize=256M -XX:MaxPermSize=512M -XX:UseSSE=4 -XX:ParallelGCThreads=8 -XX:+UseConcMarkSweepGC -XX:+UseCMSCompactAtFullCollection -XX:+UseParNewGC -XX:+DisableExplicitGC -XX:+AggressiveOpts -d64 -jar $SERVICE nogui"

cd $BASEDIR

shutdowncmd(){
	echo "Initiate Shutdown"
	rm $LOCK
	rm $PIDFILE
	screen -d $SCREENSESSION
	screen -S $SCREENSESSION -X kill
	exit 0
}

ENDEXECUTION=0

if [ -f "$PIDFILE" ] ; then

	RUNNINGPID=$(cat "$PIDFILE")
	PROGRAMPID=$(ps ax | grep "$SCRIPTNAME" | grep -v grep | awk '{print $1;}')

	for PIDEL in $PROGRAMPID
	do
		if [ "$PIDEL" == "$RUNNINGPID" ] ; then

			ENDEXECUTION=1
			break

		fi
	done

fi

if [ "$ENDEXECUTION" == "1" ] ; then

	echo "There is already a Running $SCREENSESSION server, abort..."
	exit 1

fi

echo $PID > $PIDFILE

while true; do

	if [ -f $LOCK ] ; then

		shutdowncmd

	else

		if [ -d $BASEDIR/logs ] ; then
			cp $BASEDIR/server.log $BASEDIR/logs/serverlog_$TIMESTAMP.txt
			sleep 0.5
			echo " " > $BASEDIR/server.log
			sleep 0.5
		else
			mkdir $BASEDIR/logs
			sleep 0.5
			cp $BASEDIR/server.log $BASEDIR/logs/serverlog_$TIMESTAMP.txt
			sleep 0.5
			echo " " > $BASEDIR/server.log
			sleep 0.5
		fi

		echo "Starting $SCREENSESSION server"
		echo "running command: '$cmd'"
		$cmd

	fi

	sleep 1

done

# EOF
