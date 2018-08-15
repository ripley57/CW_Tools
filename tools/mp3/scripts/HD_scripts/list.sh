#!/bin/bash
#
# Description:
#	Generate a list of my music albums.
#
# $Id$

# Check we are running from the correct location.
DIRS=$(ls -1 . | egrep "(T|[A-Z]+-[A-Z]+)" | sort)
if [ "x$DIRS" = "x" ]
then
	echo "Error: This script must be run from the directory containing the music subdirs!"
	exit 1
fi

# Example:
#echo './J-N/James Taylor/Greatest Hits/wibble/wobble' | sed -n 's#\./[A-Z]-[A-Z]*/\(.*\)#\1#p' 

find . -type d -print | sed -n 's#\./[A-Z]-*[A-Z]*/\(.*/.*\)#\1#p' | sort > ~jcdc/Dropbox/Public/music.log

#find . -type f -name "*.mp3" -print | sed -n 's#\./[A-Z]-*[A-Z]*/\(.*/.*\)#\1#p' | sort > /files/Dropbox/Public/music-tracks.log

# Create PDF versions too
cat ~jcdc/Dropbox/Public/music.log | a2ps --center-title="Music" -1 -o - | ps2pdf - ~jcdc/Dropbox/Public/music.pdf
#cat /files/Dropbox/Public/music-tracks.log | a2ps --center-title="Music" -1 -o - | ps2pdf - /files/Dropbox/Public/music-tracks.pdf
