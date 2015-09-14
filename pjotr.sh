#!/bin/bash - 
#===============================================================================
#
#          FILE: pjotr.sh
# 
#         USAGE: ./pjotr.sh 
# 
#   DESCRIPTION: download & merge script for videos. You can run it for multiple
#                times for multiple video files on the same terminal with:
#                ./pjotr.sh FILENAME URL1 URL2 URL3 &>/dev/null &
# 
#       OPTIONS: ---
#  REQUIREMENTS: youtube-dl,ffmpeg, bash
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Robin "tschaerni" Cerny (rc), robin@cerny.li
#  ORGANIZATION: 
#       CREATED: 14.09.2015 20:29
#      REVISION:  ---
#===============================================================================

#set -o nounset                              # Treat unset variables as an error

if [[ "$#" = 0 ]]
then
	echo -e "\n\tusage: $0 FILENAME URL1 URL2 URL3 etc.\n"
	exit 1
fi



if echo "$1" | egrep -q '(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
then
	echo -e "\n\tYou have not set a proper filename."
	echo -e "\tHint: you are using a URL as filename!\n"
	echo -e "\n\tusage: $0 FILENAME URL1 URL2 URL3 etc.\n"
	exit 2
fi

DOWNLOADDIR="/tmp"
UNIXTSTAMP="$(date +%s)"
NUM="1"
URLNUM="$(($#-1))"
FILENAME="$1"
LISTFILE="$DOWNLOADDIR/list-$UNIXTSTAMP.txt"
shift

while [[ "$#" != "0" ]]
do
	echo -e "\nDownload video $NUM/$URLNUM"
	youtube-dl -q -o "$DOWNLOADDIR/video-$NUM-$UNIXTSTAMP.mp4" "$1" && echo -e "Video $NUM/$URLNUM finished."
	echo "file 'video-$NUM-$UNIXTSTAMP.mp4'" >> "$LISTFILE"
	let NUM++
	shift
done

echo -e "Download finished."
echo -e "\nMerging video files..."

ffmpeg -nostats -loglevel 0 -f concat -i "$LISTFILE" -c copy "$FILENAME"

echo -e "Merging done."
echo -e "\nCleaning up..."

rm "$LISTFILE" "$DOWNLOADDIR"/video-*-"$UNIXTSTAMP".mp4

echo -e "\nDone."
exit 0

