#!/bin/bash
#
# Description:
#	Sync music files from PC /files/music to external hard disk.
#	This script must be run from the /files/music directory on the PC.
#
# $Id$

DEST="/media/jcdc/Seagate\ Backup\ Plus\ Drive/music/"

if [ ! -w /etc/passwd ]
then
	echo "Error: You must be root to run this script!"
	exit 1
fi

# Check we are running from the correct location.
DIRS=$(ls -1 . | grep -v sync | egrep "(T|[A-Z]+-[A-Z]+)" | sort)
if [ "x$DIRS" = "x" ]
then
	echo "Error: This script must be run from the directory containing the music subdirs!"
	exit 1
fi

COUNT=0
CHOICES=
for D in $DIRS
do
	COUNT=`expr $COUNT + 1`
	CHOICES="$COUNT:$D,$CHOICES"
	echo "$COUNT) $D"
done
echo "x) exit"

syncdir() {
	SUBDIR=$(echo $CHOICES | tr ',' '\n' | grep "^$1:" | awk -F: '{print $2}')
	CMD="rsync -rcvW --progress ./$SUBDIR/ "$DEST"/$SUBDIR/ "
	echo "*** PRESS RETURN TO RUN THE FOLLOWING SYNC:"
	echo "$CMD"
	read DUMMY
	eval "$CMD"
}


while [ "$ans" != x ]
do
	echo -n "Select directory to sync (1-$COUNT): "
	read ans
	if [ "$ans" != x ]
	then
		syncdir "$ans"
	fi
done

