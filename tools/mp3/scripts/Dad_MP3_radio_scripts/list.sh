#!/bin/bash
#
# Description:
#	Generate a list of mp3 files.

find . -type f -iname "*.mp3" -print | sort > files.log

# Create PDF version.
cat files.log | a2ps --center-title="MP3 Files" -1 -o - | ps2pdf - files.pdf

rm files.log
