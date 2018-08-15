TOOLS_DIR=$*

# Description:
#   Rip an audio CD to MP3 files (including track names).
#   This function uses the UI ripperx. ripperx is 
#   dependent on the following: cdparanoia, lame
#
#   Steps to rip an audio CD to MP3 files:
#   1. Install ripperx:
#        sudo apt-get install ripperx
#   2. Insert the audio CD and then start ripperx.
#   3. Set the following config options in ripperx:
#        Mp3 > 193k.
#        Files > Convert spaces to underscores.
#        Files > "Filename format string" = %# %s
#   4. [OPTIONAL] If you don’t want to create MP3 files, but 
#      want to stop after creating WAV files (e.g. when you
#      want to create a gapless recording) set the following 
#      additional ripperx options:
#        Select the radio button "Rip to WAV".
#        General > Keep wav files.
#        Uncheck "General > Make Mp3 from existing Wav file".
#   5. Click "CDDB" to download the album and track names.
#   6. Click the "Go" button to start the ripping.
#
#   NOTE: If you selected earlier to stop after creating WAV 
#         files, use the following to generate gapless MP3 
#         files (Note: The WAV files need to be in order):
#      lame --nogap -b 192 track01.wav track02.wav ...
#   You will then need to manually add any MP3 id3v2 info.
#
# Usage:
#   ripaudiocd
#
function ripaudiocd() {
    if [ "$1" = '-h' ]; then
        usage ripaudiocd
        return
    fi

    ripperx &
}

# Description:
#   Rip an audio CD to a single MP3 file.
#
#   This function is useful when copying a music
#   CD that is gapless between some music tracks.
#   See also function copycdr().
#
#   This function is dependent on the following
#   Ubuntu packages:
#     abcde
#     id3v2
#     mkcue
#
# Usage:
#   ripasonetrack
#
function ripasonetrack() {
    if [ "$1" = '-h' ]; then
        usage ripasonetrack
        return
    fi

    # Assume the CD drive is /dev/sr0
    abcde -d /dev/sr0 -N -1 -M -p -o mp3
}

# Description:
#   Copy a data or audio CD.
#   
#   This function is ideal for copying music CDs
#   that are gapless between music tracks. An
#   alternative approach is to use the function 
#   ripasonetrack(). 
#
#   NOTE: This function does not leave any MP3
#         or WAV files behind during the copy.
#   
# Usage:
#   copycdr 
#
function copycdr() {
    if [ "$1" = '-h' ]; then
        usage copycdr
        return
    fi

    cdrdao copy
}

# Description:
#   Generate Linux OS iso image. 
#
# Usage:
#   createlinuxiso
#
function createlinuxiso() {
    if [ "$1" = '-h' ]; then
        usage createlinuxiso
        return
    fi

    # Create iso image, ignoring specific directories.
    sudo genisoimage -R -m /proc -m /media -m /winxp -m /files -m /sys -o /files/linux.iso /
}

# Description:
#   Burn audio cd using mp3 or wav files in the current directory.
#   First convert any mp3 files to wav files, then burn the cd.
#
# Usage:
#   burnaudiocd
#
function burnaudiocd() {
    if [ "$1" = '-h' ]; then
        usage burnaudiocd
        return
    fi

    local _mp3_count=$(ls -1 *.mp3 2>/dev/null | wc -l)
    local _wav_count=$(ls -1 *.wav 2>/dev/null | wc -l)
    
    if [ $_mp3_count -eq 0 -a $_wav_count -eq 0 ]
    then
        echo "No audio files found. Exiting..."
        return
    fi

    for f in *
    do 
        if echo "$f" | grep -q ' '
        then
            echo "Replacing any spaces in file name $f..."
            mv "$f" `echo $f | tr ' ' '_'`; 
        fi
    done

    if [ $_mp3_count -gt 0 -a $_wav_count -eq 0 ]
    then
        echo "Converting mp3 files to wav files..."
        for f in *.mp3
        do 
            soundconverter -b -m audio/x-wav -s .wav $f
        done
    fi

    _wav_count=$(ls -1 *.wav 2>/dev/null | wc -l)
    if [ $_wav_count -le 0 ]
    then
        echo "No files to burn. Exiting..."
        return
    fi

    if _yorn "Burn audio cd of $_wav_count files? (yes|no):" -eq 0
    then
        echo "Burning audio cd..."
        wodim -pad dev=/dev/sr0 -v -audio *.wav
    fi
}

# Description:
#   Create ISO image of files in current directory and
#   burn image to CD or DVD.
#
# Usage:
#   burndatacd
#
function burndatacd() {
    if [ "$1" = '-h' ]; then
        usage burndatacd
        return
    fi

    local _iso_image_file=../image.iso
    local _generate_iso=yes

    if [ -f "$_iso_image_file" ]; then
        if _yorn "Burn existing image file $_iso_image_file? (yes|no):" -eq 0
        then
            _generate_iso=no
        fi
    fi
    
    if [ "$_generate_iso" = "yes" ]; then
        if ! _yorn "Generate iso image of current directory? (yes|no):" -eq 0
        then
           echo "Exiting..."
	   return
        fi
        # Create new iso image of the files in the current directory.
        # Create the iso image in the parent directory.
        # TODO: Directories can be exluded using the -m option like this:
        #genisoimage -J -joliet-long -input-charset iso8859-1 -R -m ./exclude_dir1 -m ./exclude_dir2 -o ../image.iso /files
        genisoimage -J -joliet-long -input-charset iso8859-1 -R -o $_iso_image_file .
    fi

    if _yorn "Burn data CD/DVD using image $_iso_image_file (yes|no):" -eq 0
    then
        echo "Burning data CD/DVD..."
        wodim -v dev=/dev/sr0 speed=10 $_iso_image_file
    fi
}

# Description:
#   List basic mp3 properties of all the files in the current directory.
#
# Usage:
#   listmp3
#
function listmp3() {
    if [ "$1" = '-h' ]; then
        usage listmp3
        return
    fi

    # Print column names.
    cat <<EOI
TRACK | FILE                          | ARTIST                        | ALBUM                         | TITLE                         | TIME
EOI

    find . -name "*.mp3" -exec "$TOOLS_DIR/mp3/mp3edit.sh" {} --list_mp3_brief \; | (read hdr ; echo "$hdr" ; sort -k1 -n)
}

# Description:
#   List all mp3 properties of all the specified file.
#
# Usage:
#   listmp3detail <mp3file>
#
# Example:
#   listmp3detail fred.mp3
#
function listmp3detail() {
    if [ "$1" = '-h' ]; then
        usage listmp3detail
        return
    fi
    "$TOOLS_DIR/mp3/mp3edit.sh" "$1" --list_mp3_detail
}

# Description:
#   Set mp3 image for all files in the current directory.
#   Default of folder.jpg will be used if no argument given.
#
# Usage:
#   setmp3image [<image.jpg>]
#
# Example:
#   setmp3image folder.jpg
#
function setmp3image() {
    local _image="folder.jpg"
    if [ "$1" = '-h' ]; then
        usage setmp3image
        return
    fi
    [ "x$1" != x ] && _image="$1"
    find . -name "*.mp3" -exec "$TOOLS_DIR/mp3/mp3edit.sh" {} --image "$_image" \;
}

# Description:
#   Set mp3 artist for all files in the current directory.
#   Use special values FOLDER or TODAY to set value.
#
# Usage:
#   setmp3artist <artist>
#
# Example:
#   setmp3artist "Dan Baird"
#   setmp3artist "FOLDER"
#   setmp3artist "TODAY" 
#
function setmp3artist() {
    if [ "$1" = '-h' ]; then
        usage setmp3artist
        return
    fi
    find . -name "*.mp3" -exec "$TOOLS_DIR/mp3/mp3edit.sh" {} --artist "$1" \;
}

# Description:
#   Set mp3 album for all files in the current directory.
#   Use special values FOLDER or TODAY to set value.
#
# Usage:
#   setmp3album <album>
#
# Example:
#   setmp3album "Love Songs for the Hearing Impaired"
#   setmp3album "FOLDER"
#   setmp3album "TODAY" 
#
function setmp3album() {
    if [ "$1" = '-h' ]; then
        usage setmp3album
        return
    fi
    find . -name "*.mp3" -exec "$TOOLS_DIR/mp3/mp3edit.sh" {} --album "$1" \;
}

# Check if the eyeD3 MP3 tagging command is available.
function _eyeD3exists() {
   if [ "$(which eyeD3 2>/dev/null)" = "/usr/bin/eyeD3" ]; then
       return 0 ;# eyeD3 exists
   fi
   return 1
}

# Embed tag info into mp3 file.
function _eyeD3addMp3Info() {
    local _file="$1"
    local _name="${_file%.*}"
    local _extn="${_file##*.}"
    local _artist="$2"
    local _album="$3"

    # Ensure a valid id3 tag.
    eyeD3 --to-v2.4 "$_file"

    # Add other info.
    eyeD3 --artist="$_artist"   "$_file"
    eyeD3 --album="$_album"	"$_file"
    eyeD3 --title="$_name"      "$_file"
}

# Embed JPEG image into mp3 file.
function _eyeD3addMp3Image() {
    local _file=$1
    local _jpeg=$2

    _jpeg=${_jpeg:=folder.jpg}

    # Ensure a valid id3 tag.
    eyeD3 --to-v2.4 "$_file"

    # Remove any existing images.
    eyeD3 --add-image=:OTHER "$_file"
    eyeD3 --add-image=:FRONT_COVER "$_file"

    # Embed image.
    eyeD3 --add-image="$_jpeg":FRONT_COVER "$_file"
}

# Extract image url from html page and download.
function _getImage() {
    local _htmlFilePath=$1     ;# Url of already-downloaded web page.
    local _embed_image_str=$2  ;# String to identify image to download.
    local _jpegName=$3         ;# Name to use for downloaded image file.

    # Use default name if necessary.
    _jpegName=${_jpegName:=folder.jpg}

    # The itunes podcast pages include 2 images. We will use the first (largest) image.
    local _sed_cmd="sed -n 's#^.*img .*alt=\"${_embed_image_str}.*src=\"\([^\"]*\\)\".*\$#\1#p' \"$_htmlFilePath\" | head -1"
    _jpegPath=$(eval "$_sed_cmd")

    # Download the image file and indicate success or failure.
    local _rtn="failure"
    wget -qO "$_jpegName" "$_jpegPath" && _rtn="success"
    echo $_rtn
}

# Download the MP3 files from itunes web page to the current directory.
function _download_itunes_mp3s() {

    # This script does the following:
    #
    # 1. Download the specified itunes podcast web page, such as the following:
    #    https://itunes.apple.com/gb/podcast/hawksbee-jacobss-clips-week/id280556947
    #
    # 2. Extract the URIs of MP3 files, by parsing lines such as following:
    #    <tr parental-rating="1" rating-podcast="1" kind="episode" role="row" metrics-loc="Track_" 
    #    audio-preview-url="http://feedproxy.google.com/~r/HJs-ClipsOfTheWeek/~5/r1rSiODTf24/talkSPORT-20121109-1614.mp3" 
    #    preview-album="Hawksbee and Jacobs&rsquo;s Clips of the Week" preview-artist="talkSPORT"
    #    preview-title="Clips of the Week - Friday, November 9" adam-id="123805159" row-number="16" class="podcast-episode">
    #
    # 3. Download the MP3 files to the current directory.

    local _itunes_web_page=$1  ;# itunes podcast page to download and scrape.
    local _embed_image_str=$2  ;# String to identify image file to embed into mp3 files.
    local _artist=$3

    local _count_from="$4"     ;# Start number. Default to 1.
    _count_from=${_count_from:=1}
    local _count_to="$5"       ;# End number.

    echo "Downloading web page..."
    wget -qO- "$_itunes_web_page" > "${TMP}/itunesmp3html"

    echo "Extracting file urls..."
    sed -n 's#^.*audio-preview-url="\([^\"]*\)\".*$#\1#p' "${TMP}/itunesmp3html" > "${TMP}/itunesmp3urls"

    echo "Downloading image to embed..."
    local _imageExists=$(_getImage "${TMP}/itunesmp3html" "$_embed_image_str" "folder.jpg")

    # Count of files available to download.
    local _mp3count=$(wc -l "${TMP}/itunesmp3urls" | cut -d' ' -f1)

    # Calculate number of files to download.
    _count_to=${_count_to:=${_mp3count}}
    local _to_download_count
    let _to_download_count=_count_to-_count_from+1

    printf "Downloading %02s MP3 files ...\n" $_to_download_count
    local _count=0
    local _sourcePath
    local _targetName
    #cat "${TMP}/itunesmp3urls" | head -1 | while read _sourcePath ;# debug - just download 1 mp3
    cat "${TMP}/itunesmp3urls" | while read _sourcePath
    do
        sleep 3 ;# Just in case we get rate-controlled.

        let _count=_count+1
        [ $_count -lt $_count_from ] && continue ;# Not at start point yet.
        [ $_count -gt $_count_to ]   && return   ;# Finished.
        
        _targetName=$(basename "$_sourcePath")
        printf "%02s: Downloading $_targetName ...\n" $_count
        wget -qO "$_targetName" $_sourcePath

        # Add MP3 info.
        if _eyeD3exists ; then
            # Add tag info.
            _eyeD3addMp3Info "$_targetName" "$_artist" "$_artist"
            if [ "$_imageExists" = "success" ]; then
                # Add image.
                _eyeD3addMp3Image "$_targetName"
            fi
        fi
    done
}

# Description:
#   Download talksport Clips of the Week podcasts from here:
#   https://itunes.apple.com/gb/podcast/hawksbee-jacobss-clips-week/id280556947
#
# Usage:
#   talksportmp3s
#
function talksportmp3s() {
    if [ "$1" = '-h' ]; then
        usage talksportmp3s
        return
    fi

    local _itunes_web_page='https://itunes.apple.com/gb/podcast/hawksbee-jacobss-clips-week/id280556947'
    local _embed_image_str='Hawksbee and Jacob'
    _download_itunes_mp3s "$_itunes_web_page" "$_embed_image_str" "talksport" "$1" "$2"
}

# Description:
#   Download Adam and Joe podcasts from here:
#   https://itunes.apple.com/gb/podcast/adam-and-joe/id272433360
#
# Usage:
#   adamandjoemp3s
#
#function adamandjoemp3s() {
#    if [ "$1" = '-h' ]; then
#        usage adamandjoemp3s
#        return
#    fi
#
#    local _itunes_web_page='https://itunes.apple.com/gb/podcast/adam-and-joe/id272433360'
#    local _embed_image_str='Adam and Joe'
#    _download_itunes_mp3s "$_itunes_web_page" "$_embed_image_str" "adamandjoe" "$1" "$2"
#}

# Description:
#   Download Coffe Break French podcasts from here:
#   https://itunes.apple.com/gb/podcast/coffee-break-french/id263170419
#
# Usage:
#   frenchmp3s
#
function frenchmp3s() {
    if [ "$1" = '-h' ]; then
        usage frenchmp3s
        return
    fi

    local _itunes_web_page='https://itunes.apple.com/gb/podcast/coffee-break-french/id263170419'
    local _embed_image_str='Coffee Break French'
    _download_itunes_mp3s "$_itunes_web_page" "$_embed_image_str" "frenchmp3s" "$1" "$2"
}

# Description:
#   Download IGN UK podcasts from here:
#   https://itunes.apple.com/gb/podcast/ign-uk-podcast/id337004125
#
# Usage:
#   ignukmp3s
#
#function ignukmp3s() {
#    if [ "$1" = '-h' ]; then
#        usage ignukmp3s
#        return
#    fi
#
#    local _itunes_web_page='https://itunes.apple.com/gb/podcast/ign-uk-podcast/id337004125'
#    local _embed_image_str='IGN UK Podcast'
#    _download_itunes_mp3s "$_itunes_web_page" "$_embed_image_str" "ignuk" "$1" "$2"
#}

# Description:
#   Download MidLife Gamer podcasts from here:
#   https://itunes.apple.com/gb/podcast/midlife-gamer-podcast/id286054457
#
# Usage:
#   midlifegamermp3s
#
#function midlifegamermp3s() {
#    if [ "$1" = '-h' ]; then
#        usage midlifegamermp3s
#        return
#    fi
#
#    local _itunes_web_page='https://itunes.apple.com/gb/podcast/midlife-gamer-podcast/id286054457'
#    local _embed_image_str='MidLife Gamer Podcast'
#    _download_itunes_mp3s "$_itunes_web_page" "$_embed_image_str" "midlifegamer" "$1" "$2"
#}

# Description:
#   Download 360 Gamercast podcasts from here:
#   https://itunes.apple.com/gb/podcast/360gamercast/id273624194
#
# Usage:
#   360gamercastmp3s
#
#function 360gamercastmp3s() {
#    if [ "$1" = '-h' ]; then
#        usage 360gamercastmp3s
#        return
#    fi
#
#    local _itunes_web_page='https://itunes.apple.com/gb/podcast/360gamercast/id273624194'
#    local _embed_image_str='360GamerCast'
#    _download_itunes_mp3s "$_itunes_web_page" "$_embed_image_str" "360gamercast" "$1" "$2"
#}

# Description:
#   Download Big Red Barrel Playstation podcasts from here:
#   https://itunes.apple.com/gb/podcast/big-red-barrel-playstation/id280159489
#
# Usage:
#   bigredbarrelmp3s
#
#function bigredbarrelmp3s() {
#    if [ "$1" = '-h' ]; then
#        usage bigredbarrelmp3s
#        return
#    fi
#
#    local _itunes_web_page='https://itunes.apple.com/gb/podcast/big-red-barrel-playstation/id280159489'
#    local _embed_image_str='Big Red Barrel'
#    _download_itunes_mp3s "$_itunes_web_page" "$_embed_image_str" "bigredbarrel" "$1" "$2"
#}

# Description:
#   Download Big Red Barrel Playstation podcasts from here:
#   https://itunes.apple.com/gb/podcast/game-scoop!/id276268226
#
# Usage:
#   ignstaffmp3s
#
#function ignstaffmp3s() {
#    if [ "$1" = '-h' ]; then
#        usage ignstaffmp3s
#        return
#    fi
#
#    local _itunes_web_page='https://itunes.apple.com/gb/podcast/game-scoop!/id276268226'
#    local _embed_image_str='Game Scoop'
#    _download_itunes_mp3s "$_itunes_web_page" "$_embed_image_str" "ignstaff" "$1" "$2"
#}

# Description:
#   Download Collings and Herrin podcasts from here:
#   https://itunes.apple.com/gb/podcast/collings-herrin-podcasts/id273173494
#
# Usage:
#   collinsherrinmp3s
#
#function collinsherrinmp3s() {
#    if [ "$1" = '-h' ]; then
#        usage collinsherrinmp3s
#        return
#    fi
#
#    local _itunes_web_page='https://itunes.apple.com/gb/podcast/collings-herrin-podcasts/id273173494'
#    local _embed_image_str='The Collings and Herrin Podcasts'
#    _download_itunes_mp3s "$_itunes_web_page" "$_embed_image_str" "collinsherring" "$1" "$2"
#}

# Description:
#   Download Richard Herrin As It Occurs To Me podcasts from here:
#   https://itunes.apple.com/gb/podcast/richard-herring-as-it-occurs/id334663849
#
# Usage:
#   asitoccurstomemp3s
#
#function asitoccurstomemp3s() {
#    if [ "$1" = '-h' ]; then
#        usage asitoccurstomemp3s
#        return
#    fi
#
#    local _itunes_web_page='https://itunes.apple.com/gb/podcast/richard-herring-as-it-occurs/id334663849'
#    local _embed_image_str='Richard Herring: As It Occurs To Me'
#    _download_itunes_mp3s "$_itunes_web_page" "$_embed_image_str" "asitoccurstome" "$1" "$2"
#}

# Description:
#   Download Richard Herrin Warming Up podcasts from here:
#   https://itunes.apple.com/gb/podcast/rich-herring-warming-up/id446472645
#
# Usage:
#   warmingupmp3s
#
#function warmingupmp3s() {
#    if [ "$1" = '-h' ]; then
#        usage warmingupmp3s
#        return
#    fi
#
#    local _itunes_web_page='https://itunes.apple.com/gb/podcast/rich-herring-warming-up/id446472645'
#    local _embed_image_str='Rich Herring - Warming Up'
#    _download_itunes_mp3s "$_itunes_web_page" "$_embed_image_str" "warmingup" "$1" "$2"
#}

# Description:
#   Download Richard Herrin Talking Cock from here:
#   https://itunes.apple.com/gb/podcast/richard-herring-talking-co*k/id605079414
#
# Usage:
#   talkingcockmp3s
#
#function talkingcockmp3s() {
#    if [ "$1" = '-h' ]; then
#        usage talkingcockmp3s
#        return
#    fi
#
#    local _itunes_web_page='https://itunes.apple.com/gb/podcast/richard-herring-talking-co*k/id605079414'
#    local _embed_image_str='Richard Herring: Talking'
#    _download_itunes_mp3s "$_itunes_web_page" "$_embed_image_str" "talkingcock" "$1" "$2"
#}

# Description:
#   Name all the files in the current directory - from "Track 01.mp3"
#   to "Track N.mp3", where there are N files in the current directory.
#
# Usage:
#   renamemp3files
#
function renamemp3files() {
    local _prefix="Track "
    if [ "$1" = '-h' ]; then
        usage renamemp3files
        return
    fi
    local _count=1
    local _fname
    ls -1 *.mp3 | while read _fname
    do
        local _fname_new=$(printf "%s %02d.mp3" $_prefix $_count)
        mv "$_fname" "$_fname_new"
        let _count=_count+1
    done
}
