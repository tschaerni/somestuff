#!/bin/bash
# userquota parsescript by tschaerni <robin@cerny.li>
# release date: 31.03.2015 or for the illiberal users: 2015-03-31
# version: 1.0.0
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
	FREEQUOTA="$FREEQUOTA KB"
elif [ "$FREEQUOTA" -lt "1000000" ]
then
	FREEQUOTA="${FREEQUOTA::-3}.${FREEQUOTA: -3:1} MB"
else
	FREEQUOTA="${FREEQUOTA::-6}.${FREEQUOTA: -6:1} GB"
fi
echo "$FREEQUOTA"
exit 0
