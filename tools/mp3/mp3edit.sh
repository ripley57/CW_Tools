#!/bin/sh
#
# Description:
#	Query or set the mp3 tags of a file.
#
#	Use this script with a find command, e.g.:
#	find . -name "*.mp3" -exec mp3edit.sh {} --image folder.jpg \;
#
# Usage:
#	mp3edit.sh <mp3file> --list_mp3_detail
#       mp3edit.sh <mp3file> --list_mp3_brief
#       mp3edit.sh <mp3file> [--image <file>] [--album <string|FOLDER|TODAY>] [--artist <string|FOLDER|TODAY>]

debug_on=1
debug() 
{
    [ $debug_on -eq 1 ]
}

usage()
{
    PROGNAME=$(basename $0)
    cat <<EOI

Usage: 
	$PROGNAME <mp3file> --list
	$PROGNAME <mp3file> [--image <imagefile>] [--album <string|FOLDER|TODAY>] [--artist <string|FOLDER|TODAY>]

EOI
     exit 0
}

error()
{
     echo
     echo "ERROR: $*"
     exit 1
}

if [ $# -lt 1 ]; then
     usage
fi

# Convert path to absolute value.
getabs()
{
    local _tmp_dirname
    local _tmp_basename
    local _tmp_full_dir_

    case "$1" in
    /*)
        echo "$1"
        ;;
    *)
        _tmp_dirname=$(dirname "$1")
        _tmp_basename=$(basename "$1")
        _tmp_full_dir=$(cd "$_tmp_dirname" && pwd)
        echo "$_tmp_full_dir/$_tmp_basename"
        ;;
    esac
}

MP3FILE="$1"
shift

# Check that mp3 file path is valid.
dirname "$MP3FILE" >/dev/null 2>&1 || error "Bad mp3 file argument: $MP3FILE"

# Convert mp3 file to full path.
MP3FILE=$(getabs "$MP3FILE")
if [ ! -f "$MP3FILE" ]; then
    error "No such mp3 file: $MP3FILE"
fi

# Check for list option.
if [ "$1" = "--list_mp3_detail" ]; then
    eyeD3 -v "$MP3FILE"
    exit 0
fi

if [ "$1" = "--list_mp3_brief" ]; then
    # Example output from eyeD3:
    # 
    #01_track1.mp3	[ 6.59 MB ]
    #-------------------------------------------------------------------------------
    #Time: 04:48	MPEG1, Layer III	[ ~191 kb/s @ 44100 Hz - Joint stereo ]
    #-------------------------------------------------------------------------------
    #ID3 v2.4:
    #title: track1		artist: Robert Harris
    #album: Dictator_Disc_01		year: 2015
    #track: 1		

    # Convert full mpp3 file path to just the file name part.
    mp3_file_basename="$(basename "$MP3FILE")"

    eyeD3 -v --no-color "$MP3FILE" | awk -v mp3_file="$mp3_file_basename" '\
function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s } \
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s } \
function trim(s)  { return rtrim(ltrim(s));             } \
\
#BEGIN { printf("%-5s | %-29s | %-29s | %-29s | %-29s | %-29s \n", "TRACK", "FILE", "ARTIST", "ALBUM", "TITLE", "TIME"); } \
\
/Time:/   { mp3_time=$2;                                                                       } \
/title:/  { s1=$0; idx1=index(s1, "artist:"); s1=substr(s1, 8, idx1 - 8); mp3_title=trim(s1);  } \
/artist:/ { s1=$0; idx1=index(s1, "artist:"); s1=substr(s1, idx1 + 7);    mp3_artist=trim(s1); } \
/album:/  { s1=$0; idx1=index(s1, "year:");   s1=substr(s1, 7, idx1 - 7); mp3_album=trim(s1);  } \
/track:/  { mp3_track=$2;                                                                      } \
\
END { printf("%-5s | %-29s | %-29s | %-29s | %-29s | %-29s \n", mp3_track, mp3_file, mp3_artist, mp3_album, mp3_title, mp3_time); } \
'
    exit 0
fi

# Input arguments.
IMAGE=
ALBUM=
ARTIST=
while [ $# -ge 1 ]
do
	case "$1" in
	'--image')
		shift || usage
		IMAGE=$1
                debug && echo "IMAGE=$IMAGE"
		;;
	'--album')
		shift || usage
		ALBUM=$1
                debug && echo "ALBUM=$ALBUM"
		;;
	'--artist')
		shift || usage
		ARTIST=$1
                debug && echo "ARTIST=$ARTIST"
		;;
	esac
	shift
done

# Determine FOLDER value.
# Determine last part of the directory.
# For example, X, in the following path:
# /wible/wobble/X/
# This will used as the FOLDER value, if
# specified in the input arguments.
FOLDER=$(echo $PWD/ | sed -n 's#.*/\(.*\)/#\1#p')

# Determine TODAY value.
# For example, 2014-06-25
# This will be used as the DATE value, if
# specified in the input arguments.
TODAY=$(date +%Y-%m-%d)

echo "***********************"
echo "Processing $MP3FILE... "
	
# Ensure a valid id3 tag.
eyeD3 --to-v2.4 "$MP3FILE" 

# Strip comments.
eyeD3 --remove-all-comments "$MP3FILE" 

# Embed image.
if [ "x$IMAGE" != "x" ]; then
    # Our new image to embed.
    IMAGE=$(dirname "$MP3FILE")/$IMAGE
    [ -f "$IMAGE" ] || error "No such image file: $IMAGE"

    # Remove existing images.
    eyeD3 --remove-all-images "$MP3FILE" 
    ##eyeD3 --add-image=:OTHER "$MP3FILE"
    ##eyeD3 --add-image=:FRONT_COVER "$MP3FILE"
    ##id3v2 --APIC “” "$MP3FILE"

    # Embed our new image.
    eyeD3 --add-image="$IMAGE":FRONT_COVER "$MP3FILE"
fi

# Set album.
if [ "x$ALBUM" != "x" ]; then
    [ "$ALBUM" = "FOLDER" ] && ALBUM="$FOLDER"
    [ "$ALBUM" = "TODAY"  ] && ALBUM="$TODAY"
    eyeD3 --album="$ALBUM" "$MP3FILE"
fi

# Set artist.
if [ "x$ARTIST" != "x" ]; then
    [ "$ARTIST" = "FOLDER" ] && ARTIST="$FOLDER"
    [ "$ARTIST" = "TODAY"  ] && ARTIST="$TODAY"
    eyeD3 --artist="$ARTIST" "$MP3FILE"
fi

echo "Finshed updating $MP3FILE !"
echo "***********************"
