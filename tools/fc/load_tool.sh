TOOLS_DIR=$*

# Description:
#   Download and launch FreeCommander Portable (https://freecommander.com/en/downloads/).
#
#   To list directories and files together by last modified date:
#   "Tools" > "Settings..." > "View" > "File/folder list" > "Sorting" (tab) > "Folders like files"
#   (See https://freecommander.com/forum/viewtopic.php?t=7550)
#
#   FreeCommander command-line options:
#   https://freecommander.com/fchelpxe/en/Commandlineparameters.html
#
# Usage:
#   fc [dirpath]
#
function fc() {
	if [ "$1" = '-h' ]; then
     	usage fc
     	return
  fi
	
	local fc_download="https://www.dropbox.com/s/ri5asskq94l9vq0/FreeCommanderPortable.zip?dl=1"
	local fc_zip="FreeCommanderPortable.zip"
	local fc_exe="$TOOLS_DIR/fc/FreeCommanderXE-32-public_portable/FreeCommander.exe"
  
	# Delete the existing zip download if the file size was zero bytes, as
	# this was probably a failed download due to lack of Internet connection.
	(cd "$TOOLS_DIR/fc" && [ -f "$fc_zip" ] && [ ! -s "$fc_zip" ] && rm "$fc_zip")
	
	# Download.
	if [ ! -f "$TOOLS_DIR/fc/$fc_zip" ]; then
        (cd "$TOOLS_DIR/fc" && download_file "$fc_download" "$fc_zip")
	fi
		
	# Extract.
	if [ ! -f "$fc_exe" ]; then
        (cd "$TOOLS_DIR/fc" && unzip "$fc_zip" && chmod ugo+rx "$fc_exe")
	fi
	
	# Launch.
	"$fc_exe" &
}
