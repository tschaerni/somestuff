#!/bin/bash
# userquota parsescript by tschaerni <robin@cerny.li>
# release date: 31.03.2015 or for the illiberal users: 2015-03-31
# version: 1.1.0
#
# Changelog:
#
#	1.1.0 - added a warning if freequota lower then 1 MB
#
#	1.0.0 - release
#
# Important note:
#	The current version of this script works
#	only with a userquota on one filesystem.


GETQUOTA="$(quota -lw --hide-device | tail -1)"
USERQUOTA="$(echo "$GETQUOTA" | awk {'print $2'})"
USERAMOUNT="$(echo "$GETQUOTA" | awk {'print $1'})"
FREEQUOTA="$(( USERQUOTA-USERAMOUNT ))"

if [ "$FREEQUOTA" -lt "1000" ]
then
	echo -e "$FREEQUOTA KB \e[31mWarning:\e[0m your quota is almost reached!"
elif [ "$FREEQUOTA" -lt "1000000" ]
then
	echo "${FREEQUOTA::-3}.${FREEQUOTA: -3:1} MB"
else
	echo "${FREEQUOTA::-6}.${FREEQUOTA: -6:1} GB"
fi
exit 0
