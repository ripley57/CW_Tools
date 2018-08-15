#!/bin/bash
#
# Description:
#	Sync music files from external hard disk to TonidoPlug.
#	This script must be run from the directory containing
#	the music subdirs A-C, D-I, J-N, O-S, T, and U-Z on 
#       the external hard disk.
#
# $Id$

TONIDO_SSH_PORT=22
TONIDO_SSH_DEST=root@192.168.1.12:/files/music

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
	CMD="rsync -rlcvP -e 'ssh -p $TONIDO_SSH_PORT' ./$SUBDIR/ $TONIDO_SSH_DEST/$SUBDIR/"
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

