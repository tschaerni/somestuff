#!/bin/bash

read -p "Raidtype: " RTYPE
echo "Raidtype: $RTYPE"
read -p "Number of Disks: " NDISKS
echo "Number disks: $NDISKS"
read -p "Single disk size in TB: " DSIZE
echo "Disk size: $DSIZE"

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
