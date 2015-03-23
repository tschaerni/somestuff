#!/bin/bash

raid_0() {
	CAPACITY=$(echo "scale=3;$NDISKS*$DSIZE" | bc | | sed "s/^\(-\)\?\./\10./")
	echo "$CAPACITY"
}

raid_1() {
	echo raid1
	CAPACITY="$DSIZE"
}

raid_5() {
	echo raid5
	NDISKS=3
	DSIZE="1.5"
	CAPACITY=$(echo "scale=3;$DSIZE*($NDISKS-1)" | bc | sed "s/^\(-\)\?\./\10./")
	echo "$CAPACITY"
}

raid_5

raid_5E() {
	echo raid5e
}

raid_5EE() {
	echo raid5ee
}

raid_6() {
	echo raid6
}

raid_10() {
	echo raid10
}

exit 255

case "$RTYPE" in
	0)
		echo "using RAID 0"
	;;
	1)
		echo "using RAID 1"
	;;
	5)
		echo "using RAID 5"
	;;
	6)
		echo "using RAID 6"
	;;
	10)
		echo "using RAID 10"
	;;
	*)
		echo "Not a valid RAID level."
	;;
esac

read -p "Raidtype: " RTYPE
echo "Raidtype: $RTYPE"
read -p "Number of Disks: " NDISKS
echo "Number disks: $NDISKS"
read -p "Single disk size in TB: " DSIZE
echo "Disk size: $DSIZE"


