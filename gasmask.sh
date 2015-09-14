#!/bin/bash - 
#===============================================================================
#
#          FILE: gasmask.sh
# 
#         USAGE: ./gasmask.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: A script to modify the hosts file of the system to block ads.
#                With integrated update function.
#                used hosts file is from: http://winhelp2002.mvps.org
#        AUTHOR: Robin "tschaerni" Cerny (rc), robin@cerny.li
#  ORGANIZATION: 
#       CREATED: 02.09.2015 07:03
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

HOSTSFILE="/etc/hosts"
GMCFGDIR="/etc/gasmask"
HOSTSURL="http://winhelp2002.mvps.org/hosts.txt"
HOSTSBACKUP="$GMCFGDIR/hosts.gasmaskbak"
ADDHOSTS="$GMCFGDIR/additional_hosts.txt"
MVPORIG="$GMCFGDIR/mvp_hosts.txt"
TMPDIR="/tmp"

if ! [[ -d $GMCFGDIR ]]
then
	echo "creating $GMCFGDIR"
	mkdir -p "$GMCFGDIR"
fi

update_filter(){
	wget -q -O "$TMPDIR" "$HOSTSURL"
	NEWCHKSUM=$(md5sum $TMPDIR/hosts.txt | cut -d ' ' -f 1)
	OLDCHKSUM=$(md5sum $MVPORIG | cut -d ' ' -f 1)
	if [[ "$NEWCHKSUM" = "$OLDCHKSUM" ]]
	then
		echo "No new entries found abort update."
	else
		echo "New entries found, updating hostsfile"
		mv $TMPDIR/hosts.txt $MVPORIG
	fi
	echo -e "done\n"
}

enable_filter(){
	echo "copy $HOSTSFILE to $HOSTSBACKUP"
	cp $HOSTSFILE $HOSTSBACKUP
	echo "adding MVP and possible additional entries to $HOSTSFILE"
	cat $ADDHOSTS $MVPORIG > $HOSTSFILE
	echo "done\n"
}

disable_filter(){
	echo "copy $HOSTSBACKUP to $HOSTSFILE"
	cp $HOSTSBACKUP $HOSTSFILE
	echo "done\n"
}

if $#

case in $1
	"--disable"|"--off")
		disable_filter
	;;
	"--enable"|"--on")
		enable_filter
	;;
	"--update"|"-u")

